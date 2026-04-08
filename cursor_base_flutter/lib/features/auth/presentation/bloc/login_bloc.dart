import 'package:bloc/bloc.dart';
import 'package:flutter_cursor_plugin_example/core/domain/failures/use_case_result.dart';
import 'package:flutter_cursor_plugin_example/core/presentation/bloc/base_bloc.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';

export 'package:flutter_cursor_plugin_example/core/presentation/bloc/base_state.dart'
    show ViewStatus;

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc({
    required SignInWithPasswordUseCase signInWithPassword,
  }) : _signInWithPassword = signInWithPassword,
       super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final SignInWithPasswordUseCase _signInWithPassword;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        status: ViewStatus.initial,
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
        status: ViewStatus.initial,
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
      state.copyWith(status: ViewStatus.loading, clearErrorMessage: true),
    );
    final result = await _signInWithPassword(
      SignInWithPasswordParams(
        email: state.email.trim(),
        password: state.password,
      ),
    );
    if (result.isSuccess) {
      emit(state.copyWith(status: ViewStatus.success));
      return;
    }
    emit(
      state.copyWith(
        status: ViewStatus.failure,
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
