import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgtk_common/pgtk_common.dart';

part 'table_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class Table extends Equatable {
  const Table({required this.schema, required this.name});

  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);

  Map<String, dynamic> toJson() => _$TableToJson(this);

  @StringConverter()
  final String schema;

  @StringConverter()
  final String name;

  String get fullTableName => '$schema.$name';

  @override
  List<Object> get props => [schema, name];

  @override
  bool get stringify => true;
}
