enum NetworkFailureType {
  connectTimeout,
  sendTimeout,
  receiveTimeout,
  cancel,
  noConnection,
  badCertificate,
  badResponse, // non-2xx response
  parse,
  unauthorized, // convenience if you want to map 401 specially
  unknown,
}

class NetworkFailure {
  final NetworkFailureType type;
  final String message;
  final int? statusCode;
  final dynamic data;
  final Object? exception;
  final StackTrace? stackTrace;
  NetworkFailure({
    required this.type,
    required this.message,
    this.statusCode,
    this.data,
    this.exception,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'NetworkFailure(type: $type, statusCode: $statusCode, message: $message)';
  }
}

extension NetworkFailureCopy on NetworkFailure {
  NetworkFailure copyWith({
    NetworkFailureType? type,
    String? message,
    int? statusCode,
    dynamic data,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    return NetworkFailure(
      type: type ?? this.type,
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}
