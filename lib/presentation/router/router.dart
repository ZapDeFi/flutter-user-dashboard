import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:zapdefiapp/common/injectore.dart';
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
    AutoRoute(page: MainScreen),
  ],
)
class AppRouter extends _$AppRouter {

  // ignore: use_super_parameters
  AppRouter() : super();

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
    return router.replaceAll([const MainRoute()]);
  }
}
