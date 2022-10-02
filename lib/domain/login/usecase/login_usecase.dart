import 'package:dio/dio.dart';
import 'package:zapdefiapp/data/login/models/token_list_model.dart';
import 'package:zapdefiapp/domain/login/repositories/login_repository.dart';

class LoginUsecase {
  final LoginRepository loginRepository;

  const LoginUsecase({required this.loginRepository});

  Future<TokenListModel> login({
    required final CancelToken cancelToken,
  }) async {
    return loginRepository.login(
      cancelToken: cancelToken,
    );
  }
}
