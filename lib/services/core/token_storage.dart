import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles saving/reading/clearing the JWT returned by
/// POST /api/auth/register and POST /api/auth/login
/// (per Backend_API_Documentation.docx, Section 3.1).
/// Uses secure device storage — never SharedPreferences for tokens.
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  static Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}