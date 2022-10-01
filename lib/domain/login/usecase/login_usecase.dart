import 'package:dio/dio.dart';
import 'package:zapdefiapp/data/login/models/login_request_model.dart';
import 'package:zapdefiapp/data/login/models/login_response_model.dart';
import 'package:zapdefiapp/domain/login/repositories/login_repository.dart';

class LoginUsecase {
  final LoginRepository loginRepository;

  const LoginUsecase({required this.loginRepository});

  Future<LoginResponseModel> login({
    required final String username,
    required final String password,
    required final CancelToken cancelToken,
  }) async {
    final request = LoginRequestModel(
      username: username,
      password: password,
    );
    return loginRepository.login(
      requestModel: request,
      cancelToken: cancelToken,
    );
  }
}
