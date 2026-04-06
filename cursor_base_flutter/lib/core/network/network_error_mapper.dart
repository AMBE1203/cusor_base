import 'package:dio/dio.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_failure.dart';

class NetworkErrorMapper {
  const NetworkErrorMapper();

  Failure map(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const TimeoutFailure();
        case DioExceptionType.cancel:
          return const CancelledFailure();
        case DioExceptionType.connectionError:
          return const NoConnectionFailure();
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 500;
          final message = _messageFromResponseData(error.response?.data);
          return BadResponseFailure(
            statusCode: statusCode,
            message: message ?? 'Request failed ($statusCode).',
          );
        case DioExceptionType.badCertificate:
        case DioExceptionType.unknown:
          return const UnexpectedFailure();
      }
    }

    return const UnexpectedFailure();
  }

  String? _messageFromResponseData(Object? data) {
    if (data is Map) {
      final msg = data['message'];
      if (msg is String && msg.trim().isNotEmpty) {
        return msg.trim();
      }
      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }
    return null;
  }
}

