import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/chunk_model.dart';

class Worker {
  Worker._(this._id, this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }
  final int _id;
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  // Initialize database connections for this worker
  Future<void> initialize(
    String snapshotName,
    PostgresConnectionInfo dumperInfo,
    PostgresConnectionInfo loaderInfo,
  ) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<void>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;

    // Send command to initialize connections in the isolate
    _commands.send((id, 'initialize', snapshotName, dumperInfo, loaderInfo));
    return completer.future;
  }

  // Command from main isolate to process a chunk
  Future<Object?> processChunk(Chunk chunk) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;

    // Send command to do work, processed by _handleCommandsToIsolate()
    print(
      'this is worker id $_id on queue id $_idCounter on chunk id ${chunk.id}',
    );

    // Send just the chunk - connections are already established
    _commands.send((id, 'process_chunk', chunk));
    return completer.future;
  }

  // Command from main isolate to do work
  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;

    // Send command to do work, processed by _handleCommandsToIsolate()
    _commands.send((id, message));
    return completer.future;
  }

  static Future<Worker> spawn(int id) async {
    // Create a receive port and add its initial message handler
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (SendPort initialMessage) {
      final commandPort = initialMessage;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
        // Saving the file removes the comma but the analyzer wants one /shrug
        // ignore: require_trailing_commas
      ));
    };

    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(id, receivePort, sendPort);
  }

  // Receives commands from the SendPort _commands.send()
  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    Connection? dumperConn;
    Connection? loaderConn;

    receivePort.listen((message) async {
      // Do different things based on the "message"
      print(message);

      // Handle shutdown command
      if (message == 'shutdown') {
        // Close connections if they exist
        if (dumperConn != null) {
          await dumperConn!.close();
        }
        if (loaderConn != null) {
          await loaderConn!.close();
        }
        receivePort.close();
        return;
      } else if (message
              is (
                int,
                String,
                String,
                PostgresConnectionInfo,
                PostgresConnectionInfo,
              ) &&
          message.$2 == 'initialize') {
        final (
          int id,
          String step,
          String snapshotName,
          PostgresConnectionInfo dumperInfo,
          PostgresConnectionInfo loaderInfo,
        ) = message;

        try {
          // (pgtk-dumper) Define the dumper client.
          //
          // This is a Postgres connection to the publisher to dump tables.
          final dumperClient = PostgresClient.standard(
            connectionInfo: dumperInfo,
            applicationName: 'pgtk-dumper-$id',
          );

          // (pgtk-loader) Define the loader client.
          //
          // This is a Postgres connection to the subscriber to load tables.
          final loaderClient = PostgresClient.standard(
            connectionInfo: loaderInfo,
            applicationName: 'pgtk-loader-$id',
          );

          // Open connections
          dumperConn = await Connection.open(
            Endpoint(
              host: dumperInfo.host,
              port: dumperInfo.port,
              database: dumperInfo.database,
              username: dumperInfo.username,
              password: dumperInfo.password,
            ),
            settings: ConnectionSettings(
              applicationName: dumperClient.applicationName,
              connectTimeout: const Duration(seconds: 10),
              queryMode: dumperClient.queryMode,
              replicationMode: dumperClient.replicationMode,
              sslMode: dumperClient.sslMode,
              timeZone: 'UTC',
            ),
          );

          // (pgtk-pub-helper) Start a read only transaction
          var sql =
              'BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;';

          await dumperConn!.execute(sql);

          sql = "SET TRANSACTION SNAPSHOT '$snapshotName';";

          await dumperConn!.execute(sql);

          loaderConn = await Connection.open(
            Endpoint(
              host: loaderInfo.host,
              port: loaderInfo.port,
              database: loaderInfo.database,
              username: loaderInfo.username,
              password: loaderInfo.password,
            ),
            settings: ConnectionSettings(
              applicationName: loaderClient.applicationName,
              connectTimeout: const Duration(seconds: 10),
              queryMode: loaderClient.queryMode,
              replicationMode: loaderClient.replicationMode,
              sslMode: loaderClient.sslMode,
              timeZone: 'UTC',
            ),
          );

          // Send success message back
          sendPort.send((id, 'Connections initialized successfully'));
        } on Exception catch (e) {
          sendPort.send((id, RemoteError(e.toString(), '')));
        }
      } else if
      // Handle chunk processing
      (message is (int, String, Chunk) && message.$2 == 'process_chunk') {
        final (int id, _, Chunk chunk) = message;

        try {
          if (dumperConn == null || loaderConn == null) {
            throw StateError('Database connections not initialized');
          }

          // Fetch data
          final sql =
              'SELECT * FROM ${chunk.table.fullTableName} ORDER BY ${chunk.settings.orderBy.join(',')} LIMIT ${chunk.settings.chunkSize} OFFSET ${chunk.offset};';

          final result = await dumperConn!.execute(sql);
          final rows = result.map((row) => row.toList()).toList();
          final chunkWithData = chunk.copyWith(rows: rows);

          // Insert data if there are rows
          if (rows.isNotEmpty) {
            final insertSql =
                'INSERT INTO ${chunk.table.fullTableName} VALUES ${chunkWithData.batchInsertValues};';
            await loaderConn!.execute(insertSql);
          }

          // Send back the result
          sendPort.send((
            id,
            'Processed chunk ${chunk.id} with ${rows.length} rows',
            // Saving the file removes the comma but the analyzer wants one /shrug
            // ignore: require_trailing_commas
          ));
        } on Exception catch (e) {
          sendPort.send((id, RemoteError(e.toString(), '')));
        }
      } else {
        // message could be this object, add more ifs
        // perhaps pass chunk? and somehow looks up dumper/loader client
        final (int id, String jsonText) = message as (int, String);

        try {
          final jsonData = jsonDecode(jsonText);

          // Sends message back to _handleResponsesFromIsolate
          sendPort.send((id, jsonData));
        } on Exception catch (e) {
          sendPort.send((id, RemoteError(e.toString(), '')));
        }
      }
    });
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // Do different things based on the "message"

    // message could be string
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      print('_handleResponsesFromIsolate complete id $_id');
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send(
        'shutdown',
      ); // This will close the database connections in the isolate
      if (_activeRequests.isEmpty) _responses.close();
      print('--- worker id $_id port closed --- ');
    }
  }
}

// Database operations moved to WorkerPoolService
