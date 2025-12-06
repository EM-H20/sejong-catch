/// 🛡️ 인증 인터셉터 (Dio Interceptor)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Dio Interceptor 가이드 (v2 수정본)
/// 자동 Authorization 헤더 추가 + 401 에러 시 토큰 갱신
///
/// CLAUDE.md 원칙:
/// ✅ 별도 Dio 인스턴스로 무한 루프 방지
/// ✅ Refresh Token 만료 시 자동 로그아웃
/// ✅ 에러 핸들링 및 재시도 로직

library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../repositories/token_repository.dart';
import '../services/auth_event_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenRepository _tokenRepository;
  final String _baseUrl;

  AuthInterceptor(this._dio, this._tokenRepository, this._baseUrl);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 로그인/갱신 요청은 토큰 불필요
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    try {
      // Access Token 자동 추가
      final accessToken = await _tokenRepository.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (e) {
      // 극단적인 상황 대비 (Storage 에러 등, 정상적으로는 발생하지 않음)
      debugPrint(
        '[AuthInterceptor] Error getting access token in onRequest: $e',
      );
      // 토큰 없이 계속 진행 (API 서버에서 401 처리)
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401 에러 → Access Token 만료
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/refresh')) {
      try {
        // 🔥 핵심: 별도 Dio 인스턴스로 refresh 요청 (무한 루프 방지!)
        final newAccessToken = await _refreshAccessToken();

        if (newAccessToken != null) {
          // 토큰 저장
          await _tokenRepository.saveAccessToken(newAccessToken);

          // 원래 요청 재시도
          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } else {
          // studentId 없음 → 로그아웃 + 세션 만료 이벤트 발행
          await _tokenRepository.clearTokens();
          authEventService.emitSessionExpired(
            message: '로그인 정보가 만료되었습니다. 다시 로그인해주세요.',
          );
          return handler.next(err);
        }
      } on DioException catch (refreshError) {
        // Refresh API 호출 실패
        if (refreshError.response?.statusCode == 401 ||
            refreshError.response?.statusCode == 403 ||
            refreshError.response?.statusCode == 404) {
          // Refresh Token 만료 또는 유효하지 않음 → 로그아웃 + 이벤트 발행
          await _tokenRepository.clearTokens();
          authEventService.emitSessionExpired(
            message: '세션이 만료되었습니다. 다시 로그인해주세요.',
          );
        }
        // 원래 401 에러 전달
        return handler.next(err);
      } catch (e) {
        // 예상치 못한 에러 (Storage 에러 등)
        debugPrint(
          '[AuthInterceptor] Unexpected error during token refresh: $e',
        );
        return handler.next(err);
      }
    }

    // 403 에러 → 권한 없음 (토큰은 유효하지만 권한 부족)
    if (err.response?.statusCode == 403) {
      debugPrint(
        '[AuthInterceptor] Access forbidden: ${err.requestOptions.path}',
      );
      return handler.next(err);
    }

    return handler.next(err);
  }

  /// ✅ 별도 Dio 인스턴스로 토큰 갱신 (무한 루프 방지!)
  ///
  /// 참조: claudedocs/TOKEN_REFRESH_IMPROVEMENT_PLAN.md
  /// 참조: docs/BackendAPI.md - POST /auth/refresh
  ///
  /// 🚨 중요: Interceptor가 적용되지 않은 독립적인 Dio 인스턴스 생성!
  ///
  /// **백엔드 API 스펙**:
  /// - 경로: POST /auth/refresh
  /// - Request Body: { "studentId": "21000000" }
  /// - Response: LoginResponse { accessToken, refreshToken, user }
  ///
  /// Returns:
  /// - 새로운 Access Token (성공 시)
  /// - null (studentId 없음 또는 네트워크 에러)
  ///
  /// Throws:
  /// - DioException: API 호출 실패 (상위에서 처리)
  Future<String?> _refreshAccessToken() async {
    try {
      // studentId 조회 (백엔드 API 스펙: studentId로 refresh 요청)
      final studentId = await _tokenRepository.getStudentId();
      if (studentId == null) {
        debugPrint('[AuthInterceptor] No studentId available for refresh');
        return null;
      }

      // Interceptor 없는 별도 Dio 인스턴스
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // 백엔드 API 스펙대로 요청
      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'studentId': studentId},
      );

      // 응답 검증 (LoginResponse 스펙: accessToken 필드)
      if (response.data == null || response.data['accessToken'] == null) {
        debugPrint(
          '[AuthInterceptor] Invalid refresh response: missing accessToken',
        );
        return null;
      }

      return response.data['accessToken'] as String;
    } on DioException catch (e) {
      // Dio 관련 에러는 상위로 전달 (onError에서 처리)
      debugPrint(
        '[AuthInterceptor] Refresh API failed: ${e.type} - ${e.message}',
      );
      rethrow;
    } catch (e) {
      // Storage 에러 등 예상치 못한 에러
      debugPrint(
        '[AuthInterceptor] Unexpected error in _refreshAccessToken: $e',
      );
      return null;
    }
  }
}
