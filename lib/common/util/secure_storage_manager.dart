import 'package:flutter/foundation.dart';
import 'package:secure_storage/secure_storage.dart';

enum KeyType {
  authKey,
  refreshAuthKey,
  recurringLoginType,
  @protected
  userInfo,
}

class SecureStorageManager {
  String? _accessKey;
  String? _accessRefreshKey;

  String? get accessKey => _accessKey;
  String? get accessRefreshKey => _accessRefreshKey;

  void setAccessKeys({
    required final String accessKey,
    required final String refreshAccessKey,
  }) {
    _accessKey = accessKey;
    _accessRefreshKey = refreshAccessKey;
  }

  void clearAccessKeys() {
    _accessKey = null;
    _accessRefreshKey = null;
  }

  Future<String?> getSecureKey(final KeyType keyType) =>
      SecureStorage.getKey(keyName: keyType.name);

  Future<void> saveSecureKey({
    required final KeyType keyType,
    required final String key,
  }) {
    return SecureStorage.setKey(
      keyName: keyType.name,
      key: key,
    );
  }

  Future<void> deleteSecureKey({
    required final KeyType keyType,
  }) {
    return SecureStorage.deleteKey(
      keyName: keyType.name,
    );
  }

  Future<void> logout() async {
    clearAccessKeys();

    for (final keyType in KeyType.values) {
      await deleteSecureKey(keyType: keyType);
    }
  }
}
