import 'package:flutter_clean_architect/network/network_failure.dart';

sealed class ApiResult<T> {
  const ApiResult();
  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  R when<R>({
    required R Function(T data, int? statusCode) success,
    required R Function(NetworkFailure failure) failure,
  }) {
    final self = this;
    if (self is ApiSuccess<T>) {
      return success(self.data, self.statusCode);
    } else if (self is ApiFailure<T>) {
      return failure(self.failure);
    }
    throw StateError('Unhandled ApiResult type: $self');
  }
}

final class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  final int? statusCode;
  const ApiSuccess(this.data, {this.statusCode});
}

final class ApiFailure<T> extends ApiResult<T> {
  final NetworkFailure failure;
  const ApiFailure(this.failure);
}
