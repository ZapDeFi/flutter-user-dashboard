import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/main/main_provider.dart';
import 'package:zapdefiapp/presentation/router/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (_) => Injector.resolve(),
      child: const _MainApp(),
    );
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
      darkTheme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.defaultRouteParser(),
      routerDelegate:
          router.delegate(navigatorObservers: () => [AutoRouteObserver()]),
      backButtonDispatcher: Injector.resolve<RootBackButtonDispatcher>(),
    );
  }
}
