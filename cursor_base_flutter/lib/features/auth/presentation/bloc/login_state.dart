part of 'login_bloc.dart';

final class LoginState extends BaseViewState {
  const LoginState({
    this.email = '',
    this.password = '',
    super.status = ViewStatus.initial,
    super.errorMessage,
  });

  final String email;
  final String password;

  LoginState copyWith({
    String? email,
    String? password,
    ViewStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    ...super.props,
  ];
}
