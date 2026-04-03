import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/login_page.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({
    super.key,
    required this.authRepository,
    required this.counterRepository,
  });

  final AuthRepository authRepository;
  final CounterRepository counterRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cursor Plugin Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: LoginPage(
        authRepository: authRepository,
        counterRepository: counterRepository,
      ),
    );
  }
}
