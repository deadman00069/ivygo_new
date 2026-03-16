import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivygo_app/screens/sign_in_screen.dart';
import 'package:ivygo_app/screens/create_account_screen.dart';
import 'package:ivygo_app/screens/map_home_screen.dart';
import 'package:ivygo_app/screens/chargers_list_screen.dart';
import 'package:ivygo_app/screens/chargers_empty_screen.dart';
import 'package:ivygo_app/screens/station_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
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
