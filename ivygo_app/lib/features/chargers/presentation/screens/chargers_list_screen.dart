import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';
import 'package:ivygo_app/widgets/widgets.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

final selectedFilterProvider =
    StateProvider.autoDispose<String>((ref) => 'All');

class ChargersListScreen extends ConsumerWidget {
  const ChargersListScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargers'),
        leading: AppBackButton(onPressed: () => context.go(AppRoutes.mapHome.path)),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, size: 22),
            onPressed: () => context.go(AppRoutes.mapHome.path),
          ),
        ],
      ),
      body: Column(
        children: [
          FilterChips(
            filters: const ['All', 'Fast', 'Available', 'Nearby'],
            selectedFilter: ref.watch(selectedFilterProvider),
            onSelected: (val) =>
                ref.read(selectedFilterProvider.notifier).state = val,
          ),
          _SummaryRow(theme: theme, totalFound: _chargers.length),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _chargers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => ChargerCard(
                charger: _chargers[i],
                onTap: () =>
                    context.go(AppRoutes.stationDetail.getFullPath(_chargers[i]['id'] as String)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.theme, required this.totalFound});
  final ThemeData theme;
  final int totalFound;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '$totalFound stations found',
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
          const Spacer(),
          Icon(Icons.sort_rounded, size: 16, color: context.appColors.textMuted),
          const SizedBox(width: 4),
          Text('Distance',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: context.appColors.textMuted)),
        ],
      ),
    );
  }
}

