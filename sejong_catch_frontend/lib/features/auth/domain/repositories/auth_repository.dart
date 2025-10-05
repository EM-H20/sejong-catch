/// 🔐 인증 저장소 인터페이스 (Domain Layer)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Repository 패턴
/// Data Layer 구현체와 분리된 추상 인터페이스
///
/// CLAUDE.md 원칙:
/// ✅ 추상화로 테스트 용이성 향상 (Mock 주입 가능)
/// ✅ Domain Entity 사용 (DTO X)
/// ✅ 비즈니스 로직 중심 메서드 정의

import '../entities/user.dart';

abstract class AuthRepository {
  /// 로그인
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/login
  /// [studentId]: 세종대 학번
  /// [password]: 세종대 포털 비밀번호
  /// Returns: 인증된 사용자 정보
  /// Throws: ValidationException, UnauthorizedException, RateLimitException 등
  Future<User> login(String studentId, String password);

  /// Access Token 갱신
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/refresh
  /// 내부적으로 TokenRepository에서 Refresh Token 조회
  /// Returns: 갱신 성공 여부
  /// Throws: SessionExpiredException (Refresh Token 만료 시)
  Future<bool> refreshAccessToken();

  /// 내 정보 조회
  ///
  /// 참조: AUTH_API_SPEC.md - GET /api/users/me
  /// Returns: 상세 사용자 정보 (가입일, 마지막 로그인 포함)
  /// Throws: UnauthorizedException, NotFoundException
  Future<User> getMyProfile();

  /// 로그아웃
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/logout
  /// 서버에서 Refresh Token 무효화 + 로컬 토큰 삭제
  /// Returns: 로그아웃 성공 여부
  Future<bool> logout();

  /// 현재 로그인 상태 확인
  ///
  /// TokenRepository에 Access Token이 있는지 확인
  /// Returns: true면 로그인 상태, false면 비로그인
  Future<bool> isLoggedIn();
}
