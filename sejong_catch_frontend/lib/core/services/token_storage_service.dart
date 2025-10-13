import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage_service.g.dart';

/// FlutterSecureStorage Provider
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage();
}

/// 토큰 저장 서비스
@riverpod
class TokenStorageService extends _$TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  void build() {}

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _accessTokenKey, value: token);
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _refreshTokenKey, value: token);
  }

  /// 두 토큰 한 번에 저장
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Access Token 조회
  Future<String?> getAccessToken() async {
    final storage = ref.read(secureStorageProvider);
    return await storage.read(key: _accessTokenKey);
  }

  /// Refresh Token 조회
  Future<String?> getRefreshToken() async {
    final storage = ref.read(secureStorageProvider);
    return await storage.read(key: _refreshTokenKey);
  }

  /// 토큰 삭제 (로그아웃)
  Future<void> clearTokens() async {
    final storage = ref.read(secureStorageProvider);
    await Future.wait([
      storage.delete(key: _accessTokenKey),
      storage.delete(key: _refreshTokenKey),
    ]);
  }
}
