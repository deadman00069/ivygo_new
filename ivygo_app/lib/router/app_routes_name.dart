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

final class MapHomeRoute extends AppRoute {
  const MapHomeRoute() : super('/home', 'mapHome');
}

final class ChargersListRoute extends AppRoute {
  const ChargersListRoute() : super('chargers', 'chargersList');

  String get fullPath => '/home/chargers';
}

final class ChargersEmptyRoute extends AppRoute {
  const ChargersEmptyRoute() : super('chargers/empty', 'chargersEmpty');

  String get fullPath => '/home/chargers/empty';
}

final class StationDetailRoute extends AppRoute {
  const StationDetailRoute() : super('station/:id', 'stationDetail');

  String getFullPath(String id) => '/home/station/$id';
}

final class BookingRoute extends AppRoute {
  const BookingRoute() : super('booking', 'booking');

  String get fullPath => '/home/booking';
}

abstract final class AppRoutes {
  static const splash = SplashRoute();
  static const signIn = SignInRoute();
  static const createAccount = CreateAccountRoute();
  static const forgotPassword = ForgotPasswordRoute();
  static const mapHome = MapHomeRoute();
  static const chargersList = ChargersListRoute();
  static const chargersEmpty = ChargersEmptyRoute();
  static const stationDetail = StationDetailRoute();
  static const booking = BookingRoute();
}
