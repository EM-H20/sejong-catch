import 'package:flutter/foundation.dart';

/// 세종 캐치 앱의 전역 설정을 관리하는 클래스
///
/// 환경별 설정, API 엔드포인트, 기능 플래그 등을 중앙 집중식으로 관리합니다.
/// 개발/스테이징/프로덕션 환경을 구분하여 설정을 분리할 수 있어요.
class AppConfig {
  // Private constructor - 인스턴스 생성 방지 (싱글톤 패턴)
  AppConfig._();

  // ============================================================================
  // 환경 설정 (Environment Configuration)
  // ============================================================================

  /// 현재 앱 환경 (개발/스테이징/프로덕션)
  static const String environment = kDebugMode ? 'development' : 'production';

  /// 개발 환경 여부 확인
  static bool get isDevelopment => environment == 'development';

  /// 프로덕션 환경 여부 확인
  static bool get isProduction => environment == 'production';

  // ============================================================================
  // API 설정 (API Configuration)
  // ============================================================================

  /// 백엔드 API 기본 URL
  ///
  /// 개발 환경: 로컬 서버 (localhost:8000)
  /// 프로덕션: 실제 서버 URL로 교체 필요
  static String get apiBaseUrl {
    switch (environment) {
      case 'development':
        return 'http://localhost:8000/api/v1';
      case 'staging':
        return 'https://staging-api.sejongcatch.com/api/v1';
      case 'production':
        return 'https://api.sejongcatch.com/api/v1';
      default:
        return 'http://localhost:8000/api/v1';
    }
  }

  /// WebSocket 연결 URL (실시간 알림용)
  static String get websocketUrl {
    switch (environment) {
      case 'development':
        return 'ws://localhost:8000/ws';
      case 'staging':
        return 'wss://staging-api.sejongcatch.com/ws';
      case 'production':
        return 'wss://api.sejongcatch.com/ws';
      default:
        return 'ws://localhost:8000/ws';
    }
  }

  // ============================================================================
  // 타임아웃 설정 (Timeout Configuration)
  // ============================================================================

  /// HTTP 요청 연결 타임아웃 (밀리초)
  static const int connectTimeoutMs = 10000; // 10초

  /// HTTP 요청 수신 타임아웃 (밀리초)
  static const int receiveTimeoutMs = 15000; // 15초

  /// HTTP 요청 전송 타임아웃 (밀리초)
  static const int sendTimeoutMs = 10000; // 10초

  // ============================================================================
  // 페이지네이션 설정 (Pagination Configuration)
  // ============================================================================

  /// 피드 페이지당 아이템 수
  static const int feedPageSize = 20;

  /// 검색 결과 페이지당 아이템 수
  static const int searchPageSize = 15;

  /// 대기열 페이지당 아이템 수
  static const int queuePageSize = 10;

  /// 무한 스크롤 트리거 오프셋 (남은 아이템 개수)
  static const int infiniteScrollOffset = 3;

  // ============================================================================
  // 캐싱 설정 (Caching Configuration)
  // ============================================================================

  /// 이미지 캐시 최대 개수
  static const int maxImageCacheCount = 100;

  /// 이미지 캐시 유지 시간 (시간)
  static const int imageCacheHours = 24;

  /// API 응답 캐시 유지 시간 (분)
  static const int apiCacheMinutes = 15;

  /// 검색 기록 최대 저장 개수
  static const int maxSearchHistoryCount = 20;

  // ============================================================================
  // UI/UX 설정 (UI/UX Configuration)
  // ============================================================================

  /// 디바운스 시간 (검색 입력 지연시간, 밀리초)
  static const int searchDebounceMs = 500;

  /// 애니메이션 기본 지속시간 (밀리초)
  static const int animationDurationMs = 200;

  /// 스낵바 표시 지속시간 (밀리초)
  static const int snackBarDurationMs = 3000;

  /// Shimmer 로딩 애니메이션 주기 (밀리초)
  static const int shimmerDurationMs = 1500;

