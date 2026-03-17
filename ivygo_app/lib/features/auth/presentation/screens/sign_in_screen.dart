import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/features/auth/providers/auth_provider.dart';
import 'package:ivygo_app/theme/app_theme.dart';

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
        context.go('/home');
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
              _buildBrand(context, theme),
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
              _SignInForm(isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.appColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.electric_bolt_rounded,
            color: Colors.black,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Ivygo',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SignInForm extends ConsumerStatefulWidget {
  final bool isLoading;
  const _SignInForm({required this.isLoading});

  @override
  ConsumerState<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<_SignInForm> {
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
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obscurePassword = ref.watch(obscurePasswordProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !widget.isLoading,
            style: TextStyle(color: context.appColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon:
                  Icon(Icons.mail_outline_rounded, color: context.appColors.textMuted),
            ),
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
          TextFormField(
            controller: _passwordController,
            obscureText: obscurePassword,
            enabled: !widget.isLoading,
            style: TextStyle(color: context.appColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline_rounded,
                  color: context.appColors.textMuted),
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
              onPressed: widget.isLoading ? null : () {},
              style: TextButton.styleFrom(
                foregroundColor: context.appColors.primary,
                padding: EdgeInsets.zero,
              ),
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _signIn,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Sign In'),
          ),
          const SizedBox(height: 32),
          _buildDividerRow(context, theme),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: widget.isLoading ? null : () {},
            icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
            label: const Text('Continue with Google'),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap:
                    widget.isLoading ? null : () => context.push('/register'),
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

  Widget _buildDividerRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.appColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('or continue with', style: theme.textTheme.bodySmall),
        ),
        Expanded(child: Divider(color: context.appColors.border)),
      ],
    );
  }
}
