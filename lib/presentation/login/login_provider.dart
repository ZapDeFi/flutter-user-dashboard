import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zapdefiapp/common/client/exceptions/cancel_exception.dart';
import 'package:zapdefiapp/domain/login/usecase/login_usecase.dart';
import 'package:zapdefiapp/presentation/components/password_field/password_field_component.dart';
import 'package:zapdefiapp/presentation/login/login_router.dart';

class LoginProvider extends ChangeNotifier {
  final LoginRouter router;
  final LoginUsecase loginUsecase;

  late final PasswordFieldController _controller;
  bool _isLoading = false;
  String password = '';
  String email = '';

  bool get isLoading => _isLoading;
  bool get isNextEnable => _controller.isPasswordValid;

  PasswordFieldController get controller => _controller;

  final _cancelToken = CancelToken();

  LoginProvider({
    required this.router,
    required this.loginUsecase,
  }) {
    _controller = PasswordFieldController(
      email: email,
      password: password,
    );
    _initPasswordListener();
    _isLoading = false;
    notifyListeners();
  }

  void _initPasswordListener() {
    _controller.addListener(notifyListeners);
  }

  Future<void> onNextTapped() async {
    _isLoading = false;
    notifyListeners();
    try {
      final response = await loginUsecase.login(
        username: 'username',
        password: 'password',
        cancelToken: _cancelToken,
      );
      // add tokens to secure storage
      router.routeHome();
    } on CancelException {
      return;
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _controller.dispose();
    super.dispose();
  }
}
