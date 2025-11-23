import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// 📊 큐 통계 아이템 위젯
///
/// 대기 인원, 예상 시간, 현재 순번 등의 통계를 표시합니다.
/// 재사용 가능한 작은 컴포넌트입니다.
class QueueStatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const QueueStatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20.sp, color: color),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.captionMedium11.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppTextStyles.bodyBold14.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
