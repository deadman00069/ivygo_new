import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A small vertical stat or info display with an icon/label and value.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final displayColor = color ?? colors.primary;

    return Column(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: displayColor),
          const SizedBox(height: 4),
        ] else ...[
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.warning,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          icon != null ? value : label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
            fontWeight: icon != null ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }
}
