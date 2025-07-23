import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architect/network/api_result.dart';
import 'package:flutter_clean_architect/network/dio_exceptions.dart';
import 'package:flutter_clean_architect/network/network_failure.dart';

Future<ApiResult<File>> downloadToFile({
  required Dio dio,
  required String url,
  required String savePath,
  ProgressCallback? onProgress,
  CancelToken? cancelToken,
}) async {
  try {
    final resp = await dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
      options: Options(responseType: ResponseType.bytes, followRedirects: true),
    );

    final status = resp.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      return ApiSuccess(File(savePath), statusCode: status);
    }

    return ApiFailure(
      NetworkFailure(
        type: NetworkFailureType.badResponse,
        message: 'HTTP $status',
        statusCode: status,
        data: resp.data,
      ),
    );
  } on DioException catch (e, st) {
    final failure = mapDioError(e).copyWith(stackTrace: st);
    return ApiFailure(failure);
  } catch (e, st) {
    return ApiFailure(
      NetworkFailure(
        type: NetworkFailureType.unknown,
        message: 'Download failed: $e',
        exception: e,
        stackTrace: st,
      ),
    );
  }
}
