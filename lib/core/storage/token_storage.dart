import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Manages secure persistence of the auth token.
///
/// Registered as a singleton in get_it:
/// ```dart
/// sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
/// ```
class TokenStorage {
  TokenStorage() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  /// Saves the token securely.
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  /// Reads the stored token. Returns null if not set.
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  /// Deletes the token (e.g. on logout).
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  /// Returns true if a token currently exists in storage.
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Returns true if the token exists and has not expired.
  Future<bool> hasValidToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) {
      return false;
    }
    
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      // If the token is malformed, treat it as invalid
      return false;
    }
  }
}
