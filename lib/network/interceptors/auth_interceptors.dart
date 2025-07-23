import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();
typedef RefreshTokenFn = Future<bool> Function();

class AuthInterceptors extends Interceptor {
  AuthInterceptors({
    required TokenProvider tokenProvider,
    RefreshTokenFn? onRefreshTokenFn,
  }) : _tokenProvider = tokenProvider,
       _refreshTokenFn = onRefreshTokenFn;

  final TokenProvider _tokenProvider;
  final RefreshTokenFn? _refreshTokenFn;

  bool _isRefreshing = false;
  final _queue = <RequestOptions>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    if (response?.statusCode == 401 && _refreshTokenFn != null) {
      final req = err.requestOptions;

      if (_isRefreshing) {
        // If a refresh is already in progress, queue the request
        _queue.add(err.requestOptions);
        return;
      }
      _isRefreshing = true;
      final refreshed = await _refreshTokenFn();
      _isRefreshing = false;

      final queued = List<RequestOptions>.from(_queue);
      _queue.clear();
      if (refreshed) {
        final dio = req.extra['dio'] as Dio?;

        if (dio != null) {
          try {
            final retryResponse = await dio.fetch(req);
            for (final ro in queued) {
              dio.fetch(ro);
            }
            return handler.resolve(retryResponse);
          } catch (_) {
            // If the retry fails, we can handle it here
          }
        }
      }
    }
    handler.next(err);
  }
}
