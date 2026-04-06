import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';

sealed class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure([super.message = 'Request timed out.']);
}

final class NoConnectionFailure extends NetworkFailure {
  const NoConnectionFailure([super.message = 'No internet connection.']);
}

final class CancelledFailure extends NetworkFailure {
  const CancelledFailure([super.message = 'Request was cancelled.']);
}

final class BadResponseFailure extends NetworkFailure {
  const BadResponseFailure({
    required this.statusCode,
    String message = 'Bad response from server.',
  }) : super(message);

  final int statusCode;
}

