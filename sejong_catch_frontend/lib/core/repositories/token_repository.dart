/// 🔐 토큰 저장소 인터페이스
///
/// 참조: claudedocs/AUTH_API_SPEC.md - 토큰 저장소 추상화
/// FlutterSecureStorage를 추상화하여 테스트 용이성 향상
///
/// CLAUDE.md 원칙:
/// ✅ 인터페이스 분리로 테스트 시 Mock 주입 가능
/// ✅ 민감 정보는 FlutterSecureStorage 사용
/// ✅ 일반 설정은 SharedPreferences 사용

abstract class TokenRepository {
  /// Access Token 조회
  ///
  /// 참조: AUTH_API_SPEC.md - Access Token (15분 만료)
  /// Returns: 저장된 Access Token 또는 null
  Future<String?> getAccessToken();

  /// Refresh Token 조회
  ///
  /// 참조: AUTH_API_SPEC.md - Refresh Token (7일 만료)
  /// Returns: 저장된 Refresh Token 또는 null
  Future<String?> getRefreshToken();

  /// Access Token 저장
  ///
  /// FlutterSecureStorage에 안전하게 저장
  /// [token]: 저장할 Access Token
  Future<void> saveAccessToken(String token);

  /// Refresh Token 저장
  ///
  /// FlutterSecureStorage에 안전하게 저장
  /// [token]: 저장할 Refresh Token
  Future<void> saveRefreshToken(String token);

  /// 모든 토큰 삭제
  ///
  /// 사용 예시:
  /// - 로그아웃 시
  /// - Refresh Token 만료 시 (SessionExpiredException)
  /// - 강제 로그아웃 처리
  Future<void> clearTokens();
}
