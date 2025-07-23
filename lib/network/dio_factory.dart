import 'package:dio/dio.dart';
import 'package:flutter_clean_architect/network/interceptors/auth_interceptors.dart';
import 'package:flutter_clean_architect/network/interceptors/connectivity_interceptors.dart';
import 'package:flutter_clean_architect/network/interceptors/logging_interceptors.dart';
import 'package:flutter_clean_architect/network/interceptors/retry_interceptors.dart';

class DioFactory {
  DioFactory({
    required this.baseUrl,
    Map<String, dynamic>? defaultHeader,
    this.enableLogging = false,
    TokenProvider? tokenProvider,
    RefreshTokenFn? onRefreshTokenFn,
    this.maxRetries = 0,
    ConnectivityCheck? connectivityCheck,
    Duration connectTimeOut = const Duration(seconds: 30),
    Duration receiveTimeOut = const Duration(seconds: 30),
  }) : _defaultHeader = defaultHeader ?? {},
       _tokenProvider = tokenProvider,
       _onRefreshTokenFn = onRefreshTokenFn,
       _connectivityCheck = connectivityCheck,
       _connectionTimeOut = connectTimeOut,
       _receiveTimeOut = receiveTimeOut;

  final String baseUrl;
  final Map<String, dynamic> _defaultHeader;
  final bool enableLogging;
  final TokenProvider? _tokenProvider;
  final RefreshTokenFn? _onRefreshTokenFn;
  final ConnectivityCheck? _connectivityCheck;
  final int maxRetries;
  final Duration _connectionTimeOut;
  final Duration _receiveTimeOut;

  Dio createDio() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      headers: {..._defaultHeader},
      connectTimeout: _connectionTimeOut,
      receiveTimeout: _receiveTimeOut,
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 600,
    );
    final dio = Dio(options);

    // Auth header injection
    if (_tokenProvider != null) {
      dio.interceptors.add(
        AuthInterceptors(
          tokenProvider: _tokenProvider,
          onRefreshTokenFn: _onRefreshTokenFn,
        ),
      );
    }
    dio.interceptors.add(ConnectivityInterceptors(check: _connectivityCheck));

    // Retry and logging interceptors
    if (maxRetries > 0) {
      dio.interceptors.add(RetryInterceptors(dio: dio, retries: maxRetries));
    }
    // Logging interceptor
    if (enableLogging) {
      dio.interceptors.add(LoggingInterceptors());
    }
    return dio;
  }
}
