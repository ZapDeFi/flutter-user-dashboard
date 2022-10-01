import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:zapdefiapp/common/client/http_client.dart';
import 'package:zapdefiapp/common/util/env/env.dart';
import 'package:zapdefiapp/common/util/secure_storage_manager.dart';
import 'package:zapdefiapp/data/login/api/login_api.dart';
import 'package:zapdefiapp/domain/login/usecase/login_usecase.dart';
import 'package:zapdefiapp/presentation/login/login_provider.dart';
import 'package:zapdefiapp/presentation/login/login_router.dart';
import 'package:zapdefiapp/presentation/main/main_provider.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';
import 'package:zapdefiapp/presentation/router/router.dart';

import '../domain/login/repositories/login_repository.dart';

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
    _configureLogin();
    _configureMain();
  }

  // ============ COMMON ========================
  @Register.singleton(AppRouter)
  @Register.singleton(SecureStorageManager)
  @Register.singleton(RootBackButtonDispatcher)
  @Register.singleton(DioClient)
  void _configureCommon();

  // ============ Login =========================
  @Register.factory(LoginRouter)
  @Register.factory(LoginRepository, from: LoginApi)
  @Register.factory(LoginUsecase)
  @Register.factory(LoginProvider)
  void _configureLogin();

  // ============ Main =========================
  @Register.factory(MainRouter)
  @Register.factory(MainProvider)
  void _configureMain();
}
