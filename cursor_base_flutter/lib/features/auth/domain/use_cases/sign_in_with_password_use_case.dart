import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';

class SignInWithPasswordParams {
  const SignInWithPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignInWithPasswordUseCase
    extends BaseUseCase<void, SignInWithPasswordParams> {
  const SignInWithPasswordUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(SignInWithPasswordParams params) {
    return _authRepository.signInWithPassword(
      email: params.email,
      password: params.password,
    );
  }
}

