import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/inputs/app_text_field.dart';
import '../../providers/auth_provider.dart';
import '../screens/sign_in_screen.dart';

class SignInForm extends ConsumerStatefulWidget {
  final bool isLoading;
  const SignInForm({super.key, required this.isLoading});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    context.go(AppRoutes.mapHome.path);

    // if (!(_formKey.currentState?.validate() ?? false)) return;
    // await ref.read(authProvider.notifier).login(
    //       _emailController.text.trim(),
    //       _passwordController.text,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obscurePassword = ref.watch(obscurePasswordProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            enabled: !widget.isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            enabled: !widget.isLoading,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: context.appColors.textMuted,
              ),
              onPressed: widget.isLoading
                  ? null
                  : () {
                      ref.read(obscurePasswordProvider.notifier).state =
                          !obscurePassword;
                    },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () => context.push(AppRoutes.forgotPassword.path),
              style: TextButton.styleFrom(
                foregroundColor: context.appColors.primary,
                padding: EdgeInsets.zero,
              ),
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Sign In',
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _signIn,
          ),
          // const SizedBox(height: 32),
          // const SocialDivider(),
          // const SizedBox(height: 24),
          // OutlinedButton.icon(
          //   onPressed: widget.isLoading ? null : () {},
          //   icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
          //   label: const Text('Continue with Google'),
          // ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: widget.isLoading
                    ? null
                    : () => context.push(AppRoutes.createAccount.path),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: context.appColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
