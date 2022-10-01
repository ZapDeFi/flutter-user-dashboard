import 'package:zapdefiapp/presentation/router/router.dart';

class LoginRouter extends MainAppRouter {
  void routeHome() {
    router.replaceAll([const MainRoute()]);
  }
}
