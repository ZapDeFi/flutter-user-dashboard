part of 'router.dart';

abstract class MainAppRouter {
  late final BuildContext context;

  StackRouter get router => context.router;
}
