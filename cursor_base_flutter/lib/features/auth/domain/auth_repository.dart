import 'package:equatable/equatable.dart';

/// Capabilities of the current device with respect to biometrics.
class BiometricCapabilities extends Equatable {
  const BiometricCapabilities({
    required this.isSupported,
    required this.canAuthenticateWithBiometrics,
  });

  /// Whether the platform supports any form of biometrics at all.
  final bool isSupported;

  /// Whether the user can currently authenticate with biometrics.
  final bool canAuthenticateWithBiometrics;

  @override
  List<Object?> get props => [isSupported, canAuthenticateWithBiometrics];
}

/// Abstraction for authentication operations.
abstract class AuthRepository {
  Future<BiometricCapabilities> loadBiometricCapabilities();

  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  Future<void> signInWithBiometric();

  Future<void> signOut();
}

