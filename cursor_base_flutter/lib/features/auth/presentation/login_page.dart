import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cursor_plugin_example/app/di/service_locator.dart';
import 'package:flutter_cursor_plugin_example/core/presentation/base_bloc_page.dart';
import 'package:flutter_cursor_plugin_example/features/auth/domain/use_cases/sign_in_with_password_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_cursor_plugin_example/features/auth/presentation/forgot_password_page.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/get_current_count_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/domain/use_cases/increment_counter_use_case.dart';
import 'package:flutter_cursor_plugin_example/features/counter/presentation/counter_page.dart';

/// Login screen matching Figma node `675:1044` (file `Ix4ugAIRCsMLByr0UkOeab`).
class LoginPage extends BaseBlocPage<LoginBloc> {
  const LoginPage({
    super.key,
    this.signInWithPasswordUseCase,
    this.getCurrentCountUseCase,
    this.incrementCounterUseCase,
  });

  final SignInWithPasswordUseCase? signInWithPasswordUseCase;
  final GetCurrentCountUseCase? getCurrentCountUseCase;
  final IncrementCounterUseCase? incrementCounterUseCase;

  @override
  LoginBloc createBloc(BuildContext context) {
    return LoginBloc(
      signInWithPassword:
          signInWithPasswordUseCase ?? sl<SignInWithPasswordUseCase>(),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _LoginScaffold(
      getCurrentCountUseCase: getCurrentCountUseCase,
      incrementCounterUseCase: incrementCounterUseCase,
    );
  }
}

class _LoginScaffold extends StatefulWidget {
  const _LoginScaffold({
    this.getCurrentCountUseCase,
    this.incrementCounterUseCase,
  });

  final GetCurrentCountUseCase? getCurrentCountUseCase;
  final IncrementCounterUseCase? incrementCounterUseCase;

  @override
  State<_LoginScaffold> createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<_LoginScaffold> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Demo-only selection; wire to API / repository when backend exists.
  String? _selectedSchoolId;

