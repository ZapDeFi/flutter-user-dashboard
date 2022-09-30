import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:zapdefiapp/common/util/secure_storage_manager.dart';
import 'package:zapdefiapp/presentation/router/router.dart';
import 'package:zapdefiapp/presentation/splash/splash_provider.dart';
import 'package:zapdefiapp/presentation/splash/splash_router.dart';

part 'injector_config.g.dart';

abstract class InjectorConfig {
  static late KiwiContainer container;

  static KiwiContainer setup() {
    container = KiwiContainer();
    _$InjectorConfig()._configure();
    return container;
  }

  static final resolve = container.resolve;

  void _configure() {
    _configureSplashScreen();
  }

  // ============ COMMON ========================
  @Register.singleton(AppRouter)
  @Register.singleton(SecureStorageManager)
  @Register.singleton(RootBackButtonDispatcher)

  // ============ Splash Screen =================
  @Register.factory(SplashRouter)
  @Register.factory(SplashProvider)
  void _configureSplashScreen();
}
