import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zapdefiapp/common/client/auth_remote_datasource.dart';
import 'package:zapdefiapp/common/client/constants/exception_constants.dart';
import 'package:zapdefiapp/common/client/constants/http_constants.dart';
import 'package:zapdefiapp/common/client/exceptions/cancel_exception.dart';
import 'package:zapdefiapp/common/client/exceptions/connection_exception.dart';
import 'package:zapdefiapp/common/client/exceptions/server_exception.dart';
import 'package:zapdefiapp/common/client/refresh_token_model.dart';
import 'package:zapdefiapp/common/injectore.dart';
import 'package:zapdefiapp/common/util/env/env.dart';
import 'package:zapdefiapp/common/util/secure_storage_manager.dart';
import 'package:zapdefiapp/presentation/router/router.dart';

enum HeaderTokenType { access }

dynamic _parseAndDecode(String response) {
  return jsonDecode(response);
}

Future _parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class DioClient {
  final SecureStorageManager keyManager;

  late final Dio dio;
  final String host;

  DioClient({
    required this.keyManager,
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

  Future<CancelException> _logout({
    required final HeaderTokenType? headerTokenType,
  }) async {
    final AppRouter router = Injector.resolve();
    await router.logout(to: LogoutTo.splash);
    return CancelException();
  }

  Future<Map<String, String>> _generateAuthorizationHeader(
    final HeaderTokenType? headerTokenType,
  ) async {
    final String? access;
    switch (headerTokenType) {
      case HeaderTokenType.access:
        access = keyManager.accessKey;
        break;
      case null:
        access = null;
    }
    return {
      if (access != null) HttpConstants.access: access,
    };
  }

  Future<Map<String, String>> _generateRequestHeader(
    final HeaderTokenType? headerTokenType,
  ) async {
    return {
      ...await _generateAuthorizationHeader(headerTokenType),
    };
  }

  final _refreshCompleters = <HeaderTokenType, Completer<void>>{};
  Future<void> refreshAuthAccessKeys({
    final CancelToken? cancelToken,
  }) async {
    final completer = _refreshCompleters[HeaderTokenType.access];
    if (completer != null) return completer.future;
    final refreshCompleter = Completer<void>();
    _refreshCompleters[HeaderTokenType.access] = refreshCompleter;

    final String? refreshKey;
    switch (HeaderTokenType.access) {
      case HeaderTokenType.access:
        refreshKey = keyManager.accessRefreshKey;
        break;
    }
    if (refreshKey == null) {
      throw await _logout(headerTokenType: HeaderTokenType.access);
    }

    try {
      final response = await dio.post(
        AuthEndpoints.refreshTokenPath,
        data: refreshKey,
        cancelToken: cancelToken,
      );

      final body = response.data as Map;
      final code =
          response.statusCode ?? ExceptionConstants.internalServerError;
      if (code == ExceptionConstants.unauthorized) {
        throw await _logout(headerTokenType: HeaderTokenType.access);
      }
      if (code >= 300) {
        final message = body['message'] as String?;
        throw ServerException(
          code: code,
          message: message,
        );
      } else {
        final data = body['data'];

        final tokenResponse = RefreshTokenModel.fromJson(data);

        final token = tokenResponse.token;
        final refreshToken = tokenResponse.refreshToken;

        if (token == null || refreshToken == null) {
          throw InternalServerException(message: null);
        } else {
          switch (HeaderTokenType.access) {
            case HeaderTokenType.access:
              keyManager.setAccessKeys(
                accessKey: token,
                refreshAccessKey: refreshToken,
              );
              break;
          }
        }
      }
      _refreshCompleters.remove(HeaderTokenType.access);
      refreshCompleter.complete();
    } catch (error, stackTrace) {
      _refreshCompleters.remove(HeaderTokenType.access);
      refreshCompleter.completeError(error, stackTrace);
    }
    return refreshCompleter.future;
  }

  Future<T> get<T>(
    final String path, {
    final CancelToken? cancelToken,
    final Map<String, dynamic>? queryParameters,
    final Duration? timeout,
  }) async {
    try {
      // first request try
      {
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.get(
          path,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          // refresh keys
          await refreshAuthAccessKeys(
            cancelToken: cancelToken,
          );
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
        }
      }

      // second request try after refresh keys
      {
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );
        final response = await dio.get(
          path,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          throw await _logout(
            headerTokenType: HeaderTokenType.access,
          );
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
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
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.post(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          // refresh keys
          await refreshAuthAccessKeys(
            cancelToken: cancelToken,
          );
        } else if (code >= 300) {
          final message = body['message'] as String?;

          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
        }
      }

      // second request try after refresh keys
      {
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.post(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          throw await _logout(headerTokenType: HeaderTokenType.access);
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
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
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.patch(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          // refresh keys
          await refreshAuthAccessKeys(
            cancelToken: cancelToken,
          );
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
        }
      }

      // second request try after refresh keys
      {
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.patch(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          throw await _logout(headerTokenType: HeaderTokenType.access);
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
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
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.delete(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          // refresh keys
          await refreshAuthAccessKeys(
            cancelToken: cancelToken,
          );
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
        }
      }

      // second request try after refresh keys
      {
        final requestHeader = await _generateRequestHeader(
          HeaderTokenType.access,
        );

        final response = await dio.delete(
          path,
          data: json,
          cancelToken: cancelToken,
          queryParameters: queryParameters,
          options: Options(
            headers: requestHeader,
            sendTimeout: timeout?.inMilliseconds,
          ),
        );

        final body = response.data as Map;
        final code =
            response.statusCode ?? ExceptionConstants.internalServerError;
        if (code == ExceptionConstants.unauthorized) {
          throw await _logout(headerTokenType: HeaderTokenType.access);
        } else if (code >= 300) {
          final message = body['message'] as String?;
          throw ServerException(
            code: code,
            message: message,
          );
        } else {
          return body['data'];
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
