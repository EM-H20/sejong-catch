import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../controllers/queue_manage_controller.dart';

/// ⚙️ 설정 탭 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 탭 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class SettingsTab extends ConsumerWidget {
  const SettingsTab({
    super.key,
    required this.queueId,
    required this.onShowCapacityDialog,
    required this.onShowServiceTimeDialog,
    required this.onShowClearQueueDialog,
  });

  final String queueId;
  final VoidCallback onShowCapacityDialog;
  final VoidCallback onShowServiceTimeDialog;
  final VoidCallback onShowClearQueueDialog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueManageControllerProvider(queueId));

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 큐 기본 설정
          _buildSettingsSection(
            '기본 설정',
            [
              _buildSettingsTile(
                '최대 대기자 수',
                '${state.selectedQueue?.maxCapacity ?? 0}명',
                Icons.people,
                onTap: onShowCapacityDialog,
              ),
              _buildSettingsTile(
                '평균 서비스 시간',
                '${state.selectedQueue?.averageWaitTime ?? 0}분',
                Icons.timer,
                onTap: onShowServiceTimeDialog,
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // 위험 영역
          _buildSettingsSection(
            '위험 영역',
            [
              _buildSettingsTile(
                '모든 대기자 취소',
                '큐를 초기화합니다',
                Icons.warning,
                isDestructive: true,
                onTap: onShowClearQueueDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ⚙️ 설정 섹션
  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// ⚙️ 설정 타일
  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
        size: 20.sp,
      ),
    );
  }
}