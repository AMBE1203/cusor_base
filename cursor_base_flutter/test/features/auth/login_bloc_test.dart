import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    repository = _MockAuthRepository();
  });

  group('LoginBloc', () {
    blocTest<LoginBloc, LoginState>(
      'sets biometricAvailable when device supports biometrics',
      build: () {
        when(() => repository.loadBiometricCapabilities()).thenAnswer(
          (_) async => const BiometricCapabilities(
            isSupported: true,
            canAuthenticateWithBiometrics: true,
          ),
        );
        return LoginBloc(repository);
      },
      act: (bloc) => bloc.add(const LoginStarted()),
      wait: const Duration(milliseconds: 20),
      expect: () => [const LoginState(biometricAvailable: true)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits validation error when email is empty',
      build: () => LoginBloc(repository),
      act: (bloc) => bloc.add(const LoginSubmitted()),
      expect: () => [const LoginState(errorMessage: 'Email is required.')],
      verify: (_) {
        verifyNever(
          () => repository.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<LoginBloc, LoginState>(
      'signs in with password and emits success',
      setUp: () {
        when(
          () => repository.signInWithPassword(
            email: 'demo@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async {});
      },
      build: () => LoginBloc(repository),
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
          status: LoginFormStatus.loading,
        ),
        const LoginState(
          email: 'demo@example.com',
          password: 'password123',
          status: LoginFormStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits failure when credentials are invalid',
      setUp: () {
        when(
          () => repository.signInWithPassword(
            email: 'wrong@example.com',
            password: 'wrongpass',
          ),
        ).thenThrow(const InvalidCredentialsFailure());
      },
      build: () => LoginBloc(repository),
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
          status: LoginFormStatus.loading,
        ),
        LoginState(
          email: 'wrong@example.com',
          password: 'wrongpass',
          status: LoginFormStatus.failure,
          errorMessage: const InvalidCredentialsFailure().message,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'biometric success emits success state',
      setUp: () {
        when(() => repository.loadBiometricCapabilities()).thenAnswer(
          (_) async => const BiometricCapabilities(
            isSupported: true,
            canAuthenticateWithBiometrics: true,
          ),
        );
        when(() => repository.signInWithBiometric()).thenAnswer((_) async {});
      },
      build: () => LoginBloc(repository),
      act: (bloc) => bloc
        ..add(const LoginStarted())
        ..add(const LoginBiometricRequested()),
      wait: const Duration(milliseconds: 30),
      expect: () => [
        const LoginState(biometricAvailable: true),
        const LoginState(
          status: LoginFormStatus.loading,
          biometricAvailable: true,
        ),
        const LoginState(
          status: LoginFormStatus.success,
          biometricAvailable: true,
        ),
      ],
    );
  });
}
