import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architect/network/api_result.dart';
import 'package:flutter_clean_architect/network/dio_exceptions.dart';
import 'package:flutter_clean_architect/network/network_failure.dart';

typedef ResponseParser<T> = T Function(dynamic data);

T _decodeAndParse<T>(dynamic data, ResponseParser<T> parser) {
  final dynamic jsonData = (data is String) ? jsonDecode(data) : data;
  return parser(jsonData);
}

class NetworkManager {
  NetworkManager(this._dio);
  final Dio _dio;

  Future<ApiResult<T>> request<T>({
    required String path,
    required ResponseParser<T> parser,
    String method = 'GET', // Default method is GET
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await _dio.request<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      final status = response.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        final type = status == 401
            ? NetworkFailureType.unauthorized
            : NetworkFailureType.badResponse;
        return ApiFailure(
          NetworkFailure(
            type: type,
            message: 'HTTP $status',
            statusCode: status,
            data: response.data,
          ),
        );
      }
      // 204 No Content -> parser can't parse null. Provide a default if T == void or similar.
      if (status == 204 ||
          response.data == null ||
          (response.data is String && (response.data as String).isEmpty)) {
        // ignore parser and try to return a trivial value based on T.
        // For now, throw parse error if parser can't handle null; you can customize.
        try {
          final parsed = parser(null);
          return ApiSuccess(parsed, statusCode: status);
        } catch (_) {
          // Return raw null typed as T?; cast may fail; choose safe fallback.
          return ApiFailure(
            NetworkFailure(
              type: NetworkFailureType.parse,
              message: 'No content to parse',
              statusCode: status,
            ),
          );
        }
      }
      final parsed = _decodeAndParse<T>(response.data, parser);
      return ApiSuccess(parsed, statusCode: status);
    } on DioException catch (e, st) {
      final failure = mapDioError(e).copyWith(stackTrace: st);
      return ApiFailure(failure);
    } catch (e, st) {
      return ApiFailure(
        NetworkFailure(
          type: NetworkFailureType.parse,
          message: 'Parsing failed : $e',
          exception: e,
          stackTrace: st,
        ),
      );
    }
  }

  // GET request
  Future<ApiResult<T>> get<T>(
    String path, {
    required ResponseParser<T> parser,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) => request<T>(
    path: path,
    method: 'GET',
    parser: parser,
    queryParameters: query,
    options: options,
    cancelToken: cancelToken,
    onReceiveProgress: onReceiveProgress,
  );

  // POST request
  Future<ApiResult<T>> post<T>(
    String path, {
    required ResponseParser<T> parser,
    dynamic body,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => request<T>(
    path: path,
    method: 'POST',
    parser: parser,
    data: body,
    queryParameters: query,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  // PUT request
  Future<ApiResult<T>> put<T>(
    String path, {
    required ResponseParser<T> parser,
    dynamic body,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => request<T>(
    path: path,
    method: 'PUT',
    parser: parser,
    data: body,
    queryParameters: query,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  // DELETE request
  Future<ApiResult<T>> delete<T>(
    String path, {
    required ResponseParser<T> parser,
    dynamic body,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) => request<T>(
    path: path,
    method: 'DELETE',
    parser: parser,
    data: body,
    queryParameters: query,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );
}
