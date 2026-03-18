import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';
import 'package:ivygo_app/widgets/widgets.dart';

import '../widgets/account_type_selector.dart';
import '../widgets/create_account_form.dart';

// Providers for local state
final obscureCreatePasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final obscureConfirmPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);
final createAccountLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final selectedAccountTypeProvider =
    StateProvider.autoDispose<String>((ref) => 'Resident');
final selectedCountryCodeProvider =
    StateProvider.autoDispose<String>((ref) => '91');

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
              AppBackButton(onPressed: () => context.pop()),
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
              const AccountTypeSelector(),
              const SizedBox(height: 28),
              const CreateAccountForm(),
            ],
          ),
        ),
      ),
    );
  }
}
