import 'package:dio/dio.dart';

typedef ConnectivityCheck = Future<bool> Function();

class ConnectivityInterceptors extends Interceptor {
  ConnectivityInterceptors({ConnectivityCheck? check}) : _check = check;
  final ConnectivityCheck? _check;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_check != null) {
      final online = await _check();
      if (!online) {
        return handler.reject(
          DioException.connectionError(
            requestOptions: options,
            reason: 'No internet connection',
          ),
        );
      }
    }
    handler.next(options);
  }
}
