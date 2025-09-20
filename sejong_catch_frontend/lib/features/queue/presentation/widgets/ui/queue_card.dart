/// 🎪 큐 카드 컴포넌트
///
/// 축제/이벤트 큐를 표시하는 재사용 가능한 카드 위젯
/// Features:
/// ✅ 대기자 수 & 대기시간 실시간 표시
/// ✅ 상태별 색상 표시 (활성/일시정지/마감/종료)
/// ✅ 타입별 아이콘 (음식/음료/이벤트/게임/포토존)
/// ✅ 참여 버튼 상태 관리
/// ✅ ScreenUtil 반응형 적용
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/queue_model.dart';
import '../../../data/models/participant_model.dart';

class QueueCard extends ConsumerWidget {
  final QueueModel queue;
  final bool isJoined;
  final ParticipantModel? myParticipation;
  final VoidCallback? onTap;
  final VoidCallback? onJoinQueue;
  final VoidCallback? onLeaveQueue;

  const QueueCard({
    super.key,
    required this.queue,
    this.isJoined = false,
    this.myParticipation,
    this.onTap,
    this.onJoinQueue,
    this.onLeaveQueue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // 🌈 상태 표시 바
            _buildStatusBar(),

            // 📋 메인 컨텐츠
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🏷️ 헤더 (타입 아이콘 + 제목)
                  _buildHeader(),

                  SizedBox(height: 8.h),

                  // 📍 위치 정보
                  _buildLocation(),

                  SizedBox(height: 12.h),

                  // 📊 대기 정보 & 버튼
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🌈 상태 표시 바 (상단 컬러바)
  Widget _buildStatusBar() {
    Color statusColor;
    switch (queue.status) {
      case QueueStatus.active:
        statusColor = AppColors.brandCrimson;
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
      height: 3.h,
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
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
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 20.sp),
        ),

        SizedBox(width: 12.w),

        // 제목 & 상태 칩
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                queue.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4.h),

              // 상태 칩
              _buildStatusChip(),
            ],
          ),
        ),

        // 내 순번 표시 (참여 중일 때)
        if (isJoined && myParticipation != null) _buildMyPosition(),
      ],
    );
  }

  /// 📍 위치 정보
  Widget _buildLocation() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 16.sp, color: Colors.grey[600]),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            queue.location,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 📊 하단 영역 (대기 정보 + 버튼)
  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // 대기 정보
        Expanded(
          child: Row(
            children: [
              // 대기자 수
              _buildInfoChip(
                Icons.people_outline,
                '${queue.currentCount}/${queue.maxCapacity}',
                AppColors.brandCrimson,
              ),

              SizedBox(width: 8.w),

              // 평균 대기시간
              _buildInfoChip(
                Icons.access_time,
                '${queue.averageWaitTime}분',
                AppColors.warning,
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // 액션 버튼
        _buildActionButton(context),
      ],
    );
  }

  /// 🏷️ 상태 칩
  Widget _buildStatusChip() {
    String statusText;
    Color chipColor;

    switch (queue.status) {
      case QueueStatus.active:
        statusText = '운영중';
        chipColor = AppColors.success;
        break;
      case QueueStatus.paused:
        statusText = '일시정지';
        chipColor = AppColors.warning;
        break;
      case QueueStatus.full:
        statusText = '대기 마감';
        chipColor = AppColors.error;
        break;
      case QueueStatus.closed:
        statusText = '운영 종료';
        chipColor = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: chipColor,
        ),
      ),
    );
  }

  /// 🎯 내 순번 표시
  Widget _buildMyPosition() {
    if (myParticipation == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            '내 순번',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.brandCrimsonDark,
            ),
          ),
          Text(
            '${myParticipation!.position}번',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.brandCrimson,
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 정보 칩 (대기자 수, 대기시간)
  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎬 액션 버튼
  Widget _buildActionButton(BuildContext context) {
    if (isJoined && myParticipation != null) {
      // 이미 참여 중인 경우
      return ElevatedButton(
        onPressed: onLeaveQueue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.grey[700],
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Text(
          '취소하기',
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      );
    }

    if (queue.status == QueueStatus.full ||
        queue.status == QueueStatus.closed) {
      // 참여 불가능한 경우
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          queue.status == QueueStatus.full ? '대기 마감' : '운영 종료',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // 참여 가능한 경우
    return ElevatedButton(
      onPressed: onJoinQueue,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandCrimson,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        '줄서기',
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
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
}
