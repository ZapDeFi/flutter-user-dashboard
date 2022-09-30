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
      ..registerFactory((c) => SplashRouter())
      ..registerFactory((c) => SplashProvider());
  }
}
