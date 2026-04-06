import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';

class SignOutUseCase extends BaseUseCase<void, NoParams> {
  const SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(NoParams params) {
    return _authRepository.signOut();
  }
}

