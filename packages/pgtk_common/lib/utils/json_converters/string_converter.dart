import 'package:json_annotation/json_annotation.dart';

/// Custom converter for converting null or non-strings to the default value.
class StringConverter implements JsonConverter<String, Object?> {
  const StringConverter({this.defaultValue = ''});

  final String defaultValue;

  @override
  String fromJson(Object? json) {
    if (json is String) return json;
    return defaultValue;
  }

  @override
  Object toJson(String value) => value;
}
