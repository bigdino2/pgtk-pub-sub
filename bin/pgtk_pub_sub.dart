import 'dart:io';

import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/chunk_model.dart';
import 'package:pgtk_pub_sub/models/config_model.dart';
import 'package:pgtk_pub_sub/models/worker_model.dart';
import 'package:pgtk_pub_sub/services/services.dart';
import 'package:pgtk_pub_sub/services/worker_pool_service.dart';

/*

Main Function

main() must:
 - only call Business Logic methods
 - have a helpful comment over each method and include return types

main() must never:
 - call Services directly
 - handle Response objects
 - log messages
 - contain try/catch blocks

*/
Future<void> main(List<String> userArgs) async {
  // Register core services
  _registerCoreServices(loggerName: 'pgtk-pub-sub');

  // Parse the user provided arguments
  _parseUserArgs(userArgs);

  // Register the non-core services
  _registerNonCoreServices();

  // Convert the YAML config to JSON
  final configJson = _convertYamlConfigToJson(Services.args.config);

  // Validate the JSON config
  final config = _validateConfig(configJson);

  // Test the connectivity to the publisher and subscriber
  await _testPostgresConnections([
    PostgresClient.standard(
      connectionInfo: config.publisher,
      applicationName: 'pgtk-conn-test',
    ),
    PostgresClient.standard(
      connectionInfo: config.subscriber,
      applicationName: 'pgtk-conn-test',
    ),
  ]);

  // (pgtk-snapshot) Define the snapshot client.
  //
  // This is a Postgres connection to the publisher in replication mode. It
  // will export the snapshot and remain open throughout the life of the job.
  final snapshotClient = PostgresClient.logicalReplicationMode(
    connectionInfo: config.publisher,
    applicationName: 'pgtk-snapshot',
  );

  // (pgtk-pub-helper) Define the publisher helper client.
  //
  // This is a Postgres connection to the publisher to run various read/write commands.
  final pubHelperClient = PostgresClient.standard(
    connectionInfo: config.publisher,
    applicationName: 'pgtk-pub-helper',
  );

  // (pgtk-sub-helper) Define the subscriber helper client.
  //
  // This is a Postgres connection to the subscriber to run various read/write commands.
  final subHelperClient = PostgresClient.standard(
    connectionInfo: config.subscriber,
    applicationName: 'pgtk-sub-helper',
  );

  // (pgtk-snapshot) Open a Postgres connection
  final snapshotConn = await _openConnection(snapshotClient);

  await _createPublication(snapshotConn, publication: config.publication);

  // Create the replication and get a snapshot
  final snapshotName = await _createReplicationSlot(
    snapshotConn,
    publication: config.publication,
  );

  // Iterate over each table in the publication
  for (var i = 0; i < config.publication.tables.length; i++) {
    // Get the table
    final table = config.publication.tables[i];

    // Get the table's chunk settings
    final chunkSettings = config.chunkSettings[i];

    // (pgtk-pub-helper) Open a Postgres connection
    final pubHelperConn = await _openConnection(pubHelperClient);

    // (pgtk-pub-helper) Start a read only transaction
    await _beginReadOnlyTransaction(pubHelperConn);

    // (pgtk-pub-helper) Set the transaction to the exported snapshot
    await _setTransactionSnapshot(pubHelperConn, snapshotName: snapshotName);

    // (pgtk-pub-helper) Get the table's row count
    final rowCount = await _getTableRowCount(pubHelperConn, table: table);

    // (pgtk-pub-helper) Close Postgres connection
    await pubHelperConn.close();

    // Calculate the total number of chunks for the table
    final totalChunks = _calculateTotalChunks(
      rowCount,
      chunkSettings.chunkSize,
    );

    // Generate a list of OFFSETs for the chunk SQL query
    final offsets = await _generateOffsets(
      totalChunks,
      chunkSettings.chunkSize,
    );

    /*
delete if not needed

    // Create the list of dumper and loader connections for the worker pool
    final dumperConns = <Connection>[];
    final loaderConns = <Connection>[];

    // For each worker, we need a dumper and loader Postgres connection
    // These will be used to pass connection info to workers
    for (var i = 0; i < Services.args.workers; i++) {
      final dumperConn = await _openConnection(dumperClient);
      dumperConns.add(dumperConn);

      final loaderConn = await _openConnection(loaderClient);
      loaderConns.add(loaderConn);
    }

    // We don't need to set transaction snapshot here anymore as each worker
    // will create its own connections and handle transactions
*/
    // Create the list of chunks to pass to the worker pool
    final chunks = <Chunk>[];

    for (var chunkId = 1; chunkId <= totalChunks; chunkId++) {
      chunks.add(
        Chunk(
          id: chunkId,
          table: table,
          settings: chunkSettings,
          offset: offsets[chunkId - 1],
          totalChunks: totalChunks,
        ),
      );
    }

    // Create workers for the worker pool
    final workers = await _spawnWorkers(workerCount: Services.args.workers);

    // Create and initialize the worker pool
    final workerPool = WorkerPoolService(
      workers: workers,
      publisher: config.publisher,
      subscriber: config.subscriber,
    );

    // Initialize the worker pool (this now initializes database connections in each worker)
    await workerPool.initialize(snapshotName);

    // Process all chunks in parallel
    await workerPool.processChunks(chunks);

    // Close all workers
    workerPool.closeAll();

    /*
delete?

    // Close dumper and loader connections
    for (var i = 0; i < Services.args.workers; i++) {
      await dumperConns[i].close();
      await loaderConns[i].close();
    }

    */
  }

  // (pgtk-sub-helper) Open a Postgres connection
  final subHelperConn = await _openConnection(subHelperClient);

  // (pgtk-sub-helper) Create the subscription
  await _createSubscription(
    subHelperConn,
    publication: config.publication,
    subscription: config.subscription,
  );

  // (pgtk-sub-helper) Close Postgres connection
  await subHelperConn.close();

  // (pgtk-snapshot) Close Postgres connection
  await snapshotConn.close();

  print('Success!');
}
/*

Business Logic

Business logic must:
- handle one task (ex: call one Service and receive one Response)
- only be called from main()
- call Services and receive a Response
- handle Response object success and errors
- on success, return data to main()
- on error, handle exiting the procees
- log all messaging
- duplicate the comments from the Service methods.

Business logic must never:
- contain try/catch blocks
- have top level comments (avoiding redundancy to main())

*/

