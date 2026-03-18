import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'APP_BASE_URL')
  static const String appBaseUrl = _Env.appBaseUrl;

  @EnviedField(varName: 'APP_BASE_API_URL')
  static const String appBaseApiUrl = _Env.appBaseApiUrl;
}
