/// 🔐 토큰 저장소 구현체
///
/// 참조: claudedocs/AUTH_API_SPEC.md - 토큰 저장소 추상화
/// FlutterSecureStorage를 사용한 TokenRepository 구현
///
/// CLAUDE.md 원칙:
/// ✅ FlutterSecureStorage로 민감 정보 안전 저장
/// ✅ 인터페이스 구현으로 테스트 가능
/// ✅ 토큰 로깅 금지 (보안)
/// ✅ PlatformException 안전 처리 (iOS Keychain, Android KeyStore 에러)

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage _storage;

  /// Storage key 상수
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _studentIdKey = 'student_id';

  TokenRepositoryImpl(this._storage);

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error reading access token: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error reading access token: $e');
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error reading refresh token: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      // 예상치 못한 에러
      debugPrint(
        '[TokenRepository] Unexpected error reading refresh token: $e',
      );
      return null;
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error saving access token: ${e.code} - ${e.message}',
      );
      rethrow; // 저장 실패는 상위에서 처리해야 함
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error saving access token: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error saving refresh token: ${e.code} - ${e.message}',
      );
      rethrow; // 저장 실패는 상위에서 처리해야 함
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error saving refresh token: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
        _storage.delete(key: _studentIdKey),
      ]);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      // 삭제 실패는 로그만 남기고 무시 (로그아웃은 계속 진행)
      debugPrint(
        '[TokenRepository] Platform error clearing tokens: ${e.code} - ${e.message}',
      );
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error clearing tokens: $e');
    }
  }

  @override
  Future<String?> getStudentId() async {
    try {
      return await _storage.read(key: _studentIdKey);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error reading studentId: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error reading studentId: $e');
      return null;
    }
  }

  @override
  Future<void> saveStudentId(String studentId) async {
    try {
      await _storage.write(key: _studentIdKey, value: studentId);
    } on PlatformException catch (e) {
      // iOS Keychain, Android KeyStore 에러
      debugPrint(
        '[TokenRepository] Platform error saving studentId: ${e.code} - ${e.message}',
      );
      rethrow; // 저장 실패는 상위에서 처리해야 함
    } catch (e) {
      // 예상치 못한 에러
      debugPrint('[TokenRepository] Unexpected error saving studentId: $e');
      rethrow;
    }
  }
}
