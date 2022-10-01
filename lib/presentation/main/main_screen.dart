import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/main/main_provider.dart';

class MainScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (_) => Injector.resolve(),
      child: this,
    );
  }

  const MainScreen({
    super.key,
  }); 

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MainProvider>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Text('askjdhgkas')
          ),
        ],
      ),
    );
  }
}
