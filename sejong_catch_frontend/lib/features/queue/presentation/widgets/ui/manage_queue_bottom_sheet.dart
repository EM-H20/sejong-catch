import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/queue_item.dart';
import '../../controllers/queue_controller.dart';

/// 🎛️ 큐 관리 바텀시트 (운영자 전용)
///
/// 운영자/관리자가 큐를 관리하는 바텀시트입니다.
/// - 📣 다음 대기자 호출 (메인 기능!)
/// - ⏸️ 일시정지 / ▶️ 재개
/// - 🛑 마감
/// - 🗑️ 삭제
///
/// **디자인 토큰 100% 사용!**
class ManageQueueBottomSheet extends ConsumerStatefulWidget {
  final QueueItem queue;

  const ManageQueueBottomSheet({
    super.key,
    required this.queue,
  });

  /// 바텀시트 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required QueueItem queue,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ManageQueueBottomSheet(queue: queue),
    );
  }

  @override
  ConsumerState<ManageQueueBottomSheet> createState() =>
      _ManageQueueBottomSheetState();
}

class _ManageQueueBottomSheetState
    extends ConsumerState<ManageQueueBottomSheet> {
  bool _isLoading = false;

  /// 📣 다음 대기자 호출
  Future<void> _handleCallNext() async {
    if (_isLoading || widget.queue.waiting <= 0) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(queueControllerProvider.notifier)
        .callNextInQueue(widget.queue.id);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '📣 ${widget.queue.currentNumber + 1}번 손님 호출! 대기 ${widget.queue.waiting - 1}명 남음',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('호출에 실패했어요'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// ⏸️ 일시정지 / ▶️ 재개 토글
  Future<void> _handleTogglePause() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final isPaused = widget.queue.status == 'paused';
    final success = isPaused
        ? await ref
            .read(queueControllerProvider.notifier)
            .resumeQueue(widget.queue.id)
        : await ref
            .read(queueControllerProvider.notifier)
            .pauseQueue(widget.queue.id);

    setState(() => _isLoading = false);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isPaused ? '▶️ 큐가 재개되었어요' : '⏸️ 큐가 일시정지되었어요'),
          backgroundColor: isPaused ? AppColors.success : AppColors.warning,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  /// 🛑 큐 마감
  Future<void> _handleClose() async {
    if (_isLoading) return;

    // 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('큐 마감'),
        content: Text('${widget.queue.name}을(를) 마감하시겠어요?\n새로운 대기자를 받지 않습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('마감', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(queueControllerProvider.notifier)
        .closeQueue(widget.queue.id);

    setState(() => _isLoading = false);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🛑 큐가 마감되었어요'),
          backgroundColor: AppColors.error,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  /// 🗑️ 큐 삭제
  Future<void> _handleDelete() async {
    if (_isLoading) return;

    // 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('큐 삭제'),
        content: Text('${widget.queue.name}을(를) 삭제하시겠어요?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('삭제', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(queueControllerProvider.notifier)
        .deleteQueue(widget.queue.id);

    setState(() => _isLoading = false);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ ${widget.queue.name}이(가) 삭제되었어요'),
          backgroundColor: AppColors.textSecondary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 실시간 큐 상태 구독
    final queueState = ref.watch(queueControllerProvider);
    final currentQueue = queueState.allQueues.firstWhere(
      (q) => q.id == widget.queue.id,
      orElse: () => widget.queue,
    );

    final isActive = currentQueue.status == 'active';
    final isPaused = currentQueue.status == 'paused';
    final isClosed = currentQueue.status == 'full';
    final canCallNext = isActive && currentQueue.waiting > 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.modalPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 드래그 핸들
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              AppSpacing.verticalSpaceLG,

              // 제목 + 상태 배지
              Row(
                children: [
                  Expanded(
                    child: Text(
                      currentQueue.name,
                      style: AppTextStyles.headingBold20,
                    ),
                  ),
                  _buildStatusBadge(currentQueue.status),
                ],
              ),

              AppSpacing.verticalSpaceMD,

              // 큐 정보 카드
              _buildInfoCard(currentQueue),

              AppSpacing.verticalSpaceXL,

              // 📣 다음 호출 버튼 (메인!)
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton.icon(
                  onPressed: canCallNext && !_isLoading ? _handleCallNext : null,
                  icon: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.pureWhite,
                          ),
                        )
                      : Icon(Icons.campaign_rounded, size: 24.sp),
                  label: Text(
                    canCallNext
                        ? '다음 손님 호출 (#${currentQueue.currentNumber + 1})'
                        : isClosed
                            ? '마감됨'
                            : isPaused
                                ? '일시정지됨'
                                : '대기자 없음',
                    style: AppTextStyles.buttonSemiBold16.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandCrimson,
                    disabledBackgroundColor:
                        AppColors.brandCrimson.withValues(alpha: 0.3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

              AppSpacing.verticalSpaceMD,

              // 관리 버튼들
              Row(
                children: [
                  // ⏸️ 일시정지 / ▶️ 재개
                  Expanded(
                    child: _buildActionButton(
                      icon: isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      label: isPaused ? '재개' : '일시정지',
                      color: isPaused ? AppColors.success : AppColors.warning,
                      onTap: isClosed ? null : _handleTogglePause,
                    ),
                  ),
                  AppSpacing.horizontalSpaceSM,
                  // 🛑 마감
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.block_rounded,
                      label: '마감',
                      color: AppColors.error,
                      onTap: isClosed ? null : _handleClose,
                    ),
                  ),
                  AppSpacing.horizontalSpaceSM,
                  // 🗑️ 삭제
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: '삭제',
                      color: AppColors.textSecondary,
                      onTap: _handleDelete,
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalSpaceMD,
            ],
          ),
        ),
      ),
    );
  }

  /// 상태 배지
  Widget _buildStatusBadge(String status) {
    final (color, text) = switch (status) {
      'active' => (AppColors.success, '운영중'),
      'paused' => (AppColors.warning, '일시정지'),
      _ => (AppColors.error, '마감'),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.captionBold12.copyWith(color: color),
      ),
    );
  }

  /// 정보 카드
  Widget _buildInfoCard(QueueItem queue) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.people_outline,
            label: '대기 인원',
            value: '${queue.waiting}명',
            color: AppColors.trustAcademic,
          ),
          Container(width: 1, height: 40.h, color: AppColors.divider),
          _buildInfoItem(
            icon: Icons.confirmation_number_outlined,
            label: '현재 순번',
            value: '#${queue.currentNumber}',
            color: AppColors.brandCrimson,
          ),
          Container(width: 1, height: 40.h, color: AppColors.divider),
          _buildInfoItem(
            icon: Icons.timer_outlined,
            label: '평균 대기',
            value: '${queue.avgWaitTime}분',
            color: AppColors.queueTimer,
          ),
        ],
      ),
    );
  }

  /// 정보 아이템
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
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
    );
  }

  /// 액션 버튼
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.background
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDisabled
                ? AppColors.divider
                : color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isDisabled ? AppColors.textTertiary : color,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTextStyles.captionMedium11.copyWith(
                color: isDisabled ? AppColors.textTertiary : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
