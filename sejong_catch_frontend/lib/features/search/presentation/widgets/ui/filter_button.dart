import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_spacing.dart';

/// 🎛️ 고급 필터 버튼
///
/// CLAUDE.md 원칙:
/// ✅ DRY 원칙 - 재사용 가능한 독립 컴포넌트
/// ✅ AppColors, AppSpacing, AppShadows 100% 사용
/// ✅ ScreenUtil (.w, .h, .sp, .r) 필수
class FilterButton extends StatelessWidget {
  const FilterButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.divider,
            width: 1.5,
          ),
          boxShadow: AppShadows.basic,
        ),
        child: Icon(
          Icons.tune,
          size: 20.sp,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
