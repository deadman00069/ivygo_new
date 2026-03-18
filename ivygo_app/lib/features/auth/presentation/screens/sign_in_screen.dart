import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/features/auth/providers/auth_provider.dart';
import 'package:ivygo_app/widgets/widgets.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

import '../widgets/sign_in_form.dart';

final obscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authProvider, (_, next) {
      if (next is AuthAuthenticated && context.mounted) {
        context.go(AppRoutes.mapHome.path);
      } else if (next is AuthError && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const BrandLogo(),
              const SizedBox(height: 48),
              Text(
                'Sign in to your\naccount',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back! Enter your credentials to continue.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              // We extract the form to keep our main build method clean
              // and focused on the screen layout.
              SignInForm(isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
