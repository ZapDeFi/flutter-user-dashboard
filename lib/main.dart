import 'dart:async';
import 'package:zapdefiapp/common/injector_config.dart';
import 'package:zapdefiapp/common/util/env/env.dart';
import 'package:zapdefiapp/common/util/env/env_main.dart';
import 'package:zapdefiapp/main_setup.dart' as setup;
import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = InjectorConfig.setup();
  container.registerSingleton<Env>((c) => EnvMain());

  await setup.config();
  runApp(const App());
}
