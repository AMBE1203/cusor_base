import 'package:flutter_cursor_plugin_example/features/auth/data/biometric_auth_gateway.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';

/// Demo credentials and biometric bridge; replace with real API + secure storage later.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required BiometricAuthGateway biometricGateway})
    : _biometric = biometricGateway;

  final BiometricAuthGateway _biometric;

  /// Stub success pair for demos and tests.
  static const demoEmail = 'demo@example.com';
  static const demoPassword = 'password123';

  @override
  Future<BiometricCapabilities> loadBiometricCapabilities() async {
    final supported = await _biometric.isDeviceSupported();
    final canUse = supported && await _biometric.canCheckBiometrics();
    return BiometricCapabilities(
      isSupported: supported,
      canAuthenticateWithBiometrics: canUse,
    );
  }

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final ok =
        email.trim() == demoEmail && password == demoPassword;
    if (!ok) {
      throw const InvalidCredentialsFailure();
    }
  }

  @override
  Future<void> signInWithBiometric() async {
    final caps = await loadBiometricCapabilities();
    if (!caps.canAuthenticateWithBiometrics) {
      throw const BiometricUnavailableFailure();
    }
    final authed = await _biometric.authenticate(
      localizedReason: 'Sign in with biometrics',
    );
    if (!authed) {
      throw const BiometricAuthFailure();
    }
  }

  @override
  Future<void> signOut() async {
    // Persisted session not used in demo; revoke tokens / clear secure storage here later.
  }
}
