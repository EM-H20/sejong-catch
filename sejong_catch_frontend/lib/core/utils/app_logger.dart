import 'package:flutter/foundation.dart';
import '../config/app_mode.dart';

/// 🚀 세종 캐치 앱 전용 로거
/// AppMode에 따른 로그 레벨 자동 조절
class AppLogger {
  AppLogger._();

  /// 디버그 로그 (개발 모드에서만)
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (_shouldLog('debug')) {
      debugPrint('🐛 [DEBUG] $message');
      if (error != null) debugPrint('   Error: $error');
      if (stackTrace != null) debugPrint('   Stack: $stackTrace');
    }
  }

  /// 정보 로그 (개발 + 스테이징)
  static void info(String message) {
    if (_shouldLog('info')) {
      debugPrint('ℹ️  [INFO] $message');
    }
  }

  /// 경고 로그 (모든 모드)
  static void warning(String message, [Object? error]) {
    if (_shouldLog('warning')) {
      debugPrint('⚠️  [WARNING] $message');
      if (error != null) debugPrint('   Error: $error');
    }
  }

  /// 에러 로그 (모든 모드)
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('❌ [ERROR] $message');
    if (error != null) debugPrint('   Error: $error');
    if (stackTrace != null) debugPrint('   Stack: $stackTrace');
  }

  /// 성공 로그 (개발 + 스테이징)
  static void success(String message) {
    if (_shouldLog('info')) {
      debugPrint('✅ [SUCCESS] $message');
    }
  }

  /// API 요청 로그 (개발 모드에서만)
  static void api(String method, String url, {Map<String, dynamic>? data}) {
    if (_shouldLog('debug')) {
      debugPrint('🌐 [API] $method $url');
      if (data != null) debugPrint('   Data: $data');
    }
  }

  /// 네비게이션 로그 (개발 모드에서만)
  static void navigation(String from, String to) {
    if (_shouldLog('debug')) {
      debugPrint('🧭 [NAV] $from → $to');
    }
  }

  /// 상태 변경 로그 (개발 모드에서만)
  static void state(String provider, dynamic oldState, dynamic newState) {
    if (_shouldLog('debug')) {
      debugPrint('🔄 [STATE] $provider');
      debugPrint('   From: $oldState');
      debugPrint('   To: $newState');
    }
  }

  /// 로그 레벨 확인
  static bool _shouldLog(String level) {
    final appLogLevel = AppModeManager.logLevel;

    switch (appLogLevel) {
      case 'debug':
        return true; // 모든 로그 출력
      case 'info':
        return level != 'debug'; // debug 제외하고 출력
      case 'warning':
        return level == 'warning' || level == 'error'; // warning, error만 출력
      default:
        return level == 'error'; // error만 출력
    }
  }
}