import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles saving/reading/clearing the JWT returned by
/// POST /api/auth/register and POST /api/auth/login
/// (per Backend_API_Documentation.docx, Section 3.1).
/// Uses secure device storage — never SharedPreferences for tokens.
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _studentUuidKey = 'student_uuid';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    // A new login may be a different student, so drop the cached uuid.
    await _storage.delete(key: _studentUuidKey);
  }

  static Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  /// TEMPORARY (see ApiClient): the student's uuid from GET /me, sent as
  /// X-Student-Token until the backend reads the Bearer token for progress.
  static Future<void> saveStudentUuid(String uuid) {
    return _storage.write(key: _studentUuidKey, value: uuid);
  }

  static Future<String?> getStudentUuid() {
    return _storage.read(key: _studentUuidKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _studentUuidKey);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}