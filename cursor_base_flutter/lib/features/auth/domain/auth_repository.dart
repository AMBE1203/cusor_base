/// Abstraction for authentication operations.
abstract class AuthRepository {
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
