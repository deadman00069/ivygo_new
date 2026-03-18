import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ivygo_app/widgets/widgets.dart';

import '../widgets/forgot_password_form.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: AppBackButton(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Forgot password?',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                "Enter your email address and we'll send you a link to reset your password.",
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              const ForgotPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
