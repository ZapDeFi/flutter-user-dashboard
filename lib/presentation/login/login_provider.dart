import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zapdefiapp/common/client/exceptions/cancel_exception.dart';
import 'package:zapdefiapp/domain/login/usecase/login_usecase.dart';
import 'package:zapdefiapp/presentation/login/login_router.dart';

class LoginProvider extends ChangeNotifier {
  final LoginRouter router;
  final LoginUsecase loginUsecase;

  final _cancelToken = CancelToken();

  LoginProvider({
    required this.router,
    required this.loginUsecase,
  });

  Future<void> onNextTapped() async {
    try {

      final response = await loginUsecase.login(
        username: 'username',
        password: 'password',
        cancelToken: _cancelToken,
      );

    } on CancelException {
      return;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

}
