import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/text_styles.dart';
import '../../theme/app_shadows.dart';

/// 🎨 기능 소개 카드
///
/// Material elevation + 그라데이션 아이콘 배지 + 제목 + 설명으로 구성된 카드
/// 온보딩, 기능 소개, 서비스 안내 페이지에 활용
///
/// Features:
/// ✅ 그라데이션 아이콘 배지 내장
/// ✅ Material elevation 지원
/// ✅ 탭 제스처 지원 (선택적)
/// ✅ 커스텀 그라데이션 색상 지원
/// ✅ AppSpacing, AppTextStyles, AppShadows 사용
///
/// Usage:
/// ```dart
/// FeatureCard(
///   icon: Icons.emoji_events_rounded,
///   title: '정보 통합',
///   description: '공모전·취업·논문을 한눈에 확인하고\n중복 없이 깔끔하게 정리돼요',
/// )
///
/// FeatureCard(
///   icon: Icons.filter_list_rounded,
///   title: '스마트 필터링',
///   description: '학과와 관심사 기반으로...',
///   gradientColors: [Colors.purple, Colors.deepPurple],
///   onTap: () => print('Tapped!'),
/// )
/// ```
class FeatureCard extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 카드 제목
  final String title;

  /// 카드 설명
  final String description;

  /// 그라데이션 색상 리스트 (null이면 기본 brandCrimson 그라데이션)
  final List<Color>? gradientColors;

  /// Material elevation 높이 (기본 4)
  final double elevation;

  /// 탭 이벤트 핸들러 (선택적)
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.gradientColors,
    this.elevation = 4,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ?? [AppColors.brandCrimson, AppColors.brandCrimsonDark];

    final card = Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(20.r),
      shadowColor: AppColors.brandCrimson.withValues(alpha: 0.2),
      child: Container(
        padding: AppSpacing.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.brandCrimsonLight, width: 2),
        ),
        child: Row(
          children: [
            // 그라데이션 아이콘 배지
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: AppShadows.custom(
                  color: colors.first,
                  blurRadius: 10,
                  offset: Offset(0, 5.h),
                  alpha: 0.3,
                ),
              ),
              child: Icon(icon, size: 32.sp, color: AppColors.white),
            ),
            AppSpacing.horizontalSpaceLG,

            // 텍스트 영역
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
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // 탭 이벤트가 있으면 InkWell로 감싸기
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: card,
      );
    }

    return card;
  }
}
