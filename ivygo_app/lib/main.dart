import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/features/auth/providers/auth_provider.dart';
import 'package:ivygo_app/router/app_router.dart';
import 'package:ivygo_app/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IvygoApp(),
    ),
  );
}

class IvygoApp extends ConsumerStatefulWidget {
  const IvygoApp({super.key});

  @override
  ConsumerState<IvygoApp> createState() => _IvygoAppState();
}

class _IvygoAppState extends ConsumerState<IvygoApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize router once, using the ProviderContainer from ProviderScope.
    _router ??= createAppRouter(ProviderScope.containerOf(context));
  }

  @override
  void initState() {
    super.initState();
    // Restore persisted session on app start.
    Future.microtask(() => ref.read(authProvider.notifier).checkAuth());
  }

  @override
  Widget build(BuildContext context) {
    final router = _router;
    if (router == null) return const SizedBox.shrink();
    return MaterialApp.router(
      title: 'Ivygo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
