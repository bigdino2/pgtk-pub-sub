// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chunk_settings_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChunkSettingsCWProxy {
  ChunkSettings orderBy(List<String> orderBy);

  ChunkSettings chunkSize(int chunkSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChunkSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChunkSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ChunkSettings call({List<String> orderBy, int chunkSize});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChunkSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChunkSettings.copyWith.fieldName(...)`
class _$ChunkSettingsCWProxyImpl implements _$ChunkSettingsCWProxy {
  const _$ChunkSettingsCWProxyImpl(this._value);

  final ChunkSettings _value;

  @override
  ChunkSettings orderBy(List<String> orderBy) => this(orderBy: orderBy);

  @override
  ChunkSettings chunkSize(int chunkSize) => this(chunkSize: chunkSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChunkSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChunkSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  ChunkSettings call({
    Object? orderBy = const $CopyWithPlaceholder(),
    Object? chunkSize = const $CopyWithPlaceholder(),
  }) {
    return ChunkSettings(
      orderBy:
          orderBy == const $CopyWithPlaceholder()
              ? _value.orderBy
              // ignore: cast_nullable_to_non_nullable
              : orderBy as List<String>,
      chunkSize:
          chunkSize == const $CopyWithPlaceholder()
              ? _value.chunkSize
              // ignore: cast_nullable_to_non_nullable
              : chunkSize as int,
    );
  }
}

extension $ChunkSettingsCopyWith on ChunkSettings {
  /// Returns a callable class that can be used as follows: `instanceOfChunkSettings.copyWith(...)` or like so:`instanceOfChunkSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChunkSettingsCWProxy get copyWith => _$ChunkSettingsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChunkSettings _$ChunkSettingsFromJson(Map<String, dynamic> json) =>
    ChunkSettings(
      orderBy: const ListStringConverter().fromJson(json['order_by']),
      chunkSize: const IntConverter().fromJson(json['chunk_size']),
    );

Map<String, dynamic> _$ChunkSettingsToJson(ChunkSettings instance) =>
    <String, dynamic>{
      'order_by': const ListStringConverter().toJson(instance.orderBy),
      'chunk_size': const IntConverter().toJson(instance.chunkSize),
    };
