import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/app/app.dart';
import 'package:flutter_cursor_plugin_example/features/auth/data/auth_repository_impl.dart';
import 'package:flutter_cursor_plugin_example/features/auth/data/biometric_auth_gateway.dart';
import 'package:flutter_cursor_plugin_example/features/counter/data/in_memory_counter_repository.dart';

void main() {
  final counterRepository = InMemoryCounterRepository();
  final authRepository = AuthRepositoryImpl(
    biometricGateway: BiometricAuthGatewayImpl(),
  );
  runApp(
    ExampleApp(
      authRepository: authRepository,
      counterRepository: counterRepository,
    ),
  );
}
