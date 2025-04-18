// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postgres_connection_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostgresConnectionInfo _$PostgresConnectionInfoFromJson(
  Map<String, dynamic> json,
) => PostgresConnectionInfo(
  host: json['host'] as String,
  port: (json['port'] as num).toInt(),
  database: json['database'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$PostgresConnectionInfoToJson(
  PostgresConnectionInfo instance,
) => <String, dynamic>{
  'host': instance.host,
  'port': instance.port,
  'database': instance.database,
  'username': instance.username,
  'password': instance.password,
};
