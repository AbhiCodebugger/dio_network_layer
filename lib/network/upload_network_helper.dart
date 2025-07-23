import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_clean_architect/network/api_result.dart';
import 'package:flutter_clean_architect/network/network_manager.dart';

typedef ExtraField = Map<String, dynamic>;

Future<ApiResult<T>> uploadFile<T>({
  required NetworkManager client,
  required String path,
  required ResponseParser<T> parser,
  required String fieldName,
  required File file,
  ExtraField? fields,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
}) async {
  final fName = file.path.split('/').last;
  final form = FormData.fromMap({
    if (fields != null) ...fields,
    fieldName: await MultipartFile.fromFile(file.path, filename: fName),
  });
  return client.post(
    path,
    parser: parser,
    body: form,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
  );
}
