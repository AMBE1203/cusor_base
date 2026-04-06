import 'package:dio/dio.dart';
import 'package:flutter_cursor_plugin_example/core/network/dio_api_client.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late DioApiClient client;

  setUp(() {
    dio = _MockDio();
    client = DioApiClient(dio: dio, errorMapper: const NetworkErrorMapper());
  });

  test('getJson returns map response data', () async {
    when(
      () => dio.request<Object?>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response<Object?>(
        requestOptions: RequestOptions(path: '/users'),
        data: {'id': 1},
      ),
    );

    final data = await client.getJson('/users');
    expect(data['id'], 1);
  });

  test('getJsonList returns list response data', () async {
    when(
      () => dio.request<Object?>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response<Object?>(
        requestOptions: RequestOptions(path: '/items'),
        data: [1, 2, 3],
      ),
    );

    final data = await client.getJsonList('/items');
    expect(data, [1, 2, 3]);
  });
}

