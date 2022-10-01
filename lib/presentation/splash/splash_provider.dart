import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/splash/splash_router.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRouter router;

    SplashProvider({
    required this.router,
  });

    void onNext() {
    router.routeLogin();
  }
}
