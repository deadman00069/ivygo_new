import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ivygo_app/router/app_router.dart';
import 'package:ivygo_app/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IvygoApp(),
    ),
  );
}

class IvygoApp extends StatelessWidget {
  const IvygoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ivygo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
