// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postgres_client_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PostgresClientCWProxy {
  PostgresClient connectionInfo(PostgresConnectionInfo connectionInfo);

  PostgresClient applicationName(String applicationName);

  PostgresClient queryMode(QueryMode queryMode);

  PostgresClient replicationMode(ReplicationMode replicationMode);

  PostgresClient sslMode(SslMode sslMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostgresClient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostgresClient(...).copyWith(id: 12, name: "My name")
  /// ````
  PostgresClient call({
    PostgresConnectionInfo connectionInfo,
    String applicationName,
    QueryMode queryMode,
    ReplicationMode replicationMode,
    SslMode sslMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPostgresClient.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPostgresClient.copyWith.fieldName(...)`
class _$PostgresClientCWProxyImpl implements _$PostgresClientCWProxy {
  const _$PostgresClientCWProxyImpl(this._value);

  final PostgresClient _value;

  @override
  PostgresClient connectionInfo(PostgresConnectionInfo connectionInfo) =>
      this(connectionInfo: connectionInfo);

  @override
  PostgresClient applicationName(String applicationName) =>
      this(applicationName: applicationName);

  @override
  PostgresClient queryMode(QueryMode queryMode) => this(queryMode: queryMode);

  @override
  PostgresClient replicationMode(ReplicationMode replicationMode) =>
      this(replicationMode: replicationMode);

  @override
  PostgresClient sslMode(SslMode sslMode) => this(sslMode: sslMode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PostgresClient(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PostgresClient(...).copyWith(id: 12, name: "My name")
  /// ````
  PostgresClient call({
    Object? connectionInfo = const $CopyWithPlaceholder(),
    Object? applicationName = const $CopyWithPlaceholder(),
    Object? queryMode = const $CopyWithPlaceholder(),
    Object? replicationMode = const $CopyWithPlaceholder(),
    Object? sslMode = const $CopyWithPlaceholder(),
  }) {
    return PostgresClient._(
      connectionInfo:
          connectionInfo == const $CopyWithPlaceholder()
              ? _value.connectionInfo
              // ignore: cast_nullable_to_non_nullable
              : connectionInfo as PostgresConnectionInfo,
      applicationName:
          applicationName == const $CopyWithPlaceholder()
              ? _value.applicationName
              // ignore: cast_nullable_to_non_nullable
              : applicationName as String,
      queryMode:
          queryMode == const $CopyWithPlaceholder()
              ? _value.queryMode
              // ignore: cast_nullable_to_non_nullable
              : queryMode as QueryMode,
      replicationMode:
          replicationMode == const $CopyWithPlaceholder()
              ? _value.replicationMode
              // ignore: cast_nullable_to_non_nullable
              : replicationMode as ReplicationMode,
      sslMode:
          sslMode == const $CopyWithPlaceholder()
              ? _value.sslMode
              // ignore: cast_nullable_to_non_nullable
              : sslMode as SslMode,
    );
  }
}

extension $PostgresClientCopyWith on PostgresClient {
  /// Returns a callable class that can be used as follows: `instanceOfPostgresClient.copyWith(...)` or like so:`instanceOfPostgresClient.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PostgresClientCWProxy get copyWith => _$PostgresClientCWProxyImpl(this);
}
