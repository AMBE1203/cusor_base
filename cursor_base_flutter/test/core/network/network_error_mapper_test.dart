import 'package:dio/dio.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_error_mapper.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = NetworkErrorMapper();

  test('passes through Failure', () {
    const failure = TimeoutFailure();
    expect(mapper.map(failure), same(failure));
  });

  test('maps timeout DioException to TimeoutFailure', () {
    final ex = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.connectionTimeout,
    );
    expect(mapper.map(ex), isA<TimeoutFailure>());
  });

  test('maps cancel DioException to CancelledFailure', () {
    final ex = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.cancel,
    );
    expect(mapper.map(ex), isA<CancelledFailure>());
  });

  test('maps connectionError DioException to NoConnectionFailure', () {
    final ex = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.connectionError,
    );
    expect(mapper.map(ex), isA<NoConnectionFailure>());
  });

  test('maps badResponse DioException to BadResponseFailure', () {
    final ex = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 401,
        data: {'message': 'Unauthorized'},
      ),
    );
    final mapped = mapper.map(ex);
    expect(mapped, isA<BadResponseFailure>());
    expect((mapped as BadResponseFailure).statusCode, 401);
    expect(mapped.message, 'Unauthorized');
  });

  test('maps unknown errors to UnexpectedFailure', () {
    final mapped = mapper.map(Exception('boom'));
    expect(mapped, isA<UnexpectedFailure>());
  });
}

