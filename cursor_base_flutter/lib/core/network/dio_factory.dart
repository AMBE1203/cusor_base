import 'package:dio/dio.dart';

class DioFactory {
  const DioFactory();

  Dio create({
    required String baseUrl,
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll(interceptors);
    return dio;
  }
}

