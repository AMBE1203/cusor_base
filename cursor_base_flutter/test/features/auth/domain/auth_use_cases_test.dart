import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
  });

  test('SignInWithPasswordUseCase delegates to repository', () async {
    when(
      () => repository.signInWithPassword(
        email: 'demo@example.com',
        password: 'password123',
      ),
    ).thenAnswer((_) async {});

    final useCase = SignInWithPasswordUseCase(repository);
    final result = await useCase(
      const SignInWithPasswordParams(
        email: 'demo@example.com',
        password: 'password123',
      ),
    );

    expect(result.isSuccess, isTrue);
    verify(
      () => repository.signInWithPassword(
        email: 'demo@example.com',
        password: 'password123',
      ),
    ).called(1);
  });

  test('SignOutUseCase delegates to repository', () async {
    when(() => repository.signOut()).thenAnswer((_) async {});

    final useCase = SignOutUseCase(repository);
    final result = await useCase(const NoParams());

    expect(result.isSuccess, isTrue);
    verify(() => repository.signOut()).called(1);
  });

  test('use-cases wrap unknown exceptions as failures', () async {
    when(
      () => repository.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(Exception('boom'));

    final useCase = SignInWithPasswordUseCase(repository);
    final result = await useCase(
      const SignInWithPasswordParams(
        email: 'demo@example.com',
        password: 'password123',
      ),
    );

    expect(result, isA<UseCaseResult<void>>());
    expect(result.isSuccess, isFalse);
    expect(result.failure, isNotNull);
  });
}
