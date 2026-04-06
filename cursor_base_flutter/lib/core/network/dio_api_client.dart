import 'package:dio/dio.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';
import 'package:flutter_cursor_plugin_example/core/network/api_client.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_error_mapper.dart';

class DioApiClient implements ApiClient {
  const DioApiClient({
    required Dio dio,
    required NetworkErrorMapper errorMapper,
  }) : _dio = dio,
       _errorMapper = errorMapper;

  final Dio _dio;
  final NetworkErrorMapper _errorMapper;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _requestJsonMap(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _requestJsonList(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _requestJsonMap(
      method: 'POST',
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> _requestJsonMap({
    required String method,
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final data = await _request(
      method: method,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw const UnexpectedFailure('Invalid response format.');
  }

  Future<List<dynamic>> _requestJsonList({
    required String method,
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final data = await _request(
      method: method,
      path: path,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
    );
    if (data is List<dynamic>) {
      return data;
    }
    if (data is List) {
      return List<dynamic>.from(data);
    }
    throw const UnexpectedFailure('Invalid response format.');
  }

  Future<Object?> _request({
    required String method,
    required String path,
    Object? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      );
      return response.data;
    } catch (e) {
      throw _errorMapper.map(e);
    }
  }
}

