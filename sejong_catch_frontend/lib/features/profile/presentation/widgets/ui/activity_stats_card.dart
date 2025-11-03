import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';

/// 📊 활동 통계 카드 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 UI 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class ActivityStatsCard extends StatelessWidget {
  const ActivityStatsCard({
    super.key,
    this.bookmarkCount = 0,
    this.completedCount = 0,
    this.pendingCount = 0,
  });

  final int bookmarkCount;
  final int completedCount;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 나의 활동',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),

            AppSpacing.verticalSpaceLG,

            Row(
              children: [
                _buildStatItem('북마크', bookmarkCount.toString(), Icons.bookmark),
                AppSpacing.horizontalSpaceXXL,
                _buildStatItem('지원완료', completedCount.toString(), Icons.check_circle),
                AppSpacing.horizontalSpaceXXL,
                _buildStatItem('대기중', pendingCount.toString(), Icons.access_time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 통계 아이템
  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24.r, color: AppColors.brandCrimson),
        AppSpacing.verticalSpaceSM,
        Text(
          count,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.brandCrimson,
          ),
        ),
        AppSpacing.verticalSpaceXS,
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}