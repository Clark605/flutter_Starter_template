import 'package:flutter_starter/core/errors/failure.dart';

sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Error<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Error<T>;

  T? getOrNull() => switch (this) {
    Success(data: final d) => d,
    Error() => null,
  };

  Failure? failureOrNull() => switch (this) {
    Success() => null,
    Error(failure: final f) => f,
  };

  T getOrElse(T Function() orElse) => switch (this) {
    Success(data: final d) => d,
    Error() => orElse(),
  };

  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return switch (this) {
      Success(data: final d) => onSuccess(d),
      Error(failure: final f) => onFailure(f),
    };
  }

  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(data: final d) => Result.success(transform(d)),
      Error(failure: final f) => Result.failure(f),
    };
  }

  Future<Result<R>> asyncMap<R>(Future<R> Function(T data) transform) async {
    return switch (this) {
      Success(data: final d) => Result.success(await transform(d)),
      Error(failure: final f) => Result.failure(f),
    };
  }

  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(data: final d) => await transform(d),
      Error(failure: final f) => Result.failure(f),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Result.success($data)';
}

final class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Result.failure($failure)';
}
