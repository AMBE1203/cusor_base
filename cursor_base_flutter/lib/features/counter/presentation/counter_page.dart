import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/app/di/service_locator.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/logout_page.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/get_current_count_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/increment_counter_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/presentation/counter_controller.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({
    super.key,
    this.getCurrentCountUseCase,
    this.incrementCounterUseCase,
  });

  final GetCurrentCountUseCase? getCurrentCountUseCase;
  final IncrementCounterUseCase? incrementCounterUseCase;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late final CounterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CounterController(
      getCurrentCount: widget.getCurrentCountUseCase ?? sl<GetCurrentCountUseCase>(),
      incrementCounter:
          widget.incrementCounterUseCase ?? sl<IncrementCounterUseCase>(),
    );
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
