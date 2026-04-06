import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';

class GetCurrentCountUseCase extends BaseUseCase<int, NoParams> {
  const GetCurrentCountUseCase(this._counterRepository);

  final CounterRepository _counterRepository;

  @override
  Future<int> execute(NoParams params) {
    return _counterRepository.current();
  }
}

