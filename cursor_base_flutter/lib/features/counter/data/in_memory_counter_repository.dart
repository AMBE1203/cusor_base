import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';

class InMemoryCounterRepository implements CounterRepository {
  int _value = 0;

  @override
  Future<int> current() async {
    return _value;
  }

  @override
  Future<int> increment() async {
    _value += 1;
    return _value;
  }
}
