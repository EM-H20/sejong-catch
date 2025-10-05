/// 🛡️ 인증 인터셉터 (Dio Interceptor)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Dio Interceptor 가이드 (v2 수정본)
/// 자동 Authorization 헤더 추가 + 401 에러 시 토큰 갱신
///
/// CLAUDE.md 원칙:
/// ✅ 별도 Dio 인스턴스로 무한 루프 방지
/// ✅ Refresh Token 만료 시 자동 로그아웃
/// ✅ 에러 핸들링 및 재시도 로직

import 'package:dio/dio.dart';
import '../repositories/token_repository.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenRepository _tokenRepository;
  final String _baseUrl;

  AuthInterceptor(
    this._dio,
    this._tokenRepository,
    this._baseUrl,
  );

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

    // Access Token 자동 추가
    final accessToken = await _tokenRepository.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
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
        }
      } catch (refreshError) {
        // Refresh 실패 → 로그아웃 처리
        await _tokenRepository.clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// ✅ 별도 Dio 인스턴스로 토큰 갱신 (무한 루프 방지!)
  ///
  /// 참조: AUTH_API_SPEC.md - Interceptor 무한 루프 수정
  /// 🚨 중요: Interceptor가 적용되지 않은 독립적인 Dio 인스턴스 생성!
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _tokenRepository.getRefreshToken();
    if (refreshToken == null) return null;

    // Interceptor 없는 별도 Dio 인스턴스
    final refreshDio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
    ));

    try {
      final response = await refreshDio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      return response.data['access_token'] as String?;
    } catch (e) {
      // Refresh 실패
      return null;
    }
  }
}
