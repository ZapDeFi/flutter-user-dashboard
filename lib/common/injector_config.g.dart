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
      ..registerSingleton((c) => AppRouter())
      ..registerSingleton((c) => RootBackButtonDispatcher())
      ..registerSingleton((c) => DioClient(env: c<Env>()));
  }

  @override
  void _configureMain() {
    final KiwiContainer container = KiwiContainer();
    container
      ..registerFactory((c) => MainRouter())
      ..registerFactory((c) => MainProvider(router: c<MainRouter>()));
  }
}
