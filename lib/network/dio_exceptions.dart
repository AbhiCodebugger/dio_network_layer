import 'package:dio/dio.dart';
import 'package:flutter_clean_architect/network/network_failure.dart';

NetworkFailure mapDioError(DioException e) {
  NetworkFailureType type;
  String msg = e.message ?? 'Network error';
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      type = NetworkFailureType.connectTimeout;
      break;
    case DioExceptionType.sendTimeout:
      type = NetworkFailureType.sendTimeout;
      break;
    case DioExceptionType.receiveTimeout:
      type = NetworkFailureType.receiveTimeout;
      break;
    case DioExceptionType.cancel:
      type = NetworkFailureType.cancel;
      break;
    case DioExceptionType.badCertificate:
      type = NetworkFailureType.badCertificate;
      break;
    case DioExceptionType.badResponse:
      type = NetworkFailureType.badResponse;
      break;
    case DioExceptionType.connectionError:
      type = NetworkFailureType.noConnection;
      msg = 'No internet connection';
      break;
    default:
      type = NetworkFailureType.unknown;
      break;
  }
  int? status;
  dynamic payload;
  if (e.response != null) {
    status = e.response?.statusCode;
    payload = e.response?.data;
  }
  return NetworkFailure(
    type: type,
    message: msg,
    statusCode: status,
    data: payload,
    exception: e,
    stackTrace: e.stackTrace,
  );
}
