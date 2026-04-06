import 'package:flutter/foundation.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/get_current_count_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/increment_counter_use_case.dart';

class CounterController extends ChangeNotifier {
  CounterController({
    required GetCurrentCountUseCase getCurrentCount,
    required IncrementCounterUseCase incrementCounter,
  }) : _getCurrentCount = getCurrentCount,
       _incrementCounter = incrementCounter;

  final GetCurrentCountUseCase _getCurrentCount;
  final IncrementCounterUseCase _incrementCounter;

  int _count = 0;
  int get count => _count;

  Future<void> load() async {
    final result = await _getCurrentCount(const NoParams());
    _count = result.data ?? _count;
    notifyListeners();
  }

  Future<void> increment() async {
    final result = await _incrementCounter(const NoParams());
    _count = result.data ?? _count;
    notifyListeners();
  }
}
