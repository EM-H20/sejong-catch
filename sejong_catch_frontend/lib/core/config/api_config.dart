/// API 설정
class ApiConfig {
  // 백엔드 Base URL (개발 환경)
  // TODO: 프로덕션 환경에서는 실제 서버 URL로 변경
  static const String baseUrl = 'http://127.0.0.1:8081';

  // API 엔드포인트
  static const String loginEndpoint = '/api/auth/login';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String userMeEndpoint = '/api/users/me';

  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
