import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A reusable empty state view with icon, title, message, and actions.
class EmptyStateView extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final List<Widget>? actions;

  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) _buildIllustration(colors),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 40),
              ...actions!.map((action) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: action,
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(ThemeColors colors) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        shape: BoxShape.circle,
        border: Border.all(color: colors.border, width: 0.5),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 52,
              color: colors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
