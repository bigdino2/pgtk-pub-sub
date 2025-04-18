import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:pgtk_common/pgtk_common.dart';

part 'postgres_client_model.g.dart';

@CopyWith(constructor: '_')
class PostgresClient {
  PostgresClient._({
    required this.connectionInfo,
    required this.applicationName,
    required this.queryMode,
    required this.replicationMode,
    required this.sslMode,
  });

  /// Create a Postgres client.
  factory PostgresClient.standard({
    required PostgresConnectionInfo connectionInfo,
    required String applicationName,
    bool requireSsl = false,
  }) => PostgresClient._(
    connectionInfo: connectionInfo,
    applicationName: applicationName,
    queryMode: QueryMode.extended,
    replicationMode: ReplicationMode.none,
    sslMode: requireSsl ? SslMode.require : SslMode.disable,
  );

  /// Create a Postgres client to use logical replication mode.
  factory PostgresClient.logicalReplicationMode({
    required PostgresConnectionInfo connectionInfo,
    required String applicationName,
    bool requireSsl = false,
  }) => PostgresClient._(
    connectionInfo: connectionInfo,
    applicationName: applicationName,
    // In replication mode, extended query protocol is not supported
    queryMode: QueryMode.simple,
    replicationMode: ReplicationMode.logical,
    sslMode: requireSsl ? SslMode.require : SslMode.disable,
  );

  final PostgresConnectionInfo connectionInfo;
  final String applicationName;
  final QueryMode queryMode;
  final ReplicationMode replicationMode;
  final SslMode sslMode;
}
