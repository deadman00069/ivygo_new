import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/providers/auth_provider.dart';
import 'package:ivygo_app/screens/sign_in_screen.dart';
import 'package:ivygo_app/screens/create_account_screen.dart';
import 'package:ivygo_app/screens/map_home_screen.dart';
import 'package:ivygo_app/screens/chargers_list_screen.dart';
import 'package:ivygo_app/screens/chargers_empty_screen.dart';
import 'package:ivygo_app/screens/station_detail_screen.dart';

/// Routes that require the user to be authenticated.
const _protectedRoutes = ['/home'];

/// Creates a [GoRouter] that integrates with Riverpod auth state.
GoRouter createAppRouter(ProviderContainer container) {
  final authNotifier = _AuthChangeNotifier(container);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = container.read(authProvider);
      final isAuthenticated = authState is AuthAuthenticated;
      final location = state.matchedLocation;

      final goingToProtected =
          _protectedRoutes.any((r) => location.startsWith(r));

      // Not authenticated and trying to access a protected route → sign in.
      if (!isAuthenticated && goingToProtected) return '/';

      // Authenticated and on the sign-in or register page → home.
      if (isAuthenticated && (location == '/' || location == '/register')) {
        return '/home';
      }

      return null; // no redirect
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'signIn',
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'createAccount',
        builder: (BuildContext context, GoRouterState state) =>
            const CreateAccountScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'mapHome',
        builder: (BuildContext context, GoRouterState state) =>
            const MapHomeScreen(),
        routes: [
          GoRoute(
            path: 'chargers',
            name: 'chargersList',
            builder: (BuildContext context, GoRouterState state) =>
                const ChargersListScreen(),
          ),
          GoRoute(
            path: 'chargers/empty',
            name: 'chargersEmpty',
            builder: (BuildContext context, GoRouterState state) =>
                const ChargersEmptyScreen(),
          ),
          GoRoute(
            path: 'station/:id',
            name: 'stationDetail',
            builder: (BuildContext context, GoRouterState state) {
              final stationId = state.pathParameters['id'] ?? '';
              return StationDetailScreen(stationId: stationId);
            },
          ),
        ],
      ),
    ],
  );
}

/// A [ChangeNotifier] that notifies GoRouter whenever [authProvider] changes.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(ProviderContainer container) {
    _subscription = container.listen<AuthState>(authProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
