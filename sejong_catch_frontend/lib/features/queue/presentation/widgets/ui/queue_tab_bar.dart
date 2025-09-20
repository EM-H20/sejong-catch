import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// 📑 큐 관리 TabBar 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 TabBar 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class QueueTabBar extends StatelessWidget {
  const QueueTabBar({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 16.sp),
                SizedBox(width: 4.w),
                Text('대기자', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 16.sp),
                SizedBox(width: 4.w),
                Text('통계', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 16.sp),
                SizedBox(width: 4.w),
                Text('설정', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ],
        labelColor: AppColors.brandCrimson,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.brandCrimson,
        indicatorWeight: 2.h,
      ),
    );
  }
}