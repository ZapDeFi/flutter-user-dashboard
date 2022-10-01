import 'package:flutter/foundation.dart';
import 'package:zapdefiapp/common/client/constants/exception_constants.dart';

class ServerException implements Exception {
  final int code;
  final String message;

  factory ServerException({required int code, required String? message}) {
    switch (code) {
      case ExceptionConstants.unauthorized:
        return UnauthorizedServerException(message: message);
      case ExceptionConstants.notFound:
        return NotFoundServerException(message: message);
      case ExceptionConstants.internalServerError:
        return InternalServerException(message: message);
      default:
        return ServerException._(code, message ?? 'UnexpectedError');
    }
  }
  const ServerException._(
    this.code,
    this.message,
  );

  @visibleForTesting
  factory ServerException.mock() => ServerException(
        message: 'message',
        code: 303,
      );

  @override
  String toString() => '$code: $message';
}

class UnauthorizedServerException extends ServerException {
  UnauthorizedServerException({required String? message})
      : super._(
          ExceptionConstants.unauthorized,
          message ?? 'Unauthorized',
        );
}

class NotFoundServerException extends ServerException {
  NotFoundServerException({required String? message})
      : super._(
          ExceptionConstants.notFound,
          message ?? 'NotFound',
        );
}

class InternalServerException extends ServerException {
  InternalServerException({required String? message})
      : super._(
          ExceptionConstants.internalServerError,
          message ?? 'InternalError',
        );
}
