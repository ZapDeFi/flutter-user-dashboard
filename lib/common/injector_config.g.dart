// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injector_config.dart';

// **************************************************************************
// KiwiInjectorGenerator
// **************************************************************************

class _$InjectorConfig extends InjectorConfig {
  @override
  void _configureCommon() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerSingleton(
          (c) => AppRouter(keyManager: c<SecureStorageManager>()))
      ..registerSingleton((c) => SecureStorageManager())
      ..registerSingleton((c) => RootBackButtonDispatcher())
      ..registerSingleton((c) =>
          DioClient(keyManager: c<SecureStorageManager>(), env: c<Env>()));
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

  @override
  void _configureMain() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => MainRouter())
      ..registerFactory((c) => MainProvider(router: c<MainRouter>()));
  }
}
