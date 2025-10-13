import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/services/onboarding_service.dart';

/// 세종 캐치 온보딩 화면 (심플한 원페이지)
///
/// 로그인/게스트 로그인 후 1회 표시
/// 시작하기 버튼 클릭 → SharedPreferences 저장 → 피드로 이동
class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    final onboardingService = OnboardingService();
    await onboardingService.markOnboardingComplete();
    if (context.mounted) {
      context.go('/feed');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPaddingLarge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // 🎓 로고
              Center(
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.brandCrimsonLight,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.school,
                    size: 64.sp,
                    color: AppColors.brandCrimson,
                  ),
                ),
              ),
              AppSpacing.verticalSpaceHuge,

              // 🎯 앱 타이틀
              Text(
                '세종 캐치',
                style: AppTextStyles.display2.copyWith(
                  color: AppColors.brandCrimson,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalSpaceMD,

              // 📝 서브 타이틀
              Text(
                '세종인을 위한 올인원 정보 허브',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalSpaceXXL,

              // ✨ 주요 기능 (간결하게)
              _buildFeatureRow(Icons.emoji_events, '공모전·취업·논문 한 곳에서'),
              AppSpacing.verticalSpaceLG,
              _buildFeatureRow(Icons.filter_alt, '맞춤형 추천 & 스마트 필터링'),
              AppSpacing.verticalSpaceLG,
              _buildFeatureRow(Icons.people, '축제 줄서기 & 실시간 알림'),

              const Spacer(flex: 2),

              // 🚀 시작하기 버튼
              SizedBox(
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () => _completeOnboarding(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandCrimson,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '시작하기',
                        style: AppTextStyles.button.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.horizontalSpaceSM,
                      Icon(Icons.arrow_forward, size: 24.sp),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalSpaceXL,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.brandCrimsonLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppColors.brandCrimson,
            size: 24.sp,
          ),
        ),
        AppSpacing.horizontalSpaceLG,
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
