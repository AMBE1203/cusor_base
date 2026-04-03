import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/auth_repository.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/counter_repository.dart';
import 'package:flutter_cursor_plugin_example/features/counter/presentation/counter_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required this.authRepository,
    required this.counterRepository,
  });

  final AuthRepository authRepository;
  final CounterRepository counterRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository)..add(const LoginStarted()),
      child: _LoginScaffold(
        authRepository: authRepository,
        counterRepository: counterRepository,
      ),
    );
  }
}

class _LoginScaffold extends StatefulWidget {
  const _LoginScaffold({
    required this.authRepository,
    required this.counterRepository,
  });

  final AuthRepository authRepository;
  final CounterRepository counterRepository;

  @override
  State<_LoginScaffold> createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<_LoginScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CounterPage(
          authRepository: widget.authRepository,
          counterRepository: widget.counterRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status == LoginFormStatus.success) {
          _openHome(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign in')),
        body: SafeArea(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final loading = state.status == LoginFormStatus.loading;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Use demo@example.com / password123',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        key: const Key('login_email_field'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) =>
                            context.read<LoginBloc>().add(LoginEmailChanged(v)),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        key: const Key('login_password_field'),
                        controller: _passwordController,
                        obscureText: true,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => context.read<LoginBloc>().add(
                          LoginPasswordChanged(v),
                        ),
                        onSubmitted: (_) => loading
                            ? null
                            : context.read<LoginBloc>().add(
                                const LoginSubmitted(),
                              ),
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.errorMessage!,
                          key: const Key('login_error_message'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const Key('login_submit_button'),
                        onPressed: loading
                            ? null
                            : () => context.read<LoginBloc>().add(
                                const LoginSubmitted(),
                              ),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign in'),
                      ),
                      if (state.biometricAvailable) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          key: const Key('login_biometric_button'),
                          onPressed: loading
                              ? null
                              : () => context.read<LoginBloc>().add(
                                  const LoginBiometricRequested(),
                                ),
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Use biometrics'),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
