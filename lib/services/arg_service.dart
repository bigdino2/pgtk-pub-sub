import 'dart:io';

import 'package:args/args.dart';
import 'package:pgtk_common/pgtk_common.dart';

class ArgService {
  late String _config;
  String get config => _config;

  late bool _debug;
  bool get debug => _debug;

  late int _workers;
  int get workers => _workers;

  late bool _help;

  /// Parse the user provided arguments.
  Response<void> parseArgs(List<String> args) {
    final parser =
        ArgParser()
          ..addFlag(
            'help',
            abbr: 'h',
            help: 'Show this help message',
            hide: true,
            negatable: false,
          )
          ..addOption(
            'config',
            mandatory: true,
            help: 'The path or URL to the YAML config file',
            valueHelp: 't1_pub.yaml',
          )
          ..addOption(
            'workers',
            defaultsTo: '4',
            help: 'The number of parallel workers',
            valueHelp: '4',
          )
          ..addFlag('debug', help: 'Enable debug logging', negatable: false)
          ..addSeparator('TODO: Add a sick description');

    try {
      final argResults = parser.parse(args);

      _help = argResults.flag('help');

      // Check --help first to print usage and exit
      if (_help) {
        print(parser.usage);
        exit(0);
      }

      // Check required arguments next to exit quickly if needed
      if (!argResults.wasParsed('config')) {
        throw const FormatException('--config is required');
      }

      _config = argResults.option('config')!;
      _debug = argResults.flag('debug');
      _workers = int.parse(argResults.option('workers')!);

      return Response.success(null);
    } on FormatException catch (error, stackTrace) {
      return Response.error(
        error.message,
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
}
