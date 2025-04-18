import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgtk_common/pgtk_common.dart';

part 'publication_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Publication extends Equatable {
  const Publication({
    required this.name,
    required this.replicationSlotName,
    required this.tables,
  });

  factory Publication.fromJson(Map<String, dynamic> json) =>
      _$PublicationFromJson(json);

  Map<String, dynamic> toJson() => _$PublicationToJson(this);

  @StringConverter()
  final String name;

  @StringConverter()
  final String replicationSlotName;

  final List<Table> tables;

  List<String> get fullTableNameList =>
      tables.map((table) => table.fullTableName).toList();

  @override
  List<Object> get props => [name, replicationSlotName, tables];

  @override
  bool get stringify => true;
}