/// Register the core services.
void _registerCoreServices({required String loggerName}) {
  final response = Services.initialize(loggerName: loggerName);

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }
}

/// Parse the user provided arguments.
void _parseUserArgs(List<String> userArgs) {
  final response = Services.args.parseArgs(userArgs);

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  // Check to enable debug logging
  if (Services.args.debug) {
    Services.logger.enableDebugMode();
  }
}

/// Create a list of workers for the worker pool.
///
/// Returns a [List] of [Worker].
Future<List<Worker>> _spawnWorkers({required int workerCount}) async {
  final workers = <Worker>[];

  for (var i = 0; i < workerCount; i++) {
    final worker = await Worker.spawn(i + 1);
    workers.add(worker);
  }

  return workers;
}

/// Register the non-core services.
void _registerNonCoreServices() {
  final response = Services.register();

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }
}

/// Convert a YAML config to JSON.
///
/// Returns a JSON [Map].
Map<String, dynamic> _convertYamlConfigToJson(String file) {
  final response = Services.yaml.convertYamlFileToJson(file);

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  return response.data!;
}

/// Validate a JSON config.
///
/// Returns a [Config].
Config _validateConfig(Map<String, dynamic> json) {
  final response = Services.helper.validateConfig(json);

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  return response.data!;
}

/// Test client connectivity to Postgres.
Future<void> _testPostgresConnections(
  List<PostgresClient> postgresClients,
) async {
  for (final client in postgresClients) {
    final response = await Services.sql.testConnection(client);

    if (response.hasError) {
      Services.logger.e(
        response.message,
        error: response.error,
        stackTrace: response.stackTrace,
      );

      exit(1);
    }

    Services.logger.d(response.data!);
  }
}

/// Open a connection to Postgres.
///
/// Returns a [Connection].
Future<Connection> _openConnection(PostgresClient client) async {
  final response = await Services.sql.openConnection(client);

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  return response.data!;
}

/// Create a replication slot.
///
/// Returns the snapshot name [String].
Future<String> _createReplicationSlot(
  Connection conn, {
  required Publication publication,
}) async {
  final response = await Services.sql.createReplicationSlotInReplMode(
    conn,
    publication: publication,
  );

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  Services.logger.i(
    'Created replication slot ${publication.replicationSlotName}. Exported snapshot ${response.data!}',
  );

  return response.data!;
}

/// Start a read only transaction.
Future<void> _beginReadOnlyTransaction(Connection conn) async {
  final response = await Services.sql.beginReadOnlyTransaction(conn);

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }
}

/// Set the transaction snapshot.
Future<void> _setTransactionSnapshot(
  Connection conn, {
  required String snapshotName,
}) async {
  final response = await Services.sql.setTransactionSnapshot(
    conn,
    snapshotName: snapshotName,
  );

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }
}

/// Get a table's row count.
///
/// Returns the row count [int].
Future<int> _getTableRowCount(Connection conn, {required Table table}) async {
  final response = await Services.sql.getTableRowCount(conn, table: table);

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  Services.logger.i(
    'Table ${table.fullTableName} total rows: ${response.data!}',
  );

  return response.data!;
}

/// Calculate a total number of chunks (rounded up).
///
/// Returns the number of chunks [int].
int _calculateTotalChunks(int rowCount, int chunkSize) {
  return (rowCount / chunkSize).ceil();
}

/// Generate a list of OFFSETs.
///
/// These offsets are used in the SQL query to fetch chunks.
///
/// Returns the OFFSETs as a [List] of [int].
Future<List<int>> _generateOffsets(int totalChunks, int chunkSize) async {
  final chunks = <int>[];
  var offset = 0;

  for (var c = 1; c <= totalChunks; c++) {
    chunks.add(offset);
    offset = offset + chunkSize;
  }

  return chunks;
}

/// Create a publication.
Future<void> _createPublication(
  Connection conn, {
  required Publication publication,
}) async {
  final response = await Services.sql.createPublication(
    conn,
    publication: publication,
  );

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  Services.logger.i('Created publication ${publication.name}');
}

/// Create a subscription.
Future<void> _createSubscription(
  Connection conn, {
  required Publication publication,
  required Subscription subscription,
}) async {
  final response = await Services.sql.createSubscription(
    conn,
    publication: publication,
    subscription: subscription,
  );

  Services.logger.d(
    '(${conn.info.parameters.applicationName}) ${response.request!}',
  );

  if (response.hasError) {
    Services.logger.e(
      response.message,
      error: response.error,
      stackTrace: response.stackTrace,
    );

    exit(1);
  }

  Services.logger.i('Created subscription ${subscription.name}');
}
