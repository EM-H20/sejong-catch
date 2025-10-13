import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_service.g.dart';

/// 온보딩 상태 관리 서비스
class OnboardingService {
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  /// 온보딩을 본 적이 있는지 확인
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  /// 온보딩 완료 표시
  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, true);
  }

  /// 온보딩 상태 초기화 (로그아웃 시 사용)
  Future<void> clearOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasSeenOnboarding);
  }

  /// 로컬 데이터 전체 삭제 (로그아웃)
  ///
  /// **동작**: SharedPreferences의 모든 데이터를 삭제합니다.
  /// 온보딩 상태도 삭제되어 다음 실행 시 온보딩부터 시작합니다.
  Future<void> clearAllLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 온보딩 완료 여부 확인 (isOnboardingCompleted alias)
  Future<bool> isOnboardingCompleted() async {
    return await hasSeenOnboarding();
  }
}

/// OnboardingService Provider
@riverpod
OnboardingService onboardingService(Ref ref) {
  return OnboardingService();
}
