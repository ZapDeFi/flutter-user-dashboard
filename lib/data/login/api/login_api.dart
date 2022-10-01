
import 'package:dio/dio.dart';
import 'package:zapdefiapp/common/client/http_client.dart';
import 'package:zapdefiapp/data/login/models/login_request_model.dart';
import 'package:zapdefiapp/data/login/models/login_response_model.dart';
import 'package:zapdefiapp/data/remote_datasource.dart';
import 'package:zapdefiapp/domain/login/repositories/login_repository.dart';

class LoginApi implements LoginRepository {
  final DioClient dioClient;

  LoginApi({required this.dioClient});

  @override
  Future<LoginResponseModel> login({
    required LoginRequestModel requestModel,
    required final CancelToken cancelToken,
  }) async {
    final data = await dioClient.post<String>(
      AppEndpoints.loginPath,
      requestModel.toJson(),
      cancelToken: cancelToken,
    );
    return LoginResponseModel.fromJson(data);
  }

}
