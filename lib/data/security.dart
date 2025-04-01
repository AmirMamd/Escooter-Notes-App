import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageInterface {
  Future<void> writeSecureData(String key, String value);

  Future<String> readSecureData(String key);

  Future<void> deleteAll();

  Future<void> deleteSecureData(String key);
}

class SecureStorage implements SecureStorageInterface {
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  SecureStorage._internal();

  final _storage = const FlutterSecureStorage();

  @override
  Future<void> writeSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String> readSecureData(String key) async {
    try {
      return await _storage.read(key: key) ?? 'No Data Found';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
}
