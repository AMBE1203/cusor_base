import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/load_biometric_capabilities_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_biometric_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LoadBiometricCapabilitiesUseCase loadBiometricCapabilities,
    required SignInWithPasswordUseCase signInWithPassword,
    required SignInWithBiometricUseCase signInWithBiometric,
  }) : _loadBiometricCapabilities = loadBiometricCapabilities,
       _signInWithPassword = signInWithPassword,
       _signInWithBiometric = signInWithBiometric,
       super(const LoginState()) {
    on<LoginStarted>(_onStarted);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginBiometricRequested>(_onBiometricRequested);
  }

  final LoadBiometricCapabilitiesUseCase _loadBiometricCapabilities;
  final SignInWithPasswordUseCase _signInWithPassword;
  final SignInWithBiometricUseCase _signInWithBiometric;

  Future<void> _onStarted(LoginStarted event, Emitter<LoginState> emit) async {
    final result = await _loadBiometricCapabilities(const NoParams());
    if (result.isSuccess && result.data != null) {
      final caps = result.data!;
      emit(
        state.copyWith(
          biometricAvailable: caps.canAuthenticateWithBiometrics,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(state.copyWith(biometricAvailable: false));
    }
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        status: LoginFormStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        status: LoginFormStatus.initial,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final validationError = _validateFields(state.email, state.password);
    if (validationError != null) {
      emit(state.copyWith(errorMessage: validationError));
      return;
    }

    emit(
      state.copyWith(status: LoginFormStatus.loading, clearErrorMessage: true),
    );
    final result = await _signInWithPassword(
      SignInWithPasswordParams(
        email: state.email.trim(),
        password: state.password,
      ),
    );
    if (result.isSuccess) {
      emit(state.copyWith(status: LoginFormStatus.success));
      return;
    }
    emit(
      state.copyWith(
        status: LoginFormStatus.failure,
        errorMessage: _mapFailureMessage(result),
      ),
    );
  }

  Future<void> _onBiometricRequested(
    LoginBiometricRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(status: LoginFormStatus.loading, clearErrorMessage: true),
    );
    final result = await _signInWithBiometric(const NoParams());
    if (result.isSuccess) {
      emit(state.copyWith(status: LoginFormStatus.success));
      return;
    }
    emit(
      state.copyWith(
        status: LoginFormStatus.failure,
        errorMessage: _mapFailureMessage(result),
      ),
    );
  }

  String _mapFailureMessage(UseCaseResult<void> result) {
    final message = result.failure?.message;
    if (message == null || message.isEmpty) {
      return 'Something went wrong. Try again.';
    }
    return message;
  }

  String? _validateFields(String email, String password) {
    if (email.trim().isEmpty) {
      return 'Email is required.';
    }
    if (!_isRoughEmail(email.trim())) {
      return 'Enter a valid email address.';
    }
    if (password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  bool _isRoughEmail(String value) {
    final at = value.indexOf('@');
    if (at <= 0 || at == value.length - 1) {
      return false;
    }
    final dot = value.indexOf('.', at);
    return dot > at + 1 && dot < value.length - 1;
  }
}
