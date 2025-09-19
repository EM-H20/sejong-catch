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

    // 🎯 force 모드인 경우 개발 모드와 상관없이 완료 상태 저장
    if (force) {
      await _prefs.setBool(_forceCompletedKey, true);
    }

    // 🎯 개발 모드에서도 온보딩을 완료할 수 있도록 개발 모드 플래그 임시 해제
    if (force || AppModeManager.shouldShowOnboardingAlways) {
      // 개발 모드 플래그를 임시로 false로 설정하여 온보딩 완료 허용
      await _prefs.setBool(_devModeKey, false);
    }
  }

  /// 온보딩 상태 초기화 (테스트용)
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingCompletedKey);
    await _prefs.remove(_forceCompletedKey);
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
