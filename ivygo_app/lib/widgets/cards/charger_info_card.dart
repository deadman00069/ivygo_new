import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';
import 'stat_card.dart';

/// A prominent card for displaying detailed station information.
class ChargerInfoCard extends StatelessWidget {
  final String stationName;
  final String stationAddress;
  final String chargingType;
  final String powerLevel;
  final String pricing;
  final bool isAvailable;

  const ChargerInfoCard({
    super.key,
    required this.stationName,
    required this.stationAddress,
    required this.chargingType,
    required this.powerLevel,
    required this.pricing,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, colors),
          const SizedBox(height: 8),
          _buildTitle(theme, colors),
          const SizedBox(height: 8),
          _buildLocation(theme, colors),
          const SizedBox(height: 20),
          Divider(color: colors.border),
          const SizedBox(height: 20),
          _buildStatRow(context),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ThemeColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          stationName.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            letterSpacing: 0.5,
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isAvailable ? colors.primary : colors.error)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isAvailable ? 'AVAILABLE' : 'UNAVAILABLE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isAvailable ? colors.primary : colors.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme, ThemeColors colors) {
    return Text(
      '$chargingType · $powerLevel',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    );
  }

  Widget _buildLocation(ThemeData theme, ThemeColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(Icons.location_on_outlined, size: 16, color: colors.primary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            stationAddress,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatCard(label: '/kWh', value: pricing),
        StatCard(icon: Icons.bolt_rounded, label: '', value: powerLevel),
        const StatCard(
            icon: Icons.energy_savings_leaf_rounded, label: '', value: 'GREEN'),
        StatCard(
            icon: Icons.ev_station_rounded,
            label: '',
            value: chargingType.toUpperCase()),
      ],
    );
  }
}
