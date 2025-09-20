import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../controllers/queue_manage_controller.dart';

/// 🎛️ 큐 관리 AppBar 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 AppBar 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class QueueManageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const QueueManageAppBar({
    super.key,
    required this.queueId,
  });

  final String queueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueManageControllerProvider(queueId));

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24.sp,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎛️ 큐 관리',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (state.selectedQueue != null)
            Text(
              state.selectedQueue!.title,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
      actions: [
        // 새로고침
        IconButton(
          onPressed: () => ref
              .read(queueManageControllerProvider(queueId).notifier)
              .refresh(),
          icon: Icon(
            Icons.refresh,
            color: AppColors.brandCrimson,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}