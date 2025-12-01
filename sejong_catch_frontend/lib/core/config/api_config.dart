import 'env_config.dart';

/// API 설정
class ApiConfig {
  /// 백엔드 Base URL (컴파일 타임 상수 기반 자동 전환)
  ///
  /// **USE_MOCK_AUTH=true (기본값)**:
  /// - Mock 모드 → 로컬 URL (실제로는 API 호출 안 함)
  ///
  /// **USE_MOCK_AUTH=false**:
  /// - Real 모드 → BACKEND_URL (dart-define으로 전달)
  static String get baseUrl {
    // 🔥 컴파일 타임 상수 사용 (launch.json 설정 반영!)
    return EnvConfig.backendUrl;
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
