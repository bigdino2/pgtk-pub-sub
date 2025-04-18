// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TableCWProxy {
  Table schema(String schema);

  Table name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Table(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Table(...).copyWith(id: 12, name: "My name")
  /// ````
  Table call({String schema, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTable.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTable.copyWith.fieldName(...)`
class _$TableCWProxyImpl implements _$TableCWProxy {
  const _$TableCWProxyImpl(this._value);

  final Table _value;

  @override
  Table schema(String schema) => this(schema: schema);

  @override
  Table name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Table(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Table(...).copyWith(id: 12, name: "My name")
  /// ````
  Table call({
    Object? schema = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Table(
      schema:
          schema == const $CopyWithPlaceholder()
              ? _value.schema
              // ignore: cast_nullable_to_non_nullable
              : schema as String,
      name:
          name == const $CopyWithPlaceholder()
              ? _value.name
              // ignore: cast_nullable_to_non_nullable
              : name as String,
    );
  }
}

extension $TableCopyWith on Table {
  /// Returns a callable class that can be used as follows: `instanceOfTable.copyWith(...)` or like so:`instanceOfTable.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TableCWProxy get copyWith => _$TableCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
  schema: const StringConverter().fromJson(json['schema']),
  name: const StringConverter().fromJson(json['name']),
);

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
  'schema': const StringConverter().toJson(instance.schema),
  'name': const StringConverter().toJson(instance.name),
};
