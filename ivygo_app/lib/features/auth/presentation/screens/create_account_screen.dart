import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

// Providers for local state
final obscureCreatePasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final obscureConfirmPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final createAccountLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final selectedAccountTypeProvider =
    StateProvider.autoDispose<String>((ref) => 'Individual');

class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Back button
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: context.appColors.textPrimary, size: 20),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Text(
                'Create your\naccount',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Join Ivygo and start charging smarter.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 36),
              // Account type selector
              Text('Account Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  )),
              const SizedBox(height: 10),
              const _AccountTypeSelector(),
              const SizedBox(height: 28),
              const _CreateAccountForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeSelector extends ConsumerWidget {
  const _AccountTypeSelector();

  static const List<String> _accountTypes = ['Individual', 'Business', 'Fleet'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeProvider);

    return Row(
      children: _accountTypes.map((type) {
        final isSelected = selectedAccountType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () =>
                ref.read(selectedAccountTypeProvider.notifier).state = type,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: type != _accountTypes.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.appColors.primary.withValues(alpha: 0.15)
                    : context.appColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? context.appColors.primary : context.appColors.border,
                  width: isSelected ? 1.5 : 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected
                        ? context.appColors.primary
                        : context.appColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CreateAccountForm extends ConsumerStatefulWidget {
  const _CreateAccountForm();

  @override
  ConsumerState<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends ConsumerState<_CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      ref.read(createAccountLoadingProvider.notifier).state = true;
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        ref.read(createAccountLoadingProvider.notifier).state = false;
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obscurePassword = ref.watch(obscureCreatePasswordProvider);
    final obscureConfirm = ref.watch(obscureConfirmPasswordProvider);
    final isLoading = ref.watch(createAccountLoadingProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full name
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: context.appColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'John Doe',
              prefixIcon: Icon(Icons.person_outline_rounded,
                  color: context.appColors.textMuted),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
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
          // Password
          TextFormField(
            controller: _passwordController,
            obscureText: obscurePassword,
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
                onPressed: () => ref
                    .read(obscureCreatePasswordProvider.notifier)
                    .state = !obscurePassword,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: obscureConfirm,
            style: TextStyle(color: context.appColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: '••••••••',
              prefixIcon: Icon(Icons.lock_outline_rounded,
                  color: context.appColors.textMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.appColors.textMuted,
                ),
                onPressed: () => ref
                    .read(obscureConfirmPasswordProvider.notifier)
                    .state = !obscureConfirm,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          // Create button
          ElevatedButton(
            onPressed: isLoading ? null : _createAccount,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Create Account'),
          ),
          const SizedBox(height: 28),
          // Sign in link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: theme.textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  'Sign In',
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
