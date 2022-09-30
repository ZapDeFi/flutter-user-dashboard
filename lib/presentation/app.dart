import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/router/router.dart';
import 'package:zapdefiapp/presentation/themes/theme_data.dart';

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return const _MainApp();
  }
}

class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) {
    final router = Injector.resolve<AppRouter>();

    return MaterialApp.router(
      title: 'ZapDeFi',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme().darkTheme,
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate:
          router.delegate(navigatorObservers: () => [AutoRouteObserver()]),
      backButtonDispatcher: Injector.resolve<RootBackButtonDispatcher>(),
    );
  }
}
