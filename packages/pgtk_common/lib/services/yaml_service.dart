import 'dart:io';

import 'package:pgtk_common/pgtk_common.dart';
import 'package:yaml/yaml.dart';

class YamlService {
  /// Convert a YAML file to JSON.
  Response<Map<String, dynamic>> convertYamlFileToJson(String file) {
    try {
      // Load the file
      final f = File(file);

      // Read the file as a string
      final fString = f.readAsStringSync();

      // Convert the string to a YamlMap
      final yamlMap = loadYaml(fString) as YamlMap;

      // Convert the YamlMap to JSON
      return Response.success(_convertYamlMapToMap(yamlMap));
    } on PathNotFoundException catch (error, stackTrace) {
      return Response.error(
        'The file was not found: $file',
        error: error,
        stackTrace: stackTrace,
      );
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Convert a YamlMap to JSON.
  Map<String, dynamic> _convertYamlMapToMap(YamlMap yamlMap) {
    final result = <String, dynamic>{};

    for (final key in yamlMap.keys) {
      final value = yamlMap[key];

      if (value is YamlMap) {
        // Recursively convert nested YamlMap
        result[key.toString()] = _convertYamlMapToMap(value);
      } else if (value is YamlList) {
        // Convert YamlList to List<dynamic>
        result[key.toString()] = _convertYamlListToList(value);
      } else {
        // For primitive types (String, num, bool, null)
        result[key.toString()] = value;
      }
    }

    return result;
  }

  /// Convert a YamlList to a dynamic List.
  List<dynamic> _convertYamlListToList(YamlList yamlList) {
    final result = <dynamic>[];

    for (final item in yamlList) {
      if (item is YamlMap) {
        result.add(_convertYamlMapToMap(item));
      } else if (item is YamlList) {
        result.add(_convertYamlListToList(item));
      } else {
        result.add(item);
      }
    }

    return result;
  }
}
