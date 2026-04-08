import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/app/app.dart';
import 'package:flutter_cursor_plugin_example/app/di/service_locator.dart';

Future<void> main() async => _bootstrap();

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const ExampleApp());
}
