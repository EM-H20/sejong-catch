import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_storage_service.g.dart';

/// FlutterSecureStorage Provider
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

/// 토큰 저장 서비스
@riverpod
class TokenStorageService extends _$TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _studentIdKey = 'student_id';

  @override
  void build() {}

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    try {
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _accessTokenKey, value: token);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error saving access token: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error saving access token: $e');
      rethrow;
    }
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    try {
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _refreshTokenKey, value: token);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error saving refresh token: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error saving refresh token: $e');
      rethrow;
    }
  }

  /// 두 토큰 한 번에 저장
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      await Future.wait([
        saveAccessToken(accessToken),
        saveRefreshToken(refreshToken),
      ]);
    } catch (e) {
      debugPrint('[TokenStorage] Error saving tokens: $e');
      rethrow;
    }
  }

  /// Access Token 조회
  Future<String?> getAccessToken() async {
    try {
      final storage = ref.read(secureStorageProvider);
      return await storage.read(key: _accessTokenKey);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error reading access token: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error reading access token: $e');
      return null;
    }
  }

  /// Refresh Token 조회
  Future<String?> getRefreshToken() async {
    try {
      final storage = ref.read(secureStorageProvider);
      return await storage.read(key: _refreshTokenKey);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error reading refresh token: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error reading refresh token: $e');
      return null;
    }
  }

  /// 토큰 삭제 (로그아웃)
  Future<void> clearTokens() async {
    try {
      final storage = ref.read(secureStorageProvider);
      await Future.wait([
        storage.delete(key: _accessTokenKey),
        storage.delete(key: _refreshTokenKey),
        storage.delete(key: _studentIdKey),
      ]);
    } on PlatformException catch (e) {
      // 삭제 실패는 로그만 남기고 무시 (로그아웃은 계속 진행)
      debugPrint(
        '[TokenStorage] Platform error clearing tokens: ${e.code} - ${e.message}',
      );
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error clearing tokens: $e');
    }
  }

  /// Student ID 저장
  ///
  /// 로그인 성공 시 저장하여 토큰 갱신에 사용
  Future<void> saveStudentId(String studentId) async {
    try {
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _studentIdKey, value: studentId);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error saving studentId: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error saving studentId: $e');
      rethrow;
    }
  }

  /// Student ID 조회
  ///
  /// 토큰 갱신 시 백엔드 API가 studentId를 요구함
  Future<String?> getStudentId() async {
    try {
      final storage = ref.read(secureStorageProvider);
      return await storage.read(key: _studentIdKey);
    } on PlatformException catch (e) {
      debugPrint(
        '[TokenStorage] Platform error reading studentId: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      debugPrint('[TokenStorage] Unexpected error reading studentId: $e');
      return null;
    }
  }
}
