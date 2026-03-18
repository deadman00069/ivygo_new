import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A small pill showing estimated cost.
class CostEstimationPill extends StatelessWidget {
  final double amount;

  const CostEstimationPill({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 16, color: colors.warning),
          const SizedBox(width: 6),
          Text(
            'Est. cost: \$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
