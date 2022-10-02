import 'package:dio/dio.dart';
import 'package:zapdefiapp/common/client/http_client.dart';
import 'package:zapdefiapp/data/login/models/token_list_model.dart';
import 'package:zapdefiapp/data/remote_datasource.dart';
import 'package:zapdefiapp/domain/login/repositories/login_repository.dart';

class LoginApi implements LoginRepository {
  final DioClient dioClient;

  LoginApi({required this.dioClient});

  @override
  Future<TokenListModel> login({
    required final CancelToken cancelToken,
  }) async {
    final data = await dioClient.get<String>(
      AppEndpoints.loginPath,
      cancelToken: cancelToken,
    );
    return TokenListModel.fromJson(data);
  }
}