  String? _selectedRoleLabel;

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
          getCurrentCountUseCase: widget.getCurrentCountUseCase,
          incrementCounterUseCase: widget.incrementCounterUseCase,
        ),
      ),
    );
  }

  Future<void> _pickSchool(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final e in _kDemoSchools)
                ListTile(
                  title: Text(e.$2),
                  onTap: () => Navigator.pop(ctx, e.$1),
                ),
            ],
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedSchoolId = picked);
    }
  }

  Future<void> _pickRole(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final r in _kDemoRoles)
                ListTile(
                  title: Text(r),
                  onTap: () => Navigator.pop(ctx, r),
                ),
            ],
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedRoleLabel = picked);
    }
  }

  String _schoolDisplayLabel() {
    if (_selectedSchoolId == null) {
      return '';
    }
    for (final e in _kDemoSchools) {
      if (e.$1 == _selectedSchoolId) {
        return e.$2;
      }
    }
    return _selectedSchoolId!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status == ViewStatus.success) {
          _openHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final loading = state.status == ViewStatus.loading;
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const _GradientHeader(),
                      const SizedBox(height: 12),
                      const _LogoCard(),
                      const SizedBox(height: 14),
                      _FormCard(
                        child: Column(
                          children: [
                            const SizedBox(height: 18),
                            _PickerRow(
                              key: const Key('login_school_field'),
                              hintText: 'Chọn trường',
                              valueText: _schoolDisplayLabel(),
                              enabled: !loading,
                              leading: const Icon(
                                Icons.apartment,
                                color: Color(0xFFB9B9B9),
                              ),
                              onTap: loading
                                  ? null
                                  : () => _pickSchool(context),
                            ),
                            const SizedBox(height: 18),
                            _PickerRow(
                              key: const Key('login_role_field'),
                              hintText: 'Chọn vai trò',
                              valueText: _selectedRoleLabel ?? '',
                              enabled: !loading,
                              onTap: loading
                                  ? null
                                  : () => _pickRole(context),
                            ),
                            const SizedBox(height: 18),
                            AutofillGroup(
                              child: Column(
                                children: [
                                  _TextEntryField(
                                    key: const Key('login_email_field'),
                                    controller: _emailController,
                                    hintText: 'Tên đăng nhập',
                                    enabled: !loading,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [
                                      AutofillHints.username,
                                      AutofillHints.email,
                                    ],
                                    onChanged: (v) => context
                                        .read<LoginBloc>()
                                        .add(LoginEmailChanged(v)),
                                  ),
                                  const SizedBox(height: 18),
                                  _TextEntryField(
                                    key: const Key('login_password_field'),
                                    controller: _passwordController,
                                    hintText: 'Mật khẩu',
                                    enabled: !loading,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    onChanged: (v) => context
                                        .read<LoginBloc>()
                                        .add(LoginPasswordChanged(v)),
                                    onSubmitted: (_) => loading
                                        ? null
                                        : context
                                            .read<LoginBloc>()
                                            .add(const LoginSubmitted()),
                                  ),
                                ],
                              ),
                            ),
                            if (state.errorMessage != null) ...[
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  state.errorMessage!,
                                  key: const Key('login_error_message'),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            _PrimaryLoginButton(
                              key: const Key('login_submit_button'),
                              loading: loading,
                              onPressed: loading
                                  ? null
                                  : () => context
                                      .read<LoginBloc>()
                                      .add(const LoginSubmitted()),
                            ),
                            const SizedBox(height: 10),
                            _ForgotPasswordButton(
                              onPressed: loading
                                  ? null
                                  : () {
                                      Navigator.of(context).push<void>(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              const ForgotPasswordPage(),
                                        ),
                                      );
                                    },
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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

class _GradientHeader extends StatelessWidget {
  const _GradientHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD2E0EB),
            Color(0xFF2196F3),
          ],
        ),
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.3)),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MicrosoftLikeMark(),
          SizedBox(width: 10),
          Text(
            'Unisoft',
            style: TextStyle(
              fontSize: 23,
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _MicrosoftLikeMark extends StatelessWidget {
  const _MicrosoftLikeMark();

  @override
  Widget build(BuildContext context) {
    const size = 14.0;
    const gap = 2.0;
    return SizedBox(
      width: size * 2 + gap,
      height: size * 2 + gap,
      child: const Column(
        children: [
          Row(
            children: [
              _Square(color: Color(0xFF7CFC00)),
              SizedBox(width: gap),
              _Square(color: Color(0xFFFFFF00)),
            ],
          ),
          SizedBox(height: gap),
          Row(
            children: [
              _Square(color: Color(0xFF1E90FF)),
              SizedBox(width: gap),
              _Square(color: Color(0xFFFF4500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Square extends StatelessWidget {
  const _Square({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB5B5B5)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: child,
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    super.key,
    required this.hintText,
    required this.valueText,
    required this.enabled,
    this.leading,
    this.onTap,
  });

  final String hintText;
  final String valueText;
  final bool enabled;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = valueText.isNotEmpty;
    return Semantics(
      button: true,
      enabled: enabled,
      label: hasValue ? valueText : hintText,
      child: _ShadowFieldContainer(
        onTap: enabled ? onTap : null,
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                hasValue ? valueText : hintText,
                style: TextStyle(
                  fontSize: 18,
                  color: hasValue
                      ? const Color(0xFF6D6D6D)
                      : const Color(0xFFB9B9B9),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: enabled
                  ? const Color(0xFF2F2F2F)
                  : const Color(0xFF9E9E9E),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextEntryField extends StatelessWidget {
  const _TextEntryField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.enabled,
    required this.textInputAction,
    this.keyboardType,
    this.autofillHints,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return _ShadowFieldContainer(
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        textInputAction: textInputAction,
        obscureText: obscureText,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18,
            color: Color(0xFFB9B9B9),
          ),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _ShadowFieldContainer extends StatelessWidget {
  const _ShadowFieldContainer({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFF9E9E9E)),
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    );
    final inner = Container(
      width: 250,
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: decoration,
      child: child,
    );
    if (onTap == null) {
      return inner;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: inner,
      ),
    );
  }
}

class _PrimaryLoginButton extends StatelessWidget {
  const _PrimaryLoginButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      height: 39,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3),
          border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.3)),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Đăng Nhập',
                  style: TextStyle(fontSize: 18),
                ),
        ),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
      child: const Text(
        'Quên mật khẩu',
        style: TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}

/// Demo catalogs — replace with API-driven options when available.
const _kDemoSchools = <(String, String)>[
  ('school_thpt_1', 'Trường THPT Nguyễn Du'),
  ('school_thpt_2', 'Trường THPT Lê Lợi'),
];

const _kDemoRoles = <String>[
  'Giảng viên',
  'Trợ giảng',
];
