import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/splash/splash_provider.dart';

class LoginScreen extends StatelessWidget implements AutoRouteWrapper {
  final bool skipVideo;

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider<SplashProvider>(
      create: (_) => Injector.resolve(),
      child: this,
    );
  }

  const LoginScreen({
    super.key,
    this.skipVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("JUST A TEXT"),
    );
  }
}
