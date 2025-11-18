/// API 설정
class ApiConfig {
  /// 백엔드 Base URL (환경변수 기반 자동 전환)
  ///
  /// **USE_MOCK_AUTH=true (기본값)**:
  /// - Mock 모드 → http://127.0.0.1:8081 (로컬, 사용 안 함)
  ///
  /// **USE_MOCK_AUTH=false**:
  /// - Real 모드 → http://152.67.219.91:8888 (실제 백엔드)
  static String get baseUrl {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
      // Mock 모드: 로컬 URL (실제로는 API 호출 안 함)
      return 'http://127.0.0.1:8081';
    } else {
      // Real 모드: 실제 백엔드 서버
      return const String.fromEnvironment(
        'NODE_BACKEND_URL',
        defaultValue: 'http://152.67.219.91:8888',
      );
    }
  }

  // API 엔드포인트 (백엔드 API 스펙에 맞춤)
  static const String loginEndpoint = '/auth/login';
  static const String refreshEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String userMeEndpoint = '/users/me';

  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
