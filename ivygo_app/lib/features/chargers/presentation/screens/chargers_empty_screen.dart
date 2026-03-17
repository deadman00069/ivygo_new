import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

class ChargersEmptyScreen extends StatelessWidget {
  const ChargersEmptyScreen({super.key});

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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _EmptyIllustration(),
              const SizedBox(height: 32),
              Text(
                'No Chargers Found',
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We couldn\'t find any charging stations in this area. Try expanding your search radius or exploring a different location.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.my_location_rounded, size: 18),
                label: const Text('Search Nearby'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.go('/home/chargers'),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('Adjust Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: context.appColors.surfaceElevated,
        shape: BoxShape.circle,
        border: Border.all(color: context.appColors.border, width: 0.5),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.ev_station_rounded,
              size: 52,
              color: context.appColors.textMuted,
            ),
            Positioned(
              bottom: 26,
              right: 22,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: context.appColors.surfaceElevated,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: context.appColors.error.withValues(alpha: 0.6)),
                ),
                child: Icon(Icons.close_rounded,
                    size: 14, color: context.appColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
