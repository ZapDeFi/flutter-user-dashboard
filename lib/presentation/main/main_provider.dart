import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zapdefiapp/presentation/main/main_router.dart';

class MainProvider extends ChangeNotifier {
  final MainRouter router;

  final scrollController = ScrollController();

  MainProvider({
    required this.router,
  });

}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, double i) f) {
    var i = 0.0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, double i) f) {
    var i = 0.0;
    forEach((e) => f(e, i++));
  }
}
