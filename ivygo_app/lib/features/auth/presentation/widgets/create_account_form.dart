import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/buttons/primary_button.dart';
import '../../../../widgets/inputs/app_text_field.dart';
import '../screens/create_account_screen.dart';

class CreateAccountForm extends ConsumerStatefulWidget {
  const CreateAccountForm({super.key});

  @override
  ConsumerState<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends ConsumerState<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _abnController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyNameController.dispose();
    _abnController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        context.go(AppRoutes.mapHome.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obscurePassword = ref.watch(obscureCreatePasswordProvider);
    final obscureConfirm = ref.watch(obscureConfirmPasswordProvider);
    final isLoading = ref.watch(createAccountLoadingProvider);
    final selectedCountryCode = ref.watch(selectedCountryCodeProvider);
    final selectedType = ref.watch(selectedAccountTypeProvider);
    final isBusiness = selectedType == 'Business';

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            child: isBusiness
                ? Column(
                    key: const ValueKey('business_fields'),
                    children: [
                      // Company Name
                      AppTextField(
                        controller: _companyNameController,
                        label: 'Company Name',
                        hintText: 'Enter company name',
                        prefixIcon: Icons.business_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // ABN
                      AppTextField(
                        controller: _abnController,
                        label: 'ABN',
                        hintText: 'Enter ABN number',
                        prefixIcon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ABN';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('resident_fields')),
          ),
          // Full name / Business Contact Name
          AppTextField(
            controller: _nameController,
            label: isBusiness ? 'Business Contact Full Name' : 'Full Name',
            hintText: 'John Doe',
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
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
          // Mobile No / Phone Number
          AppTextField(
            controller: _phoneController,
            label: isBusiness ? 'Mobile No' : 'Phone Number',
            hintText: isBusiness ? 'Enter mobile number' : 'Enter phone number',
            prefix: IntrinsicWidth(
              child: InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      ref.read(selectedCountryCodeProvider.notifier).state =
                          country.phoneCode;
                    },
                    countryListTheme: CountryListThemeData(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      inputDecoration: InputDecoration(
                        hintText: 'Search country',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.appColors.divider,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 20, color: context.appColors.textMuted),
                      const SizedBox(width: 8),
                      Text(
                        '+$selectedCountryCode',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: context.appColors.textMuted),
                      Container(
                        width: 1,
                        height: 24,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        color: context.appColors.divider,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
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
          AppTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hintText: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: obscureConfirm,
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
          PrimaryButton(
            label: 'Create Account',
            isLoading: isLoading,
            onPressed: isLoading ? null : _createAccount,
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
