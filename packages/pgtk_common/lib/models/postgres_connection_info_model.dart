import 'package:json_annotation/json_annotation.dart';

part 'postgres_connection_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PostgresConnectionInfo {
  PostgresConnectionInfo({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
  });

  factory PostgresConnectionInfo.fromJson(Map<String, dynamic> json) =>
      _$PostgresConnectionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PostgresConnectionInfoToJson(this);

  /// The hostname of the Postgres server.
  final String host;

  /// The port of the Postgres server.
  final int port;

  /// The database name.
  final String database;

  /// The username.
  final String username;

  /// The password.
  final String password;
}
