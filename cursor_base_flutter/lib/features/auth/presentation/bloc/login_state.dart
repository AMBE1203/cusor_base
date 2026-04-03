part of 'login_bloc.dart';

enum LoginFormStatus { initial, loading, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginFormStatus.initial,
    this.biometricAvailable = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final LoginFormStatus status;
  final bool biometricAvailable;
  final String? errorMessage;

  LoginState copyWith({
    String? email,
    String? password,
    LoginFormStatus? status,
    bool? biometricAvailable,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    status,
    biometricAvailable,
    errorMessage,
  ];
}
