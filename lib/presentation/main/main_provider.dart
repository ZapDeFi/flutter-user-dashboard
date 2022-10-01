import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';

class MainProvider extends ChangeNotifier {
  final MainRouter router;

  MainProvider({
    required this.router,
  });
}
