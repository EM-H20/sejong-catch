import 'package:flutter/foundation.dart';

/// 앱 실행 모드 정의
enum AppMode {
  /// 개발 모드 - 개발자 도구, 디버그 기능, 온보딩 스킵 안함
  development,

  /// 스테이징 모드 - 프로덕션과 유사하지만 테스트 데이터 사용
  staging,

  /// 프로덕션 모드 - 실제 배포 환경
  production,
}

/// 전역 앱 모드 관리자
/// main.dart에서 초기화되며, 앱 전체에서 참조 가능
class AppModeManager {
  static AppMode? _currentMode;

  /// 현재 앱 모드 (초기화 후 접근 가능)
  static AppMode get currentMode {
    assert(_currentMode != null, 'AppMode가 초기화되지 않았습니다. main.dart에서 AppModeManager.initialize()를 호출하세요.');
    return _currentMode!;
  }

  /// 앱 모드 초기화 (main.dart에서 호출)
  static void initialize(AppMode mode) {
    _currentMode = mode;
  }

  /// 개발 모드 여부
  static bool get isDevelopment => currentMode == AppMode.development;

  /// 스테이징 모드 여부
  static bool get isStaging => currentMode == AppMode.staging;

  /// 프로덕션 모드 여부
  static bool get isProduction => currentMode == AppMode.production;

  /// 디버그 기능 활성화 여부 (개발 + 스테이징)
  static bool get isDebugEnabled => isDevelopment || isStaging;

  /// 온보딩 스킵 여부 (개발 모드에서만 스킵 안함)
  static bool get shouldShowOnboardingAlways => isDevelopment;

  /// 개발자 도구 표시 여부
  static bool get showDeveloperTools => isDevelopment;

  /// 로깅 레벨 반환
  static String get logLevel {
    switch (currentMode) {
      case AppMode.development:
        return 'debug';
      case AppMode.staging:
        return 'info';
      case AppMode.production:
        return 'warning';
    }
  }

  /// API 엔드포인트 반환
  static String get apiBaseUrl {
    switch (currentMode) {
      case AppMode.development:
        return 'http://localhost:8000'; // 로컬 개발 서버
      case AppMode.staging:
        return 'https://staging-api.sejongcatch.com'; // 스테이징 서버
      case AppMode.production:
        return 'https://api.sejongcatch.com'; // 프로덕션 서버
    }
  }

  /// 현재 모드 문자열 반환
  static String get modeString {
    switch (currentMode) {
      case AppMode.development:
        return 'DEV';
      case AppMode.staging:
        return 'STAGING';
      case AppMode.production:
        return 'PROD';
    }
  }

  /// 앱 모드에 따른 자동 설정
  static AppMode getAutoMode() {
    // 디버그 빌드면 개발 모드
    if (kDebugMode) {
      return AppMode.development;
    }

    // 프로파일 빌드면 스테이징 모드
    if (kProfileMode) {
      return AppMode.staging;
    }

    // 릴리즈 빌드면 프로덕션 모드
    return AppMode.production;
  }

  /// 환경 변수나 설정으로 모드 재정의 가능
  static AppMode getModeFromConfig() {
    // 🚀 환경 변수로 모드 강제 설정 가능
    const String envMode = String.fromEnvironment('APP_MODE');
    if (envMode.isNotEmpty) {
      switch (envMode.toLowerCase()) {
        case 'dev':
        case 'development':
          return AppMode.development;
        case 'staging':
          return AppMode.staging;
        case 'prod':
        case 'production':
          return AppMode.production;
        default:
          // 알 수 없는 모드는 경고하고 자동 감지 사용
          if (kDebugMode) {
            debugPrint('⚠️ 알 수 없는 APP_MODE: $envMode, 자동 감지 모드 사용');
          }
          break;
      }
    }

    // 기본값은 자동 감지
    return getAutoMode();
  }
}