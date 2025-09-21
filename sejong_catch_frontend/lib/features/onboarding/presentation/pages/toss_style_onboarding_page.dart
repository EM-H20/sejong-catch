import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/config/app_routes.dart';
import '../../data/services/onboarding_service.dart';
import '../widgets/slides/problem_slide.dart';
import '../widgets/slides/solution_slide.dart';
import '../widgets/slides/welcome_slide.dart';

/// 🚀 Toss-Style 새로운 온보딩 페이지
/// 3단계 진행: 문제공감 → 솔루션제시 → 시작하기 (학과선택 제거!)
class TossStyleOnboardingPage extends StatefulWidget {
  const TossStyleOnboardingPage({super.key});

  @override
  State<TossStyleOnboardingPage> createState() =>
      _TossStyleOnboardingPageState();
}

class _TossStyleOnboardingPageState extends State<TossStyleOnboardingPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: "공감",
      subtitle: "이런 경험 있으신가요?",
      icon: Icons.sentiment_satisfied_alt,
    ),
    OnboardingStep(
      title: "솔루션",
      subtitle: "세종 캐치가 해결해드려요",
      icon: Icons.auto_awesome,
    ),
    OnboardingStep(
      title: "시작하기",
      subtitle: "세종인을 위한 정보 허브",
      icon: Icons.rocket_launch,
    ),
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 상단 프로그레스 및 스킵 버튼
            _buildTopBar(),

            // 📱 메인 콘텐츠 영역
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  // 1️⃣ 문제 공감 슬라이드
                  const ProblemSlide(),

                  // 2️⃣ 솔루션 제시 슬라이드
                  const SolutionSlide(),

                  // 3️⃣ 환영 메시지 슬라이드 (학과 선택 제거!)
                  const WelcomeSlide(),
                ],
              ),
            ),

            // 🔻 하단 네비게이션
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  /// 🔝 상단 점형태 인디케이터 및 스킵 버튼
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          // 점형태 페이지 인디케이터
          Expanded(
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _steps.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: const Color(0xFFDC143C), // 크림슨 레드
                  dotColor: const Color(0xFFE5E7EB), // 비활성 회색
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  expansionFactor: 3,
                  spacing: 8.w,
                ),
              ).animate().fadeIn(
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// 🔻 하단 네비게이션 (버튼 영역)
  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 현재 단계 정보
          _buildCurrentStepInfo(),

          SizedBox(height: 20.h),

          // 네비게이션 버튼들
          Row(
            children: [
              // 이전 버튼
              if (_currentPage > 0)
                Expanded(
                  flex: 1,
                  child: _buildNavButton(
                    text: "이전",
                    isSecondary: true,
                    onPressed: _previousPage,
                  ),
                ),

              if (_currentPage > 0) SizedBox(width: 12.w),

              // 다음/완료 버튼
              Expanded(
                flex: _currentPage > 0 ? 2 : 1,
                child: _buildNavButton(
                  text: _getNextButtonText(),
                  isSecondary: false,
                  isEnabled: true, // 항상 진행 가능!
                  isLoading: _isLoading,
                  onPressed: _nextPageOrComplete,
                ),
              ),
            ],
          ),

          // 에러 메시지 제거 (단순화!)
        ],
      ),
    );
  }

  Widget _buildCurrentStepInfo() {
    final currentStep = _steps[_currentPage];

    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: const Color(0xFFDC143C).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            currentStep.icon,
            color: const Color(0xFFDC143C),
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentStep.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                currentStep.subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String text,
    required bool isSecondary,
    bool isEnabled = true,
    bool isLoading = false,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isEnabled && !isLoading ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: isSecondary
              ? Colors.white
              : (isEnabled ? const Color(0xFFDC143C) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12.r),
          border: isSecondary
              ? Border.all(color: const Color(0xFFE5E7EB), width: 1.5)
              : null,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isSecondary
                        ? const Color(0xFF374151)
                        : (isEnabled ? Colors.white : const Color(0xFF9CA3AF)),
                  ),
                ),
        ),
      ),
    );
  }

  // ============================================
  // 네비게이션 로직
  // ============================================

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPageOrComplete() async {
    if (_currentPage < _steps.length - 1) {
      // 다음 페이지로
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 온보딩 완료 (단순화!)
      if (mounted) {
        setState(() {
          _isLoading = true;
        });

        // 온보딩 완료 상태 저장
        try {
          // 🎉 온보딩 완료 상태 저장 (핵심!)
          final container = ProviderScope.containerOf(context);
          final onboardingService = container.read(onboardingServiceProvider);
          await onboardingService.setOnboardingCompleted();

          // 성공 후 피드 페이지로 이동
          if (mounted) {
            context.go(AppRoutes.feed);
          }
        } catch (e) {
          // 에러 발생시에도 일단 진행 (UX 우선)
          if (mounted) {
            context.go(AppRoutes.feed);
          }
        }
      }
    }
  }


  // ============================================
  // 유틸리티 메서드
  // ============================================

  String _getNextButtonText() {
    if (_currentPage < 2) {
      return "다음";
    } else {
      return "시작하기";
    }
  }
}

/// 온보딩 단계 정보 모델
class OnboardingStep {
  final String title;
  final String subtitle;
  final IconData icon;

  const OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
