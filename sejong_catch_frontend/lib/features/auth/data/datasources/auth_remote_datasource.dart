/// 📡 인증 API 원격 데이터 소스 (Retrofit)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Retrofit API 인터페이스
/// 모든 인증 관련 API 호출 정의
///
/// CLAUDE.md 원칙:
/// ✅ Retrofit 사용 (코드 생성으로 타입 안전성 보장)
/// ✅ Interceptor에서 자동 Authorization 헤더 추가
/// ✅ 명세서 참조 주석 추가

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/request/login_request.dart';
import '../models/request/refresh_request.dart';
import '../models/response/auth_response.dart';
import '../models/response/refresh_response.dart';
import '../models/response/user_profile_dto.dart';
import '../models/response/logout_response.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  /// 로그인
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/login
  /// 세종대 포털 계정으로 로그인 → Access Token + Refresh Token 발급
  @POST('/api/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  /// Access Token 갱신
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/refresh
  /// Refresh Token으로 새로운 Access Token 발급 (15분 만료)
  @POST('/api/auth/refresh')
  Future<RefreshResponse> refresh(@Body() RefreshRequest request);

  /// 내 정보 조회
  ///
  /// 참조: AUTH_API_SPEC.md - GET /api/users/me
  /// ⚠️ Authorization 헤더는 Interceptor에서 자동 추가됨
  @GET('/api/users/me')
  Future<UserProfileDto> getMyProfile();

  /// 로그아웃
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/logout
  /// ⚠️ Authorization 헤더는 Interceptor에서 자동 추가됨
  /// 서버에서 Refresh Token 무효화 처리
  @POST('/api/auth/logout')
  Future<LogoutResponse> logout();
}
