import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pgtk_common/pgtk_common.dart';

part 'chunk_settings_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class ChunkSettings extends Equatable {
  const ChunkSettings({required this.orderBy, required this.chunkSize});

  factory ChunkSettings.fromJson(Map<String, dynamic> json) =>
      _$ChunkSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChunkSettingsToJson(this);

  @ListStringConverter()
  final List<String> orderBy;

  @IntConverter()
  final int chunkSize;

  @override
  List<Object> get props => [orderBy, chunkSize];

  @override
  bool get stringify => true;
}
