import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

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
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 나의 활동',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                _buildStatItem('북마크', bookmarkCount.toString(), Icons.bookmark),
                SizedBox(width: 24.w),
                _buildStatItem('지원완료', completedCount.toString(), Icons.check_circle),
                SizedBox(width: 24.w),
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
        SizedBox(height: 8.h),
        Text(
          count,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.brandCrimson,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}