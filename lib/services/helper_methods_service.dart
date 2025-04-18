import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/models/config_model.dart';

class HelperMethodsService {
  /// Validate the config.
  Response<Config> validateConfig(Map<String, dynamic> json) {
    try {
      final config = Config.fromJson(json);

      return Response.success(config);
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