  // ============================================================================
  // 보안 설정 (Security Configuration)
  // ============================================================================

  /// JWT 토큰 자동 갱신 임계시간 (분)
  /// 토큰 만료 30분 전에 자동으로 갱신 시도
  static const int tokenRefreshThresholdMinutes = 30;

  /// 로그인 세션 유지 시간 (일)
  static const int sessionValidityDays = 30;

  /// 비밀번호 최소 길이
  static const int minPasswordLength = 8;

  // ============================================================================
  // 알림 설정 (Notification Configuration)
  // ============================================================================

  /// 푸시 알림 기본 활성화 여부
  static const bool defaultNotificationEnabled = true;

  /// 마감 임박 알림 기본 시간 (시간)
  static const int defaultDeadlineNotificationHours = 24;

  /// 대기열 순서 알림 활성화 여부
  static const bool queueNotificationEnabled = true;

  // ============================================================================
  // 기능 플래그 (Feature Flags)
  // ============================================================================

  /// 다크 모드 지원 여부
  static const bool darkModeSupported = true;

  /// 오프라인 모드 지원 여부
  static const bool offlineModeSupported = false;

  /// 소셜 로그인 지원 여부 (구글, 애플)
  static const bool socialLoginSupported = true;

  /// 관리자 콘솔 접근 허용 여부
  static bool get adminConsoleEnabled => isDevelopment || isProduction;

  /// 개발자 도구 표시 여부
  static bool get devToolsEnabled => isDevelopment;

  /// 로그 출력 레벨 (개발: verbose, 프로덕션: error만)
  static String get logLevel => isDevelopment ? 'verbose' : 'error';

  // ============================================================================
  // 앱 정보 (App Information)
  // ============================================================================

  /// 앱 버전 (pubspec.yaml과 동기화 필요)
  static const String appVersion = '1.0.0';

  /// 최소 지원 API 레벨
  static const String minApiVersion = '1.0';

  /// 개발팀 연락처
  static const String supportEmail = 'support@sejongcatch.com';

  /// 개인정보 처리방침 URL
  static const String privacyPolicyUrl = 'https://sejongcatch.com/privacy';

  /// 서비스 이용약관 URL
  static const String termsOfServiceUrl = 'https://sejongcatch.com/terms';

  // ============================================================================
  // 헬퍼 메서드 (Helper Methods)
  // ============================================================================

  /// 현재 설정 정보를 디버그용으로 출력
  static void debugPrintConfig() {
    if (!isDevelopment) return;

    debugPrint('🚀 세종 캐치 앱 설정 정보');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📱 환경: $environment');
    debugPrint('🌐 API URL: $apiBaseUrl');
    debugPrint('⚡ WebSocket: $websocketUrl');
    debugPrint('📄 페이지 크기: 피드=$feedPageSize, 검색=$searchPageSize');
    debugPrint('🎨 다크모드: ${darkModeSupported ? '지원' : '미지원'}');
    debugPrint('👨‍💼 관리자 콘솔: ${adminConsoleEnabled ? '활성화' : '비활성화'}');
    debugPrint('🔧 개발 도구: ${devToolsEnabled ? '활성화' : '비활성화'}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  /// 환경별 설정 유효성 검증
  static bool validateConfig() {
    // API URL 유효성 검사
    if (apiBaseUrl.isEmpty) {
      debugPrint('❌ API Base URL이 설정되지 않았습니다');
      return false;
    }

    // 페이지 크기 유효성 검사
    if (feedPageSize <= 0 || searchPageSize <= 0) {
      debugPrint('❌ 페이지 크기가 올바르지 않습니다');
      return false;
    }

    // 타임아웃 설정 유효성 검사
    if (connectTimeoutMs <= 0 || receiveTimeoutMs <= 0) {
      debugPrint('❌ 타임아웃 설정이 올바르지 않습니다');
      return false;
    }

    debugPrint('✅ 앱 설정 검증 완료');
    return true;
  }
}
