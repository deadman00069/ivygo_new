import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:ivygo_app/theme/app_theme.dart'; // removed unused
import 'package:ivygo_app/widgets/widgets.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

class ChargersEmptyScreen extends StatelessWidget {
  const ChargersEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargers'),
        leading: AppBackButton(onPressed: () => context.go(AppRoutes.mapHome.path)),
      ),
      body: EmptyStateView(
        title: 'No Chargers Found',
        message:
            'We couldn\'t find any charging stations in this area. Try expanding your search radius or exploring a different location.',
        icon: Icons.ev_station_rounded,
        actions: [
          PrimaryButton(
            label: 'Search Nearby',
            icon: Icons.my_location_rounded,
            onPressed: () => context.go(AppRoutes.mapHome.path),
          ),
          PrimaryButton(
            label: 'Adjust Filters',
            icon: Icons.tune_rounded,
            isSecondary: true,
            onPressed: () => context.go(AppRoutes.chargersList.fullPath),
          ),
        ],
      ),
    );
  }
}

