import 'dart:async';

import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/presentation/router/router.dart';

Future<void> config() async {
  await Injector.resolve<AppRouter>().setupInitialRoute();
}
