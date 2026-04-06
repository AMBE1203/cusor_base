import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/get_current_count_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/increment_counter_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockCounterRepository extends Mock implements CounterRepository {}

void main() {
  late _MockCounterRepository repository;

  setUp(() {
    repository = _MockCounterRepository();
  });

  test('GetCurrentCountUseCase delegates to repository', () async {
    when(() => repository.current()).thenAnswer((_) async => 10);

    final useCase = GetCurrentCountUseCase(repository);
    final actual = await useCase(const NoParams());

    expect(actual.isSuccess, isTrue);
    expect(actual.data, 10);
    verify(() => repository.current()).called(1);
  });

  test('IncrementCounterUseCase delegates to repository', () async {
    when(() => repository.increment()).thenAnswer((_) async => 11);

    final useCase = IncrementCounterUseCase(repository);
    final actual = await useCase(const NoParams());

    expect(actual.isSuccess, isTrue);
    expect(actual.data, 11);
    verify(() => repository.increment()).called(1);
  });
}

