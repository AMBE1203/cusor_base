import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignInWithPasswordUseCase extends Mock
    implements SignInWithPasswordUseCase {}

void main() {
  late _MockSignInWithPasswordUseCase signInWithPasswordUseCase;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(
      const SignInWithPasswordParams(email: 'fallback', password: 'fallback'),
    );
  });

  setUp(() {
    signInWithPasswordUseCase = _MockSignInWithPasswordUseCase();
  });

  group('LoginBloc', () {
    LoginBloc buildBloc() {
      return LoginBloc(
        signInWithPassword: signInWithPasswordUseCase,
      );
    }

    blocTest<LoginBloc, LoginState>(
      'emits validation error when email is empty',
      build: buildBloc,
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [const LoginState(errorMessage: 'Email is required.')],
      verify: (_) {
        verifyNever(() => signInWithPasswordUseCase(any()));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'signs in with password and emits success',
      setUp: () {
        when(
          () => signInWithPasswordUseCase(
            any(),
          ),
        ).thenAnswer((_) async => const UseCaseResult.success(null));
      },
      build: buildBloc,
      act: (bloc) => bloc
        ..add(const LoginEmailChanged('demo@example.com'))
        ..add(const LoginPasswordChanged('password123'))
        ..add(const LoginSubmitted()),
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const LoginState(email: 'demo@example.com'),
        const LoginState(email: 'demo@example.com', password: 'password123'),
        const LoginState(
          email: 'demo@example.com',
          password: 'password123',
          status: ViewStatus.loading,
        ),
        const LoginState(
          email: 'demo@example.com',
          password: 'password123',
          status: ViewStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure when credentials are invalid',
      setUp: () {
        when(
          () => signInWithPasswordUseCase(any()),
        ).thenAnswer(
          (_) async => const UseCaseResult.failure(InvalidCredentialsFailure()),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc
        ..add(const LoginEmailChanged('wrong@example.com'))
        ..add(const LoginPasswordChanged('wrongpass'))
        ..add(const LoginSubmitted()),
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const LoginState(email: 'wrong@example.com'),
        const LoginState(email: 'wrong@example.com', password: 'wrongpass'),
        const LoginState(
          email: 'wrong@example.com',
          password: 'wrongpass',
          status: ViewStatus.loading,
        ),
        LoginState(
          email: 'wrong@example.com',
          password: 'wrongpass',
          status: ViewStatus.failure,
          errorMessage: const InvalidCredentialsFailure().message,
        ),
      ],
    );
  });
}
