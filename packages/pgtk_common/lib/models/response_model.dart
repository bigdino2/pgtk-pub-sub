import 'package:equatable/equatable.dart';

class Response<T> extends Equatable {
  const Response._({
    required this.successful,
    this.data,
    this.request,
    this.message,
    this.error,
    this.stackTrace,
  });

  factory Response.success(T? data, {String? request}) =>
      Response._(successful: true, data: data, request: request);

  factory Response.error(
    String? message, {
    String? request,
    Object? error,
    StackTrace? stackTrace,
  }) => Response._(
    successful: false,
    request: request,
    message: message,
    error: error,
    stackTrace: stackTrace,
  );

  final bool successful;
  final String? request;
  final T? data;
  final String? message;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasError => !successful;

  @override
  List<Object?> get props => [
    successful,
    request,
    data,
    message,
    error,
    stackTrace,
  ];

  @override
  bool get stringify => true;
}
