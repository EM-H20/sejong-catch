/// 🔧 환경 설정 (컴파일 타임 상수)
///
/// **중요**: 이 값들은 `--dart-define`으로 전달되어 컴파일 타임에 결정됩니다!
///
/// **사용법** (launch.json 또는 CLI):
/// ```bash
/// flutter run --dart-define=USE_MOCK_AUTH=true
/// flutter run --dart-define=USE_MOCK_AUTH=false --dart-define=BACKEND_URL=http://...
/// ```
///
/// **왜 dart-define?**
/// - `.env` 파일은 런타임에 읽어서 launch.json 설정이 무시됨
/// - `dart-define`은 컴파일 타임에 결정되어 확실하게 분기됨
/// - 민감 정보 노출 위험 없음 (빌드에 직접 포함)
class EnvConfig {
  EnvConfig._();

  /// Mock 모드 여부
  ///
  /// - **true (기본값)**: Mock 데이터 사용 (개발/테스트)
  /// - **false**: 실제 API 호출 (서버 연결)
  ///
  /// **설정 방법**: `--dart-define=USE_MOCK_AUTH=true`
  static const bool useMockAuth = bool.fromEnvironment(
    'USE_MOCK_AUTH',
    defaultValue: true, // 기본값: Mock 모드 (안전!)
  );

  /// 백엔드 서버 URL (Real 모드 전용)
  ///
  /// **⚠️ Mock 모드에서는 사용되지 않음!**
  /// - Mock 모드: API 호출 없이 Mock 데이터 직접 반환
  /// - Real 모드: 이 URL로 실제 API 호출
  ///
  /// **설정 방법**: `--dart-define=BACKEND_URL=http://...`
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: '', // Mock 모드에서는 사용 안 함
  );

  /// 디버그 모드 출력
  static void printConfig() {
    // ignore: avoid_print
    print('╔════════════════════════════════════════════╗');
    // ignore: avoid_print
    print('║  🔧 EnvConfig (Compile-time Constants)     ║');
    // ignore: avoid_print
    print('╠════════════════════════════════════════════╣');
    // ignore: avoid_print
    print(
      '║  USE_MOCK_AUTH: $useMockAuth${useMockAuth ? ' (Mock 모드)' : ' (Real 모드)'}',
    );
    // ignore: avoid_print
    print('║  BACKEND_URL: $backendUrl');
    // ignore: avoid_print
    print('╚════════════════════════════════════════════╝');
  }
}
