import 'package:dio/dio.dart';
import 'package:zapdefiapp/data/login/models/token_list_model.dart';

abstract class LoginRepository {
  Future<TokenListModel> login({
    required final CancelToken cancelToken,
  });
}
