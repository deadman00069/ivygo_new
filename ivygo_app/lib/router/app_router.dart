import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ivygo_app/features/auth/providers/auth_provider.dart';
import 'package:ivygo_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:ivygo_app/features/auth/presentation/screens/create_account_screen.dart';
import 'package:ivygo_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ivygo_app/features/map/presentation/screens/map_home_screen.dart';
import 'package:ivygo_app/features/chargers/presentation/screens/chargers_list_screen.dart';
import 'package:ivygo_app/features/chargers/presentation/screens/chargers_empty_screen.dart';
import 'package:ivygo_app/features/chargers/presentation/screens/station_detail_screen.dart';
import 'package:ivygo_app/features/booking/presentation/screens/booking_screen.dart';
import 'package:ivygo_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:ivygo_app/features/navigation/presentation/screens/main_shell_screen.dart';
import 'package:ivygo_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

/// Global key for the root navigator (outside the shell).
/// Required to hide the bottom navigation bar for specific routes.
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Routes that require the user to be authenticated.
final _protectedRoutes = [
  // AppRoutes.mapHome.path
  ];

/// Creates a [GoRouter] that integrates with Riverpod auth state.
GoRouter createAppRouter(ProviderContainer container) {
  final authNotifier = _AuthChangeNotifier(container);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.mapHome.path,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = container.read(authProvider);
      final isAuthenticated = authState is AuthAuthenticated;
      final location = state.matchedLocation;
      final goingToProtected =
          _protectedRoutes.any((r) => location.startsWith(r));

      if (!isAuthenticated && goingToProtected) return AppRoutes.signIn.path;
      if (isAuthenticated &&
          (location == AppRoutes.signIn.path ||
              location == AppRoutes.createAccount.path ||
              location == AppRoutes.forgotPassword.path ||
              location == AppRoutes.splash.path)) {
        return AppRoutes.mapHome.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn.path,
        name: AppRoutes.signIn.name,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.createAccount.path,
        name: AppRoutes.createAccount.name,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword.path,
        name: AppRoutes.forgotPassword.name,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      /// The main shell route with persistent bottom navigation.
      /// All main-app tabs live inside this [StatefulShellRoute].
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          // ── Branch 0: Map ────────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.mapHome.path,
                name: AppRoutes.mapHome.name,
                builder: (context, state) => const MapHomeScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.stationDetail.path,
                    name: AppRoutes.stationDetail.name,
                    parentNavigatorKey: _rootNavigatorKey, // Hide bottom nav
                    builder: (context, state) {
                      final stationId = state.pathParameters['id'] ?? '';
                      return StationDetailScreen(stationId: stationId);
                    },
                    routes: [
                      GoRoute(
                        path: AppRoutes.booking.path,
                        name: AppRoutes.booking.name,
                        parentNavigatorKey:
                            _rootNavigatorKey, // Hide bottom nav
                        builder: (context, state) => const BookingScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // ── Branch 1: Chargers ────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chargersList.path,
                name: AppRoutes.chargersList.name,
                builder: (context, state) => const ChargersListScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.chargersEmpty.path,
                    name: AppRoutes.chargersEmpty.name,
                    parentNavigatorKey: _rootNavigatorKey, // Hide bottom nav
                    builder: (context, state) => const ChargersEmptyScreen(),
                  ),
                ],
              ),
            ],
          ),

          // ── Branch 2: My Bookings ─────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myBookings.path,
                name: AppRoutes.myBookings.name,
                builder: (context, state) => const BookingScreen(),
              ),
            ],
          ),

          // ── Branch 3: Settings ────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings.path,
                name: AppRoutes.settings.name,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
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
