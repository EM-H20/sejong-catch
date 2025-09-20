library;

/// 🌈 큐 상태 카드 (운영자 대시보드용)
///
/// 큐 기본 정보와 상태 변경 컨트롤을 제공하는 카드
/// Features:
/// ✅ 현재 대기자/최대 인원 표시
/// ✅ 상태별 시각적 표현 (색상 바)
/// ✅ 상태 변경 드롭다운 (활성/일시정지/마감/종료)
/// ✅ 실시간 통계 표시
/// ✅ ScreenUtil 반응형 적용

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/queue_model.dart';

class QueueStatusCard extends ConsumerWidget {
  final QueueModel queue;
  final ValueChanged<QueueStatus>? onStatusChanged;

  const QueueStatusCard({
    super.key,
    required this.queue,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🌈 상태 표시 바 (상단)
          _buildStatusBar(),

          // 📋 메인 컨텐츠
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // 🏷️ 헤더 (타입 + 제목)
                _buildHeader(),

                SizedBox(height: 16.h),

                // 📊 통계 영역
                _buildStatsRow(),

                SizedBox(height: 16.h),

                // 🎛️ 상태 변경 컨트롤
                _buildStatusControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🌈 상태 표시 바
  Widget _buildStatusBar() {
    Color statusColor;
    switch (queue.status) {
      case QueueStatus.active:
        statusColor = AppColors.success;
        break;
      case QueueStatus.paused:
        statusColor = AppColors.warning;
        break;
      case QueueStatus.full:
        statusColor = AppColors.error;
        break;
      case QueueStatus.closed:
        statusColor = Colors.grey;
        break;
    }

    return Container(
      height: 4.h,
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
    );
  }

  /// 🏷️ 헤더 (타입 아이콘 + 제목)
  Widget _buildHeader() {
    return Row(
      children: [
        // 타입별 아이콘
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: _getTypeColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            _getTypeIcon(),
            color: _getTypeColor(),
            size: 24.sp,
          ),
        ),

        SizedBox(width: 16.w),

        // 제목 & 위치
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                queue.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      queue.location,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 현재 상태 칩
        _buildCurrentStatusChip(),
      ],
    );
  }

  /// 📊 통계 행
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.people,
            label: '대기자',
            value: '${queue.currentCount}/${queue.maxCapacity}',
            color: AppColors.brandCrimson,
            progress: queue.currentCount / queue.maxCapacity.toDouble(),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatItem(
            icon: Icons.access_time,
            label: '평균 대기시간',
            value: '${queue.averageWaitTime}분',
            color: AppColors.warning,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatItem(
            icon: Icons.trending_up,
            label: '완료율',
            value: _calculateCompletionRate(),
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  /// 📊 개별 통계 아이템
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    double? progress,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          // 진행률 바 (선택적)
          if (progress != null) ...[
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3.h,
            ),
          ],
        ],
      ),
    );
  }

  /// 🎛️ 상태 변경 컨트롤
  Widget _buildStatusControl() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: AppColors.brandCrimson,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            '큐 상태:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: DropdownButton<QueueStatus>(
              value: queue.status,
              onChanged: (value) => value != null ? onStatusChanged?.call(value) : null,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: QueueStatus.values
                  .map(
                    (status) => DropdownMenuItem<QueueStatus>(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _getStatusDisplayName(status),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ 현재 상태 칩
  Widget _buildCurrentStatusChip() {
    final statusColor = _getStatusColor(queue.status);
    final statusText = _getStatusDisplayName(queue.status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 타입별 색상
  Color _getTypeColor() {
    switch (queue.type) {
      case QueueType.food:
        return Colors.orange;
      case QueueType.drink:
        return Colors.blue;
      case QueueType.event:
        return AppColors.brandCrimson;
      case QueueType.game:
        return Colors.green;
      case QueueType.photo:
        return Colors.purple;
      case QueueType.other:
        return Colors.grey;
    }
  }

  /// 🎯 타입별 아이콘
  IconData _getTypeIcon() {
    switch (queue.type) {
      case QueueType.food:
        return Icons.restaurant;
      case QueueType.drink:
        return Icons.local_drink;
      case QueueType.event:
        return Icons.event;
      case QueueType.game:
        return Icons.sports_esports;
      case QueueType.photo:
        return Icons.photo_camera;
      case QueueType.other:
        return Icons.more_horiz;
    }
  }

  /// 🎨 상태별 색상
  Color _getStatusColor(QueueStatus status) {
    switch (status) {
      case QueueStatus.active:
        return AppColors.success;
      case QueueStatus.paused:
        return AppColors.warning;
      case QueueStatus.full:
        return AppColors.error;
      case QueueStatus.closed:
        return Colors.grey;
    }
  }

  /// 🏷️ 상태 표시 이름
  String _getStatusDisplayName(QueueStatus status) {
    switch (status) {
      case QueueStatus.active:
        return '운영중';
      case QueueStatus.paused:
        return '일시정지';
      case QueueStatus.full:
        return '대기 마감';
      case QueueStatus.closed:
        return '운영 종료';
    }
  }

  /// 📈 완료율 계산 (간단한 예시)
  String _calculateCompletionRate() {
    // 실제로는 완료된 참가자 수 / 전체 처리된 참가자 수로 계산
    // 여기서는 대기자가 많을수록 높은 완료율로 임시 계산
    final rate = (queue.currentCount / queue.maxCapacity * 100).clamp(0, 100);
    return '${rate.toInt()}%';
  }
}