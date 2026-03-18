import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A styled TextFormField for the Ivygo app.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(color: colors.textPrimary),
      decoration: InputDecoration(
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(label, key: ValueKey(label)),
        ),
        hintText: hintText,
        prefixIcon: prefix ?? (prefixIcon != null
            ? Icon(prefixIcon, color: colors.textMuted)
            : null),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
