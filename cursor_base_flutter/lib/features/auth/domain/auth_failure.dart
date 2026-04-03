sealed class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
    : super('Invalid email or password.');
}

final class BiometricAuthFailure extends AuthFailure {
  const BiometricAuthFailure([super.message = 'Biometric authentication failed.']);
}

final class BiometricUnavailableFailure extends AuthFailure {
  const BiometricUnavailableFailure()
    : super('Biometric authentication is not available on this device.');
}
