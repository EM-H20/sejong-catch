/// 🔐 토큰 저장소 구현체
///
/// 참조: claudedocs/AUTH_API_SPEC.md - 토큰 저장소 추상화
/// FlutterSecureStorage를 사용한 TokenRepository 구현
///
/// CLAUDE.md 원칙:
/// ✅ FlutterSecureStorage로 민감 정보 안전 저장
/// ✅ 인터페이스 구현으로 테스트 가능
/// ✅ 토큰 로깅 금지 (보안)

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage _storage;

  /// Storage key 상수
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  TokenRepositoryImpl(this._storage);

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
