import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_mode.dart';

/// 온보딩 완료 여부를 관리하는 서비스
class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _devModeKey = 'dev_mode_enabled';
  static const String _forceCompletedKey = 'onboarding_force_completed';

  final SharedPreferences _prefs;

  OnboardingService(this._prefs);

  /// 온보딩 완료 여부 확인
  Future<bool> isOnboardingCompleted() async {
    // 🚀 force로 완료된 경우 개발 모드와 상관없이 true 반환
    if (_prefs.getBool(_forceCompletedKey) ?? false) {
      return true;
    }

    // 🎯 전역 AppMode에서 개발 모드 확인 - 개발 모드에서는 항상 온보딩 표시
    if (AppModeManager.shouldShowOnboardingAlways) {
      return false;
    }

    // 레거시 개발 모드 설정도 확인 (하위 호환성)
    if (isDevMode()) {
      return false;
    }

    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// 온보딩 완료 상태 저장
  Future<void> setOnboardingCompleted({bool force = false}) async {
    await _prefs.setBool(_onboardingCompletedKey, true);

    // 🎯 force 모드인 경우에만 개발 모드와 상관없이 완료 상태 저장
    if (force) {
      await _prefs.setBool(_forceCompletedKey, true);
      // force 모드에서만 개발 모드 플래그 해제 (테스트/프로덕션용)
      await _prefs.setBool(_devModeKey, false);
    }

    // 🚀 개발 모드에서는 force가 아닌 경우 개발 모드 플래그 유지
    // 이렇게 하면 다음 실행 시에도 온보딩이 나타남
  }

  /// 온보딩 상태 초기화 (테스트용)
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingCompletedKey);
    await _prefs.remove(_forceCompletedKey);
    await _prefs.remove(_devModeKey);
  }

  /// 개발모드 전용: 완전 초기화 (모든 온보딩 관련 설정 제거)
  Future<void> resetAllOnboardingSettings() async {
    if (AppModeManager.isDevelopment) {
      await _prefs.remove(_onboardingCompletedKey);
      await _prefs.remove(_forceCompletedKey);
      await _prefs.remove(_devModeKey);

      // 개발모드 플래그 다시 설정 (디버그 빌드에서 온보딩 항상 표시)
      await _prefs.setBool(_devModeKey, true);
    }
  }

  /// 개발 모드 확인
  bool isDevMode() {
    return _prefs.getBool(_devModeKey) ?? false;
  }

  /// 개발 모드 설정
  Future<void> setDevMode(bool enabled) async {
    await _prefs.setBool(_devModeKey, enabled);
  }
}

/// OnboardingService Provider
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  throw UnimplementedError('SharedPreferences를 먼저 초기화해야 합니다');
});

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('main.dart에서 override 해야 합니다');
});
