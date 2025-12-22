import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // This helps with Android 13+ compatibility
      resetOnError: true,
    ),
  );

  static Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Error reading from secure storage: $e');
      return null;
    }
  }

  static Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
    }
  }

  static Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error deleting from secure storage: $e');
    }
  }

  static Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing secure storage: $e');
    }
  }
}
