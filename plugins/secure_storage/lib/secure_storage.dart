import 'dart:async';

import 'package:flutter/services.dart';

abstract class SecureStorage {
  static const _channel = MethodChannel('secure_storage');

  static Future<void> setKey({
    required final String keyName,
    final String? key,
  }) {
    if (key == null) {
      return deleteKey(keyName: keyName);
    } else {
      return _channel.invokeMethod<void>(
        'setKey',
        {
          'keyType': keyName,
          'key': key,
        },
      );
    }
  }

  static Future<void> deleteKey({
    required final String keyName,
  }) {
    return _channel.invokeMethod<void>(
      'deleteKey',
      {
        'keyType': keyName,
      },
    );
  }

  static Future<String?> getKey({
    required final String keyName,
  }) {
    return _channel.invokeMethod<String>(
      'getKey',
      {
        'keyType': keyName,
      },
    );
  }
}
