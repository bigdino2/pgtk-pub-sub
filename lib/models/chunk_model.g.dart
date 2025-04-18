// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chunk_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChunkCWProxy {
  Chunk id(int id);

  Chunk table(Table table);

  Chunk settings(ChunkSettings settings);

  Chunk offset(int offset);

  Chunk totalChunks(int totalChunks);

  Chunk rows(List<List<Object?>> rows);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chunk(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chunk(...).copyWith(id: 12, name: "My name")
  /// ````
  Chunk call({
    int id,
    Table table,
    ChunkSettings settings,
    int offset,
    int totalChunks,
    List<List<Object?>> rows,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChunk.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChunk.copyWith.fieldName(...)`
class _$ChunkCWProxyImpl implements _$ChunkCWProxy {
  const _$ChunkCWProxyImpl(this._value);

  final Chunk _value;

  @override
  Chunk id(int id) => this(id: id);

  @override
  Chunk table(Table table) => this(table: table);

  @override
  Chunk settings(ChunkSettings settings) => this(settings: settings);

  @override
  Chunk offset(int offset) => this(offset: offset);

  @override
  Chunk totalChunks(int totalChunks) => this(totalChunks: totalChunks);

  @override
  Chunk rows(List<List<Object?>> rows) => this(rows: rows);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chunk(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chunk(...).copyWith(id: 12, name: "My name")
  /// ````
  Chunk call({
    Object? id = const $CopyWithPlaceholder(),
    Object? table = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? offset = const $CopyWithPlaceholder(),
    Object? totalChunks = const $CopyWithPlaceholder(),
    Object? rows = const $CopyWithPlaceholder(),
  }) {
    return Chunk(
      id:
          id == const $CopyWithPlaceholder()
              ? _value.id
              // ignore: cast_nullable_to_non_nullable
              : id as int,
      table:
          table == const $CopyWithPlaceholder()
              ? _value.table
              // ignore: cast_nullable_to_non_nullable
              : table as Table,
      settings:
          settings == const $CopyWithPlaceholder()
              ? _value.settings
              // ignore: cast_nullable_to_non_nullable
              : settings as ChunkSettings,
      offset:
          offset == const $CopyWithPlaceholder()
              ? _value.offset
              // ignore: cast_nullable_to_non_nullable
              : offset as int,
      totalChunks:
          totalChunks == const $CopyWithPlaceholder()
              ? _value.totalChunks
              // ignore: cast_nullable_to_non_nullable
              : totalChunks as int,
      rows:
          rows == const $CopyWithPlaceholder()
              ? _value.rows
              // ignore: cast_nullable_to_non_nullable
              : rows as List<List<Object?>>,
    );
  }
}

extension $ChunkCopyWith on Chunk {
  /// Returns a callable class that can be used as follows: `instanceOfChunk.copyWith(...)` or like so:`instanceOfChunk.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChunkCWProxy get copyWith => _$ChunkCWProxyImpl(this);
}
