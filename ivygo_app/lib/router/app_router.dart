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
import 'package:ivygo_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:ivygo_app/router/app_routes_name.dart';

/// Routes that require the user to be authenticated.
final _protectedRoutes = [
  // AppRoutes.mapHome.path
  ];

/// Creates a [GoRouter] that integrates with Riverpod auth state.
GoRouter createAppRouter(ProviderContainer container) {
  final authNotifier = _AuthChangeNotifier(container);

  return GoRouter(
    initialLocation: AppRoutes.splash.path,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      // Auth redirect logic
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

      return null; // no redirect
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn.path,
        name: AppRoutes.signIn.name,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.createAccount.path,
        name: AppRoutes.createAccount.name,
        builder: (BuildContext context, GoRouterState state) =>
            const CreateAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword.path,
        name: AppRoutes.forgotPassword.name,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.mapHome.path,
        name: AppRoutes.mapHome.name,
        builder: (BuildContext context, GoRouterState state) =>
            const MapHomeScreen(),
        routes: [
          GoRoute(
            path: AppRoutes.chargersList.path,
            name: AppRoutes.chargersList.name,
            builder: (BuildContext context, GoRouterState state) =>
                const ChargersListScreen(),
          ),
          GoRoute(
            path: AppRoutes.chargersEmpty.path,
            name: AppRoutes.chargersEmpty.name,
            builder: (BuildContext context, GoRouterState state) =>
                const ChargersEmptyScreen(),
          ),
          GoRoute(
            path: AppRoutes.stationDetail.path,
            name: AppRoutes.stationDetail.name,
            builder: (BuildContext context, GoRouterState state) {
              final stationId = state.pathParameters['id'] ?? '';
              return StationDetailScreen(stationId: stationId);
            },
          ),
          GoRoute(
            path: AppRoutes.booking.path,
            name: AppRoutes.booking.name,
            builder: (BuildContext context, GoRouterState state) =>
                const BookingScreen(),
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
