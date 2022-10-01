import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zapdefiapp/common/client/constants/exception_constants.dart';
import 'package:zapdefiapp/common/client/constants/http_constants.dart';
import 'package:zapdefiapp/common/client/exceptions/cancel_exception.dart';
import 'package:zapdefiapp/common/client/exceptions/connection_exception.dart';
import 'package:zapdefiapp/common/client/exceptions/server_exception.dart';
import 'package:zapdefiapp/common/util/env/env.dart';

dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future _parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class DioClient {
  late final Dio dio;
  final String host;

  DioClient({
    required final Env env,
  }) : host = env.host {
    dio = Dio(
      BaseOptions(
        baseUrl: host,
        validateStatus: (_) => true,
        contentType: HttpConstants.jsonContentType,
      ),
    );
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
      ),
    );
  }

  Future<T> get<T>(
    final String path, {
    final CancelToken? cancelToken,
    final Map<String, dynamic>? queryParameters,
    final Duration? timeout,
  }) async {
    try {
      {
        final response = await dio.get(
          path,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == 200) {
          return body['data'];
        } else {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        }
      }
    } on CancelException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelException();
      } else {
        throw ConnectionException();
      }
    } catch (_) {
      throw ConnectionException();
    }
  }

  Future<T> post<T>(
    final String path,
    final String json, {
    final bool decrypt = true,
    final CancelToken? cancelToken,
    final Map<String, dynamic>? queryParameters,
    final Duration? timeout,
  }) async {
    try {
      {
        final response = await dio.post(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == 200) {
          return body['data'];
        } else {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        }
      }
    } on CancelException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelException();
      } else {
        throw ConnectionException();
      }
    } catch (_) {
      throw ConnectionException();
    }
  }

  Future<T> patch<T>(
    final String path,
    final String json, {
    final bool decrypt = true,
    final CancelToken? cancelToken,
    final Map<String, dynamic>? queryParameters,
    final Duration? timeout,
  }) async {
    try {
      {
        final response = await dio.patch(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == 200) {
          return body['data'];
        } else {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        }
      }
    } on CancelException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelException();
      } else {
        throw ConnectionException();
      }
    } catch (_) {
      throw ConnectionException();
    }
  }

  Future<T> delete<T>(
    final String path,
    final String json, {
    final bool decrypt = true,
    final CancelToken? cancelToken,
    final Map<String, dynamic>? queryParameters,
    final Duration? timeout,
  }) async {
    try {
      {
        final response = await dio.delete(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == 200) {
          return body['data'];
        } else {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        }
      }
    } on CancelException {
      rethrow;
    } on ServerException {
      rethrow;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CancelException();
      } else {
        throw ConnectionException();
      }
    } catch (_) {
      throw ConnectionException();
    }
  }
}
