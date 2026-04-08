part of 'login_bloc.dart';

sealed class LoginEvent extends BaseEvent {
  const LoginEvent();
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
