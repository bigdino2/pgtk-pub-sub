import 'dart:io';

import 'package:pgtk_common/pgtk_common.dart';

class PostgresService {
  /// Open a connection to Postgres.
  Future<Response<Connection>> openConnection(PostgresClient client) async {
    try {
      final conn = await _openConnection(client);
      return Response.success(conn);
    } on SocketException catch (error, stackTrace) {
      return Response.error(
        'Could not connect to Postgres at ${client.connectionInfo.host}:${client.connectionInfo.port}${client.replicationMode != ReplicationMode.none ? ' in replication mode.' : '.'}',
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Open and close a connection to Postgres to test connectivity.
  ///
  /// On success, returns a message with the server version.
  Future<Response<String>> testConnection(PostgresClient client) async {
    try {
      final conn = await _openConnection(client);
      final serverVersion = conn.info.parameters.serverVersion;
      await conn.close();

      return Response.success(
        '(${client.applicationName}) Connectivity to Postgres at ${client.connectionInfo.host}:${client.connectionInfo.port}${client.replicationMode != ReplicationMode.none ? ' in replication mode ' : ' '}succeeded! Server version: $serverVersion',
      );
    } on SocketException catch (error, stackTrace) {
      return Response.error(
        '(${client.applicationName}) Connectivity to Postgres at ${client.connectionInfo.host}:${client.connectionInfo.port}${client.replicationMode != ReplicationMode.none ? ' in replication mode ' : ' '}failed!',
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Start a read only transaction in repeatable read.
  Future<Response<void>> beginReadOnlyTransaction(Connection connection) async {
    const sql = 'BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;';

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      await connection.execute(sql);
      return Response.success(null, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Create a publication.
  Future<Response<void>> createPublication(
    Connection connection, {
    required Publication publication,
  }) async {
    final sql =
        'CREATE PUBLICATION ${publication.name} FOR TABLE ${publication.fullTableNameList.join(',')}';

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      await connection.execute(sql);
      return Response.success(null, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Create a replication slot and return the snapshot name.
  ///
  /// Requires a connection in replication mode.
  Future<Response<String>> createReplicationSlotInReplMode(
    Connection connection, {
    required Publication publication,
    bool temporary = false,
  }) async {
    final sql =
        'CREATE_REPLICATION_SLOT ${publication.replicationSlotName} LOGICAL pgoutput EXPORT_SNAPSHOT;';

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      final result = await connection.execute(sql);
      final row = result.first;

      if (row.isEmpty || row.length != 4) {
        throw PgException(
          'Received an unexpected response creating the replication slot.',
        );
      }

      return Response.success(row[2]! as String, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Create a publication.
  Future<Response<void>> createSubscription(
    Connection connection, {
    required Publication publication,
    required Subscription subscription,
  }) async {
    final sql =
        "CREATE SUBSCRIPTION ${subscription.name} CONNECTION '${subscription.connectionString}' PUBLICATION ${publication.name} WITH (slot_name = '${publication.replicationSlotName}', create_slot = false, copy_data = false);";

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      await connection.execute(sql);
      return Response.success(null, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get the row count of a table.
  Future<Response<int>> getTableRowCount(
    Connection connection, {
    required Table table,
  }) async {
    final sql = 'SELECT COUNT(1) FROM ${table.fullTableName};';

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      final result = await connection.execute(sql);
      final row = result.first;
      return Response.success(row[0]! as int, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Set a transaction's snapshot.
  Future<Response<void>> setTransactionSnapshot(
    Connection connection, {
    required String snapshotName,
  }) async {
    final sql = "SET TRANSACTION SNAPSHOT '$snapshotName';";

    try {
      if (!connection.isOpen) {
        throw PgException(
          '${connection.info.parameters.applicationName} connection to Postgres is not open.',
        );
      }

      await connection.execute(sql);
      return Response.success(null, request: sql);
    } on PgException catch (error, stackTrace) {
      return Response.error(
        error.message,
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        request: sql,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

// Helper method to handle opening Postgres connections
Future<Connection> _openConnection(PostgresClient client) async {
  try {
    return await Connection.open(
      Endpoint(
        host: client.connectionInfo.host,
        port: client.connectionInfo.port,
        database: client.connectionInfo.database,
        username: client.connectionInfo.username,
        password: client.connectionInfo.password,
      ),

      settings: ConnectionSettings(
        applicationName: client.applicationName,
        connectTimeout: const Duration(seconds: 10),
        queryMode: client.queryMode,
        replicationMode: client.replicationMode,
        sslMode: client.sslMode,
        timeZone: 'UTC',
      ),
    );
  } on SocketException {
    rethrow;
  } on Exception {
    rethrow;
  }
}
