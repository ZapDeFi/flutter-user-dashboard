import 'package:dio/dio.dart';
import 'package:zapdefiapp/data/login/models/login_request_model.dart';
import 'package:zapdefiapp/data/login/models/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login({
    required LoginRequestModel requestModel,
    required final CancelToken cancelToken,
  });
}
