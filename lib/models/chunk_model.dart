import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/chunk_settings_model.dart';

part 'chunk_model.g.dart';

@CopyWith()
class Chunk extends Equatable {
  const Chunk({
    required this.id,
    required this.table,
    required this.settings,
    required this.offset,
    required this.totalChunks,
    this.rows = const [],
  });

  final int id;
  final Table table;
  final ChunkSettings settings;
  final int offset;
  final int totalChunks;
  final List<List<Object?>> rows;

  String get batchInsertValues => rows
      .map((row) {
        final formattedValues = row
            .map((value) {
              if (value is DateTime) {
                return "'$value'";
              } else {
                return value;
              }
            })
            .join(', ');

        return '($formattedValues)';
      })
      .join(', ');

  @override
  List<Object> get props => [id, table, settings, offset, totalChunks, rows];

  @override
  bool get stringify => true;
}
