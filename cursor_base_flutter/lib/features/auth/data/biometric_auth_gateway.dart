import 'package:local_auth/local_auth.dart';

/// Abstraction over [LocalAuthentication] for testing and clean architecture.
abstract class BiometricAuthGateway {
  Future<bool> isDeviceSupported();

  Future<bool> canCheckBiometrics();

  Future<bool> authenticate({required String localizedReason});
}

class BiometricAuthGatewayImpl implements BiometricAuthGateway {
  BiometricAuthGatewayImpl({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  @override
  Future<bool> isDeviceSupported() => _localAuth.isDeviceSupported();

  @override
  Future<bool> canCheckBiometrics() => _localAuth.canCheckBiometrics;

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    return _localAuth.authenticate(
      localizedReason: localizedReason,
      biometricOnly: true,
    );
  }
}
