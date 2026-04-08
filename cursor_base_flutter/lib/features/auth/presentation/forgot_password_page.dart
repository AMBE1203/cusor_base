import 'package:flutter/material.dart';

/// Placeholder until product defines reset flow (email link, support ticket, etc.).
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text(
              'Tính năng đang được hoàn thiện. Vui lòng liên hệ quản trị viên.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
