import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/logout_page.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';
import 'package:flutter_cursor_plugin_example/features/counter/presentation/counter_controller.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    super.key,
    required this.authRepository,
    required this.counterRepository,
  });

  final AuthRepository authRepository;
  final CounterRepository counterRepository;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late final CounterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CounterController(repository: widget.counterRepository);
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Feature Example'),
        actions: [
          TextButton(
            key: const Key('counter_sign_out_button'),
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => LogoutPage(
                    authRepository: widget.authRepository,
                    counterRepository: widget.counterRepository,
                  ),
                ),
              );
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Current value'),
                Text(
                  '${_controller.count}',
                  key: const Key('counter_value'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('increment_button'),
        onPressed: _controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
