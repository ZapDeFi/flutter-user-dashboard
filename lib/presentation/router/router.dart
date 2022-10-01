import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/common/util/secure_storage_manager.dart';
import 'package:zapdefiapp/presentation/login/login_screen.dart';
import 'package:zapdefiapp/presentation/main/main_screen.dart';

part 'main_app_router.dart';
part 'router.gr.dart';

enum LogoutTo { splash }

Route<T> customRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return MaterialWithModalsPageRoute(
    settings: page,
    builder: page.buildPage,
    maintainState: page.maintainState,
    fullscreenDialog: page.fullscreenDialog,
  );
}

@CustomAutoRouter(
  replaceInRouteName: 'Screen,Route',
  customRouteBuilder: customRouteBuilder,
  routes: <AutoRoute>[
    // authentication
    AutoRoute(page: LoginScreen),
    AutoRoute(page: MainScreen),
  ],
)
class AppRouter extends _$AppRouter {
  final SecureStorageManager keyManager;

  // ignore: use_super_parameters
  AppRouter({
    required this.keyManager,
  }) : super();

  @override
  Future<bool> pop<T extends Object?>([T? result]) {
    if (canPopSelfOrChildren) {
      return super.pop(result);
    } else {
      final topRouter = Injector.resolve<AppRouter>();
      if (this != topRouter) {
        return topRouter.pop(result);
      } else {
        return Future.value(false);
      }
    }
  }

  Future<void> setupInitialRoute() async {
    final router = this;

    final authToken = await keyManager.getSecureKey(KeyType.authKey);
    final authTokenRefresh =
        await keyManager.getSecureKey(KeyType.refreshAuthKey);

    if (authToken == null || authTokenRefresh == null) {
      return router.replaceAll([const LoginRoute()]);
    } else {
      return router.replaceAll([const MainRoute()]);
    }
  }

  Future<void> logout({required final LogoutTo to}) async {
    final router = this;
    final List<PageRouteInfo> routes;
    switch (to) {
      case LogoutTo.splash:
        await keyManager.logout();
        routes = [const LoginRoute()];
        break;
    }
    return router.replaceAll(routes);
  }
}
