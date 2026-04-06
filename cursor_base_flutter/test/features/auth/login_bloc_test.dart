import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/load_biometric_capabilities_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_biometric_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockLoadBiometricCapabilitiesUseCase extends Mock
    implements LoadBiometricCapabilitiesUseCase {}

class _MockSignInWithPasswordUseCase extends Mock
    implements SignInWithPasswordUseCase {}

class _MockSignInWithBiometricUseCase extends Mock
    implements SignInWithBiometricUseCase {}

void main() {
  late _MockLoadBiometricCapabilitiesUseCase loadBiometricCapabilitiesUseCase;
  late _MockSignInWithPasswordUseCase signInWithPasswordUseCase;
  late _MockSignInWithBiometricUseCase signInWithBiometricUseCase;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(
      const SignInWithPasswordParams(email: 'fallback', password: 'fallback'),
    );
  });

  setUp(() {
    loadBiometricCapabilitiesUseCase = _MockLoadBiometricCapabilitiesUseCase();
    signInWithPasswordUseCase = _MockSignInWithPasswordUseCase();
    signInWithBiometricUseCase = _MockSignInWithBiometricUseCase();
  });

  group('LoginBloc', () {
    LoginBloc buildBloc() {
      return LoginBloc(
        loadBiometricCapabilities: loadBiometricCapabilitiesUseCase,
        signInWithPassword: signInWithPasswordUseCase,
        signInWithBiometric: signInWithBiometricUseCase,
      );
    }

    blocTest<LoginBloc, LoginState>(
      'sets biometricAvailable when device supports biometrics',
      build: () {
        when(
          () => loadBiometricCapabilitiesUseCase(const NoParams()),
        ).thenAnswer(
          (_) async => const UseCaseResult.success(
            BiometricCapabilities(isSupported: true, canAuthenticateWithBiometrics: true),
          ),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const LoginStarted()),
      wait: const Duration(milliseconds: 20),
      expect: () => [const LoginState(biometricAvailable: true)],
    );

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
        when(
          () => loadBiometricCapabilitiesUseCase(const NoParams()),
        ).thenAnswer(
          (_) async => const UseCaseResult.success(
            BiometricCapabilities(isSupported: true, canAuthenticateWithBiometrics: true),
          ),
        );
        when(
          () => signInWithBiometricUseCase(const NoParams()),
        ).thenAnswer((_) async => const UseCaseResult.success(null));
      },
      build: buildBloc,
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
