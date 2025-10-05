/// 🌍 환경 설정 관리
///
/// 참조: claudedocs/AUTH_API_SPEC.md - 환경 설정 관리
/// 개발/스테이징/프로덕션 환경 분리
///
/// CLAUDE.md 원칙:
/// ✅ 환경별 baseUrl 관리
/// ✅ 하드코딩 제거
/// ✅ --dart-define으로 환경 지정

enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  final Environment environment;

  EnvConfig(this.environment);

  /// API 서버 주소
  ///
  /// 개발: localhost:3000
  /// 스테이징: staging-api.sejongcatch.com
  /// 프로덕션: api.sejongcatch.com
  String get baseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.sejongcatch.com';
      case Environment.production:
        return 'https://api.sejongcatch.com';
    }
  }

  /// 프로덕션 환경 여부
  bool get isProduction => environment == Environment.production;

  /// 디버그 모드 여부
  bool get isDebug => environment == Environment.development;
}
