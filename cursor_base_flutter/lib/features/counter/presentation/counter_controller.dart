import 'package:flutter/foundation.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';

class CounterController extends ChangeNotifier {
  CounterController({required CounterRepository repository})
    : _repository = repository;

  final CounterRepository _repository;

  int _count = 0;
  int get count => _count;

  Future<void> load() async {
    _count = await _repository.current();
    notifyListeners();
  }

  Future<void> increment() async {
    _count = await _repository.increment();
    notifyListeners();
  }
}
