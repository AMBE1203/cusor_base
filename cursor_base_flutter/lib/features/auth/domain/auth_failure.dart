import 'package:flutter_cursor_plugin_example/core/domain/failures/failure.dart';

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
    : super('Invalid email or password.');
}
