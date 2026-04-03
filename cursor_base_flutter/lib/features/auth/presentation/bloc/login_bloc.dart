import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(const LoginState()) {
    on<LoginStarted>(_onStarted);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginBiometricRequested>(_onBiometricRequested);
  }

  final AuthRepository _authRepository;

  Future<void> _onStarted(LoginStarted event, Emitter<LoginState> emit) async {
    try {
      final caps = await _authRepository.loadBiometricCapabilities();
      emit(
        state.copyWith(
          biometricAvailable: caps.canAuthenticateWithBiometrics,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
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
    try {
      await _authRepository.signInWithPassword(
        email: state.email.trim(),
        password: state.password,
      );
      emit(state.copyWith(status: LoginFormStatus.success));
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(
          status: LoginFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginFormStatus.failure,
          errorMessage: 'Something went wrong. Try again.',
        ),
      );
    }
  }

  Future<void> _onBiometricRequested(
    LoginBiometricRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(status: LoginFormStatus.loading, clearErrorMessage: true),
    );
    try {
      await _authRepository.signInWithBiometric();
      emit(state.copyWith(status: LoginFormStatus.success));
    } on AuthFailure catch (e) {
      emit(
        state.copyWith(
          status: LoginFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginFormStatus.failure,
          errorMessage: 'Something went wrong. Try again.',
        ),
      );
    }
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
