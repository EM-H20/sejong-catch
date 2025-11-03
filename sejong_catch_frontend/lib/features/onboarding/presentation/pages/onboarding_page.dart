import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/badges/gradient_circle_badge.dart';
import '../../../../core/widgets/badges/gradient_icon_badge.dart';
import '../../../../core/widgets/chips/gradient_chip.dart';
import '../../../../core/widgets/cards/feature_card.dart';
import '../../../../core/services/onboarding_service.dart';

/// 🎨 세종 캐치 온보딩 화면 (개선된 UI)
///
/// Toss 스타일의 모던하고 세련된 온보딩
/// 그라데이션, 카드, elevation을 활용한 입체적 디자인
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final onboardingService = OnboardingService();
    await onboardingService.markOnboardingComplete();
    if (mounted) {
      context.go('/feed'); // 온보딩 완료 → 피드 페이지로 이동
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 페이지 컨텐츠
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildHeroPage(),
                  _buildFeaturesPage(),
                  _buildBenefitsPage(),
                ],
              ),
            ),

            // 하단 인디케이터 + 버튼
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  // smooth_page_indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8.w,
                      dotHeight: 8.w,
                      expansionFactor: 4,
                      activeDotColor: AppColors.brandCrimson,
                      dotColor: AppColors.brandCrimsonLight,
                      spacing: 8.w,
                    ),
                  ),
                  AppSpacing.verticalSpaceXL,

                  // 다음/시작하기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: AppButton.primary(
                      text: _currentPage == 2 ? '지금 시작하기' : '다음',
                      onPressed: _nextPage,
                    ),
                  ),
                  AppSpacing.verticalSpaceMD,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌟 Page 1: Hero Introduction
  Widget _buildHeroPage() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.verticalSpaceHuge,

          // 큰 그라데이션 원형 배경 + 로고
          GradientCircleBadge(icon: Icons.school_rounded, size: 180.w),
          AppSpacing.verticalSpaceHuge,

          // 임팩트 타이틀
          Text(
            '세종 캐치',
            style: AppTextStyles.display1.copyWith(
              fontSize: 36.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.brandCrimson,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpaceMD,

          // 서브타이틀
          Text(
            '세종인을 위한\n올인원 정보 허브',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpaceLG,

          // 짧은 설명
          GradientChip(text: '공모전·취업·논문·학교공지를 한 곳에서'),
          AppSpacing.verticalSpaceHuge,
        ],
      ),
    );
  }

  /// 📚 Page 2: Features with Cards
  Widget _buildFeaturesPage() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.verticalSpaceXL,

          // 페이지 타이틀
          Text(
            '무엇을 할 수 있나요?',
            style: AppTextStyles.heading1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpaceXXL,

          // Feature Cards
          FeatureCard(
            icon: Icons.emoji_events_rounded,
            title: '정보 통합',
            description: '공모전·취업·논문을 한눈에 확인하고\n중복 없이 깔끔하게 정리돼요',
          ),
          AppSpacing.verticalSpaceLG,

          FeatureCard(
            icon: Icons.filter_list_rounded,
            title: '스마트 필터링',
            description: '학과와 관심사 기반으로\n딱 맞는 정보만 추천받아요',
            gradientColors: [
              AppColors.brandCrimson.withValues(alpha: 0.8),
              AppColors.brandCrimsonDark.withValues(alpha: 0.8),
            ],
          ),
          AppSpacing.verticalSpaceLG,

          FeatureCard(
            icon: Icons.verified_rounded,
            title: '신뢰도 표시',
            description: '출처별 신뢰도와 우선순위를\n한눈에 파악할 수 있어요',
            gradientColors: [
              AppColors.brandCrimson.withValues(alpha: 0.6),
              AppColors.brandCrimsonDark.withValues(alpha: 0.6),
            ],
          ),
          AppSpacing.verticalSpaceXL,
        ],
      ),
    );
  }

  /// 🎪 Page 3: Benefits + Strong CTA
  Widget _buildBenefitsPage() {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AppSpacing.verticalSpaceXXL,

          // 큰 아이콘
          GradientIconBadge(icon: Icons.celebration_rounded, size: 100.w),
          AppSpacing.verticalSpaceXXL,

          // 임팩트 메시지
          Text(
            '이제 정보 찾기가\n쉬워집니다',
            style: AppTextStyles.heading1.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpaceXXL,

          // 핵심 베네핏 리스트
          _buildBenefitItem(
            icon: Icons.access_time_rounded,
            title: '시간 절약',
            description: '여러 사이트를 돌아다닐 필요 없어요',
          ),
          AppSpacing.verticalSpaceLG,

          _buildBenefitItem(
            icon: Icons.notifications_active_rounded,
            title: '실시간 알림',
            description: '마감 임박 정보를 놓치지 않아요',
          ),
          AppSpacing.verticalSpaceLG,

          _buildBenefitItem(
            icon: Icons.people_rounded,
            title: '축제 줄서기',
            description: '부스 대기열 실시간 확인 & 알림',
          ),
          AppSpacing.verticalSpaceHuge,
        ],
      ),
    );
  }

  /// 🎁 Benefit Item
  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        GradientIconBadge(icon: icon, size: 56.w),
        AppSpacing.horizontalSpaceLG,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.verticalSpaceXS,
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
