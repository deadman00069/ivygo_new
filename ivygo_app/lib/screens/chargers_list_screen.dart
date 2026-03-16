import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

class ChargersListScreen extends StatefulWidget {
  const ChargersListScreen({super.key});

  @override
  State<ChargersListScreen> createState() => _ChargersListScreenState();
}

class _ChargersListScreenState extends State<ChargersListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Fast', 'Available', 'Nearby'];

  static const List<Map<String, dynamic>> _chargers = [
    {
      'id': 'ev-001',
      'name': 'City Center Hub',
      'address': '12 Main Street, Downtown',
      'distance': '0.3 km',
      'available': 3,
      'total': 8,
      'kw': '50 kW',
      'type': 'DC Fast',
      'price': '\$0.28/kWh',
      'rating': 4.8,
    },
    {
      'id': 'ev-002',
      'name': 'Greenfield Mall Station',
      'address': 'Level B2, Greenfield Mall',
      'distance': '0.7 km',
      'available': 1,
      'total': 4,
      'kw': '22 kW',
      'type': 'AC Level 2',
      'price': '\$0.18/kWh',
      'rating': 4.5,
    },
    {
      'id': 'ev-003',
      'name': 'Business Bay Charging',
      'address': '55 Financial District',
      'distance': '1.2 km',
      'available': 5,
      'total': 6,
      'kw': '150 kW',
      'type': 'Ultra Fast',
      'price': '\$0.35/kWh',
      'rating': 4.9,
    },
    {
      'id': 'ev-004',
      'name': 'Park & Charge East',
      'address': 'Riverside Park, Gate 3',
      'distance': '1.8 km',
      'available': 0,
      'total': 2,
      'kw': '7 kW',
      'type': 'AC Level 1',
      'price': '\$0.12/kWh',
      'rating': 4.1,
    },
    {
      'id': 'ev-005',
      'name': 'Airport Terminal A',
      'address': 'International Airport T1',
      'distance': '3.4 km',
      'available': 8,
      'total': 12,
      'kw': '100 kW',
      'type': 'DC Fast',
      'price': '\$0.30/kWh',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, size: 22),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final isSelected = _selectedFilter == _filters[i];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedFilter = _filters[i]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : AppColors.border,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.black : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Summary row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_chargers.length} stations found',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.sort_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('Distance',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Charger list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _chargers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _ChargerCard(charger: _chargers[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargerCard extends StatelessWidget {
  final Map<String, dynamic> charger;
  const _ChargerCard({required this.charger});

  @override
  Widget build(BuildContext context) {
    final isAvailable = (charger['available'] as int) > 0;
    return GestureDetector(
      onTap: () => context.go('/home/station/${charger['id']}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.ev_station_rounded,
                    color: isAvailable ? AppColors.primary : AppColors.textMuted,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charger['name'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        charger['address'] as String,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? AppColors.success.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAvailable
                            ? '${charger['available']}/${charger['total']} free'
                            : 'Full',
                        style: TextStyle(
                          fontSize: 11,
                          color: isAvailable ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      charger['distance'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.bolt_rounded,
                  label: charger['kw'] as String,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.electrical_services_rounded,
                  label: charger['type'] as String,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.attach_money_rounded,
                  label: charger['price'] as String,
                  color: AppColors.success,
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.warning, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      '${charger['rating']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

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
