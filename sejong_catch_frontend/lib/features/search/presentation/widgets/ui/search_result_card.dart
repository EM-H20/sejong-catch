import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_spacing.dart';

/// 📇 검색 결과 카드
///
/// CLAUDE.md 원칙:
/// ✅ DRY 원칙 - 재사용 가능한 독립 컴포넌트
/// ✅ AppColors, AppSpacing, AppShadows 100% 사용
/// ✅ ScreenUtil (.w, .h, .sp, .r) 필수
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({required this.title, required this.onTap, super.key});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.medium,
        ),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 24.sp,
              color: AppColors.brandCrimson,
            ),
            AppSpacing.horizontalSpaceMD,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.disabled,
            ),
          ],
        ),
      ),
    );
  }
}
