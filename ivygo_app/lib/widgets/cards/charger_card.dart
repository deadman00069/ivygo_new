import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// A card displaying charger information in a list.
class ChargerCard extends StatelessWidget {
  final Map<String, dynamic> charger;
  final VoidCallback onTap;

  const ChargerCard({
    super.key,
    required this.charger,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isAvailable = (charger['available'] as int) > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStationIcon(colors, isAvailable),
                const SizedBox(width: 12),
                _buildStationInfo(colors),
                _buildAvailabilityInfo(colors, isAvailable),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: colors.divider, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.bolt_rounded,
                  label: charger['kw'] as String,
                  color: colors.warning,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.electrical_services_rounded,
                  label: charger['type'] as String,
                  color: colors.accent,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.attach_money_rounded,
                  label: charger['price'] as String,
                  color: colors.success,
                ),
                const Spacer(),
                _buildRating(colors),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationIcon(ThemeColors colors, bool isAvailable) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isAvailable
            ? colors.primary.withValues(alpha: 0.12)
            : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.ev_station_rounded,
        color: isAvailable ? colors.primary : colors.textMuted,
        size: 22,
      ),
    );
  }

  Widget _buildStationInfo(ThemeColors colors) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            charger['name'] as String,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            charger['address'] as String,
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityInfo(ThemeColors colors, bool isAvailable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isAvailable
                ? colors.success.withValues(alpha: 0.15)
                : colors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isAvailable
                ? '${charger['available']}/${charger['total']} free'
                : 'Full',
            style: TextStyle(
              fontSize: 11,
              color: isAvailable ? colors.success : colors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          charger['distance'] as String,
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRating(ThemeColors colors) {
    return Row(
      children: [
        Icon(Icons.star_rounded, color: colors.warning, size: 14),
        const SizedBox(width: 3),
        Text(
          '${charger['rating']}',
          style: TextStyle(
            fontSize: 12,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
