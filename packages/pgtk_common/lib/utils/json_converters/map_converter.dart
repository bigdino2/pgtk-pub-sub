import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

/// Convert nulls or non-maps to the default Map value.
class MapConverter implements JsonConverter<Map<String, dynamic>, Object?> {
  const MapConverter({this.defaultValue = const {}});

  final Map<String, dynamic> defaultValue;

  @override
  Map<String, dynamic> fromJson(Object? json) {
    if (json == null) return defaultValue;
    if (json is Map<String, dynamic>) return json;
    if (json is String) {
      if (json.isEmpty) return defaultValue;

      try {
        final decoded = jsonDecode(json);
        if (decoded is Map<String, dynamic>) return decoded;
      } on Exception catch (_) {
        return defaultValue;
      }
    }

    if (json is Map && !json.keys.every((k) => k is String)) {
      // Convert non-string keys to string keys
      return json.map((key, value) => MapEntry(key.toString(), value));
    }

    return defaultValue;
  }

  @override
  Object toJson(Map<String, dynamic> value) {
    return value;
  }
}
