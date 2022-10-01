// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector_config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureSplashScreen() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton(
          (c) => AppRouter(keyManager: c<SecureStorageManager>()))
      ..registerSingleton((c) => SecureStorageManager())
      ..registerSingleton((c) => RootBackButtonDispatcher())
      ..registerSingleton((c) =>
          DioClient(keyManager: c<SecureStorageManager>(), env: c<Env>()))
      ..registerFactory((c) => SplashRouter())
      ..registerFactory((c) => SplashProvider(router: c<SplashRouter>()));
  }

  @override
  void _configureLogin() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => LoginRouter())
      ..registerFactory<LoginRepository>(
          (c) => LoginApi(dioClient: c<DioClient>()))
      ..registerFactory(
          (c) => LoginUsecase(loginRepository: c<LoginRepository>()))
      ..registerFactory((c) => LoginProvider(
          router: c<LoginRouter>(), loginUsecase: c<LoginUsecase>()));
  }
}
