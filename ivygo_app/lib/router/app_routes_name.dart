sealed class AppRoute {
  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

final class SplashRoute extends AppRoute {
  const SplashRoute() : super('/', 'splash');
}

final class SignInRoute extends AppRoute {
  const SignInRoute() : super('/login', 'signIn');
}

final class CreateAccountRoute extends AppRoute {
  const CreateAccountRoute() : super('/register', 'createAccount');
}

final class ForgotPasswordRoute extends AppRoute {
  const ForgotPasswordRoute() : super('/forgot-password', 'forgotPassword');
}

/// Branch 0 — Map tab root.
final class MapHomeRoute extends AppRoute {
  const MapHomeRoute() : super('/home', 'mapHome');
}

/// Nested under the Map branch.
final class StationDetailRoute extends AppRoute {
  const StationDetailRoute() : super('station/:id', 'stationDetail');

  String getFullPath(String id) => '/home/station/$id';
}

/// Nested under StationDetail in the Map branch.
final class BookingRoute extends AppRoute {
  const BookingRoute() : super('booking', 'booking');

  String get fullPath => '/home/booking';
}

/// Branch 1 — Chargers tab root.
final class ChargersListRoute extends AppRoute {
  const ChargersListRoute() : super('/chargers', 'chargersList');

  String get fullPath => '/chargers';
}

/// Nested under the Chargers branch.
final class ChargersEmptyRoute extends AppRoute {
  const ChargersEmptyRoute() : super('empty', 'chargersEmpty');

  String get fullPath => '/chargers/empty';
}

/// Branch 2 — My Bookings tab root.
final class MyBookingsRoute extends AppRoute {
  const MyBookingsRoute() : super('/bookings', 'myBookings');
}

/// Branch 3 — Settings tab root.
final class SettingsRoute extends AppRoute {
  const SettingsRoute() : super('/settings', 'settings');
}

abstract final class AppRoutes {
  static const splash = SplashRoute();
  static const signIn = SignInRoute();
  static const createAccount = CreateAccountRoute();
  static const forgotPassword = ForgotPasswordRoute();
  static const mapHome = MapHomeRoute();
  static const stationDetail = StationDetailRoute();
  static const booking = BookingRoute();
  static const chargersList = ChargersListRoute();
  static const chargersEmpty = ChargersEmptyRoute();
  static const myBookings = MyBookingsRoute();
  static const settings = SettingsRoute();
}
