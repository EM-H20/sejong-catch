/// 🙋‍♂️ 참가자 목록 아이템
///
/// 큐 관리에서 사용하는 참가자 개별 정보 위젯
/// Features:
/// ✅ 상태별 색상 표시 (대기/호출/서비스중/완료/취소)
/// ✅ 대기시간 실시간 계산
/// ✅ 운영자 액션 버튼 (호출/완료/취소)
/// ✅ 호출 만료 알림
/// ✅ ScreenUtil 반응형 적용
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/participant_model.dart';

class ParticipantListItem extends ConsumerWidget {
  final ParticipantModel participant;
  final bool isOperatorMode;
  final VoidCallback? onCall;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const ParticipantListItem({
    super.key,
    required this.participant,
    this.isOperatorMode = false,
    this.onCall,
    this.onComplete,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _getBorderColor(), width: 1.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // 🎯 순번 & 상태
            _buildPositionBadge(),

            SizedBox(width: 16.w),

            // 👤 사용자 정보
            Expanded(child: _buildUserInfo()),

            SizedBox(width: 12.w),

            // ⏰ 대기시간 정보
            _buildTimeInfo(),

            if (isOperatorMode) ...[
              SizedBox(width: 12.w),
              // 🎛️ 운영자 액션 버튼
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  /// 🎯 순번 배지
  Widget _buildPositionBadge() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            participant.position.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '번',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// 👤 사용자 정보
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이름
        Text(
          participant.userName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),

        SizedBox(height: 4.h),

        // 상태 & 메모
        Row(
          children: [
            // 상태 칩
            _buildStatusChip(),

            if (participant.note != null && participant.note!.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  participant.note!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),

        // 호출 만료 경고
        if (participant.isCallExpired)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 14.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 4.w),
                Text(
                  '호출 시간 만료',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// ⏰ 시간 정보
  Widget _buildTimeInfo() {
    String timeText;
    IconData timeIcon;
    Color timeColor;

    switch (participant.status) {
      case ParticipantStatus.waiting:
        timeText = '${participant.waitingTimeMinutes}분 대기';
        timeIcon = Icons.access_time;
        timeColor = Colors.orange;
        break;
      case ParticipantStatus.called:
        final calledTime = participant.calledTimeMinutes ?? 0;
        timeText = '$calledTime분 전 호출';
        timeIcon = Icons.phone_callback;
        timeColor = participant.isCallExpired
            ? AppColors.error
            : AppColors.brandCrimson;
        break;
      case ParticipantStatus.serving:
        final serviceTime = participant.calledTimeMinutes ?? 0;
        timeText = '$serviceTime분 서비스중';
        timeIcon = Icons.schedule;
        timeColor = AppColors.success;
        break;
      case ParticipantStatus.completed:
        final duration = participant.serviceDurationMinutes ?? 0;
        timeText = '$duration분 소요';
        timeIcon = Icons.check_circle;
        timeColor = AppColors.success;
        break;
      case ParticipantStatus.cancelled:
        timeText = '취소됨';
        timeIcon = Icons.cancel;
        timeColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: timeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(timeIcon, size: 14.sp, color: timeColor),
          SizedBox(width: 4.w),
          Text(
            timeText,
            style: TextStyle(
              fontSize: 12.sp,
              color: timeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ 상태 칩
  Widget _buildStatusChip() {
    String statusText;
    Color chipColor;

    switch (participant.status) {
      case ParticipantStatus.waiting:
        statusText = '대기중';
        chipColor = Colors.orange;
        break;
      case ParticipantStatus.called:
        statusText = '호출됨';
        chipColor = AppColors.brandCrimson;
        break;
      case ParticipantStatus.serving:
        statusText = '서비스중';
        chipColor = AppColors.success;
        break;
      case ParticipantStatus.completed:
        statusText = '완료';
        chipColor = AppColors.success;
        break;
      case ParticipantStatus.cancelled:
        statusText = '취소';
        chipColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: chipColor,
        ),
      ),
    );
  }

  /// 🎛️ 운영자 액션 버튼들
  Widget _buildActionButtons() {
    List<Widget> buttons = [];

    if (participant.canBeCalled()) {
      // 호출 버튼
      buttons.add(
        _buildActionButton(
          icon: Icons.phone,
          label: '호출',
          color: AppColors.brandCrimson,
          onPressed: onCall,
        ),
      );
    }

    if (participant.canBeCompleted()) {
      // 완료 버튼
      buttons.add(
        _buildActionButton(
          icon: Icons.check,
          label: '완료',
          color: AppColors.success,
          onPressed: onComplete,
        ),
      );
    }

    if (participant.canBeCancelled()) {
      // 취소 버튼
      buttons.add(
        _buildActionButton(
          icon: Icons.close,
          label: '취소',
          color: AppColors.error,
          onPressed: onCancel,
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(mainAxisSize: MainAxisSize.min, children: buttons);
  }

  /// 🎯 개별 액션 버튼
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: IconButton(
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.1),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          icon: Icon(icon, size: 16.sp, color: color),
          tooltip: label,
        ),
      ),
    );
  }

  /// 🎨 상태별 색상
  Color _getStatusColor() {
    switch (participant.status) {
      case ParticipantStatus.waiting:
        return Colors.orange;
      case ParticipantStatus.called:
        return participant.isCallExpired
            ? AppColors.error
            : AppColors.brandCrimson;
      case ParticipantStatus.serving:
        return AppColors.success;
      case ParticipantStatus.completed:
        return AppColors.success.withValues(alpha: 0.7);
      case ParticipantStatus.cancelled:
        return Colors.grey;
    }
  }

  /// 🎨 배경 색상
  Color _getBackgroundColor() {
    switch (participant.status) {
      case ParticipantStatus.waiting:
        return Colors.white;
      case ParticipantStatus.called:
        return participant.isCallExpired
            ? AppColors.error.withValues(alpha: 0.05)
            : AppColors.brandCrimsonLight.withValues(alpha: 0.3);
      case ParticipantStatus.serving:
        return AppColors.success.withValues(alpha: 0.05);
      case ParticipantStatus.completed:
      case ParticipantStatus.cancelled:
        return Colors.grey[50]!;
    }
  }

  /// 🎨 테두리 색상
  Color _getBorderColor() {
    switch (participant.status) {
      case ParticipantStatus.waiting:
        return Colors.orange.withValues(alpha: 0.3);
      case ParticipantStatus.called:
        return participant.isCallExpired
            ? AppColors.error.withValues(alpha: 0.3)
            : AppColors.brandCrimson.withValues(alpha: 0.3);
      case ParticipantStatus.serving:
        return AppColors.success.withValues(alpha: 0.3);
      case ParticipantStatus.completed:
      case ParticipantStatus.cancelled:
        return Colors.grey.withValues(alpha: 0.2);
    }
  }
}
