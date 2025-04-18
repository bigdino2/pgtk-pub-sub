import 'package:json_annotation/json_annotation.dart';

/// Convert nulls or non-lists to the default list value.
class ListStringConverter implements JsonConverter<List<String>, Object?> {
  const ListStringConverter({this.defaultValue = const []});

  final List<String> defaultValue;

  @override
  List<String> fromJson(Object? json) {
    if (json == null) {
      return defaultValue;
    }

    if (json is List) {
      return json.map((item) => item?.toString() ?? '').toList();
    }

    if (json is String) {
      // Optional: handle comma-separated string conversion
      return json.split(',').map((s) => s.trim()).toList();
    }

    return defaultValue;
  }

  @override
  Object toJson(List<String> value) => value;
}
