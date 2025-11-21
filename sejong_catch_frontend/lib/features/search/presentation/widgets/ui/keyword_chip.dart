import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_spacing.dart';

/// 🏷️ 키워드 칩 - 프로 디자인 버전!
///
/// CLAUDE.md 원칙:
/// ✅ DRY 원칙 - 재사용 가능한 독립 컴포넌트
/// ✅ AppColors, AppSpacing, AppShadows 100% 사용
/// ✅ ScreenUtil (.w, .h, .sp, .r) 필수
/// ✅ Top 3 랭킹 강조 UI
class KeywordChip extends StatelessWidget {
  const KeywordChip({
    required this.keyword,
    required this.rank,
    required this.onTap,
    super.key,
  });

  final String keyword;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTopRank = rank <= 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isTopRank ? AppColors.brandCrimsonLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isTopRank
                ? AppColors.brandCrimson.withValues(alpha: 0.3)
                : AppColors.divider,
          ),
          boxShadow: AppShadows.basic,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 랭킹 배지
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: isTopRank ? AppColors.brandCrimson : AppColors.disabled,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalSpaceSM,
            // 키워드 텍스트
            Text(
              keyword,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
