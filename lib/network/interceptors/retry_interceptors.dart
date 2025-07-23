import 'package:dio/dio.dart';

typedef RetryEvaluator = bool Function(DioException error, int attempt);

bool defaultRetryEvaluator(DioException error, int attempt) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.connectionError) {
    return true;
  }
  final status = error.response?.statusCode ?? 0;
  return status >= 500 && status < 600;
}

class RetryInterceptors extends Interceptor {
  RetryInterceptors({
    required Dio dio,
    required this.retries,
    RetryEvaluator? retryEvaluator,
    this.delayFactor = const Duration(milliseconds: 500),
  }) : _dio = dio,
       retryEvaluator = retryEvaluator ?? defaultRetryEvaluator;
  final Dio _dio;
  final int retries;
  final RetryEvaluator retryEvaluator;
  final Duration delayFactor;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final reqOptions = err.requestOptions;
    final attempt = (reqOptions.extra['__retry_attempt__'] as int?) ?? 0;

    if (attempt >= retries || !retryEvaluator(err, attempt)) {
      return handler.next(err);
    }
    final nextAttempt = attempt + 1;
    reqOptions.extra['__retry_attempt__'] = nextAttempt;
    final delay = delayFactor * nextAttempt;
    await Future<void>.delayed(delay);

    try {
      final response = await _dio.fetch(reqOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e is DioException ? e : err);
    }
  }
}
