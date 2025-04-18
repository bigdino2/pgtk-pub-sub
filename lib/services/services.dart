import 'package:get_it/get_it.dart';
import 'package:pgtk_common/pgtk_common.dart';
import 'package:pgtk_pub_sub/services/arg_service.dart';
import 'package:pgtk_pub_sub/services/helper_methods_service.dart';
import 'package:pgtk_pub_sub/services/worker_pool_service.dart';

class Services {
  static ArgService get args => GetIt.instance<ArgService>();
  static HelperMethodsService get helper =>
      GetIt.instance<HelperMethodsService>();
  static LoggingService get logger => GetIt.instance<LoggingService>();
  static PostgresService get sql => GetIt.instance<PostgresService>();
  static WorkerPoolService get workerPool =>
      GetIt.instance<WorkerPoolService>();
  static YamlService get yaml => GetIt.instance<YamlService>();

  /// Register the core services.
  ///
  /// Core services have no dependencies on other services.
  static Response<void> initialize({required String loggerName}) {
    try {
      GetIt.instance
        ..registerLazySingleton<ArgService>(ArgService.new)
        ..registerLazySingleton<LoggingService>(
          () => LoggingService(loggerName),
        );

      return Response.success(null);
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Register the non-core services.
  ///
  /// These services may have a dependency on other services.
  static Response<void> register() {
    try {
      GetIt.instance
        ..registerLazySingleton<HelperMethodsService>(HelperMethodsService.new)
        ..registerLazySingleton<PostgresService>(PostgresService.new)
        ..registerLazySingleton<YamlService>(YamlService.new);

      // Note: WorkerPoolService is not registered here as it requires workers
      // which are created dynamically during runtime

      return Response.success(null);
    } on Exception catch (error, stackTrace) {
      return Response.error(
        'Unexpected error',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
