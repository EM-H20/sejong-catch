import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../data/services/onboarding_service.dart';

part 'onboarding_controller.g.dart';

/// 온보딩 상태 모델
class OnboardingState {
  final int currentPageIndex;
  final bool isLoading;
  final String? error;

  const OnboardingState({
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.error,
  });

  OnboardingState copyWith({
    int? currentPageIndex,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingState &&
          runtimeType == other.runtimeType &&
          currentPageIndex == other.currentPageIndex &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode =>
      currentPageIndex.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'OnboardingState(currentPageIndex: $currentPageIndex, isLoading: $isLoading, error: $error)';
}

/// 온보딩 페이지 데이터
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String? imagePath;
  final IconData? icon;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.icon,
  });
}

/// 온보딩 컨트롤러 (Riverpod 3.0 패턴)
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  /// 온보딩 페이지 데이터 (3페이지)
  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: '세종캐치에 오신 것을\n환영합니다! 👋',
      subtitle: '세종대학교 학생들을 위한\n올인원 정보 허브',
      imagePath: 'assets/sejong-logo.png',
    ),
    OnboardingPageData(
      title: '모든 정보를\n한 곳에서 📚',
      subtitle: '공모전, 취업, 논문 정보를\n똑똑하게 모아드려요',
      icon: Icons.dashboard_rounded,
    ),
    OnboardingPageData(
      title: '지금 시작하고\n맞춤 정보를 받아보세요! 🚀',
      subtitle: '관심사에 맞는 정보만\n골라서 알림을 드릴게요',
      icon: Icons.notifications_active_rounded,
    ),
  ];

  /// 페이지 변경
  void setPage(int index) {
    if (index >= 0 && index < pages.length) {
      state = state.copyWith(currentPageIndex: index);
    }
  }

  /// 다음 페이지로 이동
  void nextPage() {
    if (state.currentPageIndex < pages.length - 1) {
      setPage(state.currentPageIndex + 1);
    }
  }

  /// 이전 페이지로 이동
  void previousPage() {
    if (state.currentPageIndex > 0) {
      setPage(state.currentPageIndex - 1);
    }
  }

  /// 온보딩 건너뛰기
  Future<void> skipOnboarding(BuildContext context) async {
    await _completeOnboarding(context);
  }

  /// 온보딩 시작하기 (마지막 페이지에서)
  Future<void> startApp(BuildContext context) async {
    await _completeOnboarding(context);
  }

  /// 온보딩 완료 처리
  Future<void> _completeOnboarding(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final service = ref.read(onboardingServiceProvider);
      await service.setOnboardingCompleted(force: true);

      // ✅ 성공적으로 완료되면 isLoading을 false로 변경
      state = state.copyWith(isLoading: false);

      if (context.mounted) {
        context.go(AppRoutes.feed);
      }
    } catch (e) {
      state = state.copyWith(
        error: '온보딩 완료 중 오류가 발생했습니다: $e',
        isLoading: false,
      );
    } finally {
      // 🛡️ 안전 장치: 어떤 경우에도 로딩 상태 해제
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// 현재 페이지가 마지막 페이지인지 확인
  bool get isLastPage => state.currentPageIndex == pages.length - 1;

  /// 현재 페이지가 첫 번째 페이지인지 확인
  bool get isFirstPage => state.currentPageIndex == 0;

  /// 전체 페이지 수
  int get totalPages => pages.length;

  /// 현재 페이지 데이터
  OnboardingPageData get currentPageData => pages[state.currentPageIndex];
}
