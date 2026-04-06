import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';

class UseCaseResult<T> {
  const UseCaseResult._({
    this.data,
    this.failure,
  });

  const UseCaseResult.success(T data) : this._(data: data);

  const UseCaseResult.failure(Failure failure) : this._(failure: failure);

  final T? data;
  final Failure? failure;

  bool get isSuccess => failure == null;
}

