import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_failure.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';

/// Demo credentials; replace with real API + secure storage later.
class AuthRepositoryImpl implements AuthRepository {
  /// Stub success pair for demos and tests.
  static const demoEmail = 'demo@example.com';
  static const demoPassword = 'password123';

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final ok = email.trim() == demoEmail && password == demoPassword;
    if (!ok) {
      throw const InvalidCredentialsFailure();
    }
  }

  @override
  Future<void> signOut() async {
    // Persisted session not used in demo; revoke tokens / clear secure storage here later.
  }
}
