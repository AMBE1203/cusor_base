import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:flutter_cursor_plugin_example/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_cursor_plugin_example/features/auth/data/biometric_auth_gateway.dart';
import 'package:flutter_cursor_plugin_example/core/network/api_client.dart';
import 'package:flutter_cursor_plugin_example/core/network/dio_api_client.dart';
import 'package:flutter_cursor_plugin_example/core/network/dio_factory.dart';
import 'package:flutter_cursor_plugin_example/core/network/network_error_mapper.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/load_biometric_capabilities_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_biometric_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/data/in_memory_counter_repository.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/get_current_count_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/increment_counter_use_case.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  if (sl.isRegistered<AuthRepository>()) {
    return;
  }

  sl.registerLazySingleton(() => const NetworkErrorMapper());
  sl.registerLazySingleton(() => const DioFactory());
  sl.registerLazySingleton<Dio>(
    () => sl<DioFactory>().create(baseUrl: 'https://example.com'),
  );
  sl.registerLazySingleton<ApiClient>(
    () => DioApiClient(dio: sl<Dio>(), errorMapper: sl<NetworkErrorMapper>()),
  );

  sl.registerLazySingleton<BiometricAuthGateway>(
    () => BiometricAuthGatewayImpl(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(biometricGateway: sl<BiometricAuthGateway>()),
  );

  sl.registerLazySingleton<CounterRepository>(() => InMemoryCounterRepository());

  sl.registerLazySingleton(
    () => LoadBiometricCapabilitiesUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => SignInWithPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
    () => SignInWithBiometricUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => GetCurrentCountUseCase(sl<CounterRepository>()));
  sl.registerLazySingleton(() => IncrementCounterUseCase(sl<CounterRepository>()));
}

Future<void> resetDependenciesForTest() async {
  await sl.reset();
}

