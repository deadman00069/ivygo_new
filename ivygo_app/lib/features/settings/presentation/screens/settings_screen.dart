import 'package:flutter/material.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

/// Placeholder screen for the Settings tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'App preferences and account settings.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.appColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 64,
                      color: context.appColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Coming soon',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
