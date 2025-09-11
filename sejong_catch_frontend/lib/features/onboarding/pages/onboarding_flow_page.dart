import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Core imports
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/routes.dart';

// Controller imports
import '../../../domain/controllers/app_controller.dart';
import '../controllers/onboarding_controller.dart';

// Widget imports
import '../widgets/onboarding_intro_page.dart';
import '../widgets/onboarding_features_page.dart';
import '../widgets/onboarding_roles_page.dart';
import '../widgets/onboarding_personalize_page.dart';

/// 온보딩 플로우의 메인 페이지
///
/// 4단계 온보딩 과정을 PageView로 관리하며,
/// OnboardingController를 통해 상태를 관리합니다.
/// 건너뛰기, 이전/다음, 완료 기능을 모두 포함해요.
class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage>
    with TickerProviderStateMixin {
  // 애니메이션 컨트롤러들
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 초기화
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // 온보딩 임시 설정 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingController>().loadTempSettings();
    });

    // 페이지 진입 애니메이션 시작
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 그라데이션 배경
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.brandCrimson.withValues(alpha: 0.05),
              AppColors.white,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // 상단 헤더 (건너뛰기 버튼 + 진행률)
                  _buildHeader(),

                  // 페이지 인디케이터
                  _buildPageIndicator(),

                  SizedBox(height: 20.h),

                  // 메인 콘텐츠 (PageView)
                  Expanded(child: _buildPageView()),

                  // 하단 네비게이션 버튼들
                  _buildBottomNavigation(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 상단 헤더 (건너뛰기 버튼과 진행률)
  Widget _buildHeader() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 진행률 텍스트
              Text(
                '${controller.currentIndex + 1} / 4',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              // 건너뛰기 버튼
              TextButton(
                onPressed: _handleSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.brandCrimson,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  '건너뛰기',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 페이지 인디케이터
  Widget _buildPageIndicator() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SmoothPageIndicator(
            controller: controller.pageController,
            count: 4,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.brandCrimson,
              dotColor: AppColors.brandCrimson.withValues(alpha: 0.3),
              dotHeight: 8.h,
              dotWidth: 8.w,
              expansionFactor: 3,
              spacing: 8.w,
            ),
          ),
        );
      },
    );
  }

  /// 메인 PageView
  Widget _buildPageView() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: const [
            // 1단계: 앱 소개
            OnboardingIntroPage(),

            // 2단계: 기능 설명
            OnboardingFeaturesPage(),

            // 3단계: 역할 시스템
            OnboardingRolesPage(),

            // 4단계: 개인화 설정
            OnboardingPersonalizePage(),
          ],
        );
      },
    );
  }

  /// 하단 네비게이션 버튼들
  Widget _buildBottomNavigation() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              // 이전 버튼
              if (controller.canGoPrevious) ...[
                _buildNavButton(
                  text: '이전',
                  onPressed: controller.goToPrevious,
                  isSecondary: true,
                ),
                SizedBox(width: 12.w),
              ],

              // 공간 채우기
              const Spacer(),

              // 다음/완료 버튼
              _buildNavButton(
                text: controller.isLastStep ? '완료' : '다음',
                onPressed: controller.canGoNext ? _handleNext : null,
                isSecondary: false,
                isLoading: controller.isAnimating,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 네비게이션 버튼 생성
  Widget _buildNavButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isSecondary,
    bool isLoading = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48.h,
      constraints: BoxConstraints(minWidth: 100.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? AppColors.white
              : AppColors.brandCrimson,
          foregroundColor: isSecondary
              ? AppColors.brandCrimson
              : AppColors.white,
          side: isSecondary
              ? BorderSide(color: AppColors.brandCrimson, width: 1.w)
              : null,
          elevation: isSecondary ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: isSecondary ? AppColors.brandCrimson : AppColors.white,
                ),
              )
            : Text(
                text,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  /// 다음/완료 버튼 처리
  Future<void> _handleNext() async {
    final controller = context.read<OnboardingController>();

    if (controller.isLastStep) {
      // 마지막 단계에서 완료 처리
      await _completeOnboarding();
    } else {
      // 다음 단계로 이동
      await controller.goToNext();
    }
  }

  /// 온보딩 완료 처리
  Future<void> _completeOnboarding() async {
    try {
      final onboardingController = context.read<OnboardingController>();
      final appController = context.read<AppController>();

      // 온보딩 컨트롤러에서 완료 처리
      await onboardingController.completeOnboarding();

      // 수집된 설정을 AppController에 반영
      if (onboardingController.selectedDepartment != null) {
        await appController.setSelectedDepartment(
          onboardingController.selectedDepartment!.name,
        );
      }

      if (onboardingController.selectedInterests.isNotEmpty) {
        await appController.setInterests(
          onboardingController.selectedInterests,
        );
      }

      // 온보딩 완료 처리
      await appController.setOnboardingCompleted();

      // 메인 화면으로 이동
      if (mounted) {
        context.go(AppRoutes.feed);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('온보딩 완료 중 오류가 발생했습니다: $e');
      }
    }
  }

  /// 건너뛰기 처리
  Future<void> _handleSkip() async {
    final shouldSkip = await _showSkipDialog();
    if (!shouldSkip) return;

    try {
      final onboardingController = context.read<OnboardingController>();
      final appController = context.read<AppController>();

      // 건너뛰기 처리
      await onboardingController.skipOnboarding();
      await appController.setOnboardingCompleted();

      // 메인 화면으로 이동
      if (mounted) {
        context.go(AppRoutes.feed);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('건너뛰기 처리 중 오류가 발생했습니다: $e');
      }
    }
  }

  /// 건너뛰기 확인 다이얼로그
  Future<bool> _showSkipDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '온보딩을 건너뛸까요?',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          '나중에 설정에서 학과와 관심사를\n설정할 수 있어요.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              '계속하기',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '건너뛰기',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '오류 발생',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '확인',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
