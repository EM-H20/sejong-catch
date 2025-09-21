import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/major.dart';
import '../../data/models/interest.dart';
import '../../data/models/notification_settings.dart';
import '../../data/services/onboarding_service.dart';

part 'personalization_controller.g.dart';

/// 개인화 설정 상태 모델
class PersonalizationState {
  final Major? selectedMajor;
  final List<Interest> selectedInterests;
  final NotificationSettings notificationSettings;
  final bool isLoading;
  final bool isCompleted;
  final String? error;
  final PersonalizationStep currentStep;

  const PersonalizationState({
    this.selectedMajor,
    this.selectedInterests = const [],
    this.notificationSettings = const NotificationSettings(),
    this.isLoading = false,
    this.isCompleted = false,
    this.error,
    this.currentStep = PersonalizationStep.major,
  });

  PersonalizationState copyWith({
    Major? selectedMajor,
    List<Interest>? selectedInterests,
    NotificationSettings? notificationSettings,
    bool? isLoading,
    bool? isCompleted,
    String? error,
    PersonalizationStep? currentStep,
  }) {
    return PersonalizationState(
      selectedMajor: selectedMajor ?? this.selectedMajor,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      error: error,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  // 유효성 검사 헬퍼
  bool get isMajorSelected => selectedMajor != null;
  bool get hasInterests => selectedInterests.isNotEmpty;
  bool get canComplete => isMajorSelected; // 관심사 선택 제거

  // 진행률 계산
  double get progress {
    double progress = 0.0;
    if (isMajorSelected) progress += 0.8; // 학과 선택만으로 80%
    if (currentStep == PersonalizationStep.notification) progress += 0.2;
    return progress.clamp(0.0, 1.0);
  }
}

/// 개인화 설정 단계
enum PersonalizationStep {
  major('학과 선택'),
  notification('알림 설정');

  const PersonalizationStep(this.displayName);
  final String displayName;
}

/// 개인화 설정 컨트롤러
@riverpod
class PersonalizationController extends _$PersonalizationController {
  @override
  PersonalizationState build() {
    return const PersonalizationState();
  }

  /// 학과 선택
  void selectMajor(Major major) {
    HapticFeedback.lightImpact();
    state = state.copyWith(selectedMajor: major, error: null);
  }

  /// 관심사 토글
  void toggleInterest(Interest interest) {
    final currentInterests = List<Interest>.from(state.selectedInterests);

    if (currentInterests.contains(interest)) {
      currentInterests.remove(interest);
      HapticFeedback.selectionClick();
    } else if (currentInterests.length < 5) {
      currentInterests.add(interest);
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
      state = state.copyWith(error: '관심사는 최대 5개까지 선택할 수 있어요');
      return;
    }

    state = state.copyWith(selectedInterests: currentInterests, error: null);
  }

  /// 알림 설정 업데이트
  void updateNotificationSettings(NotificationSettings settings) {
    HapticFeedback.selectionClick();
    state = state.copyWith(notificationSettings: settings, error: null);
  }

  /// 다음 단계로 이동
  void nextStep() {
    HapticFeedback.lightImpact();
    final currentIndex = state.currentStep.index;
    if (currentIndex < PersonalizationStep.values.length - 1) {
      final nextStep = PersonalizationStep.values[currentIndex + 1];
      state = state.copyWith(currentStep: nextStep, error: null);
    }
  }

  /// 이전 단계로 이동
  void previousStep() {
    HapticFeedback.selectionClick();
    final currentIndex = state.currentStep.index;
    if (currentIndex > 0) {
      final prevStep = PersonalizationStep.values[currentIndex - 1];
      state = state.copyWith(currentStep: prevStep, error: null);
    }
  }

  /// 개인화 완료
  Future<void> completePersonalization() async {
    if (!state.canComplete) {
      HapticFeedback.heavyImpact();
      state = state.copyWith(error: '필수 정보를 모두 입력해주세요');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // 🎯 개인화 데이터 저장 (모의 API 호출)
      await Future.delayed(const Duration(seconds: 1));

      // 🎉 온보딩 완료 상태 저장 (핵심!)
      final onboardingService = ref.read(onboardingServiceProvider);
      await onboardingService.setOnboardingCompleted();

      await _playSuccessHapticPattern();
      state = state.copyWith(isCompleted: true, isLoading: false);
    } catch (e) {
      HapticFeedback.heavyImpact();
      state = state.copyWith(
        error: '개인화 설정 저장 중 오류가 발생했습니다: $e',
        isLoading: false,
      );
    }
  }

  /// 에러 제거
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 성공 햅틱 패턴
  Future<void> _playSuccessHapticPattern() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }
}