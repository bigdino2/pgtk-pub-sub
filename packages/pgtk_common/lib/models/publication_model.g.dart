// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publication _$PublicationFromJson(Map<String, dynamic> json) => Publication(
  name: const StringConverter().fromJson(json['name']),
  replicationSlotName: const StringConverter().fromJson(
    json['replication_slot_name'],
  ),
  tables:
      (json['tables'] as List<dynamic>)
          .map((e) => Table.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'name': const StringConverter().toJson(instance.name),
      'replication_slot_name': const StringConverter().toJson(
        instance.replicationSlotName,
      ),
      'tables': instance.tables,
    };
