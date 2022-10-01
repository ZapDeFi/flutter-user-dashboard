import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:zapdefiapp/common/client/http_client.dart';
import 'package:zapdefiapp/common/util/env/env.dart';

import 'package:zapdefiapp/presentation/main/main_provider.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';
import 'package:zapdefiapp/presentation/router/router.dart';

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
    _configureCommon();
    _configureMain();
  }

  // ============ COMMON ========================
  @Register.singleton(AppRouter)
  @Register.singleton(RootBackButtonDispatcher)
  @Register.singleton(DioClient)
  void _configureCommon();

  // ============ Main =========================
  @Register.factory(MainRouter)
  @Register.factory(MainProvider)
  void _configureMain();
}
