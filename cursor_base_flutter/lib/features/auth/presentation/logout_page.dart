import 'package:flutter/material.dart';
import 'package:flutter_cursor_plugin_example/app/di/service_locator.dart';
import 'package:flutter_cursor_plugin_example/core/domain/use_cases/base_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/login_page.dart';

/// Confirms sign-out, then clears the navigation stack back to [LoginPage].
class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key, this.signOutUseCase});

  final SignOutUseCase? signOutUseCase;

  Future<void> _onConfirm(BuildContext context) async {
    await (signOutUseCase ?? sl<SignOutUseCase>())(const NoParams());
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign out')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You will return to the sign-in screen. Continue?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      key: const Key('logout_cancel_button'),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      key: const Key('logout_confirm_button'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      onPressed: () => _onConfirm(context),
                      child: const Text('Sign out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
