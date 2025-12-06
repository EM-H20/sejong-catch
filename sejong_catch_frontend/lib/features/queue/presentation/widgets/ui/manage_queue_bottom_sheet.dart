import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/booth.dart';
import '../../controllers/queue_controller.dart';

/// 🎛️ 부스 관리 바텀시트 (운영자 전용)
///
/// 운영자/관리자가 부스를 관리하는 바텀시트입니다.
/// - 📣 다음 대기자 호출 (rotate 기능!)
/// - 🎫 나도 줄서기 (관리자도 줄 설 수 있음!)
/// - ⏸️ 준비중 / ▶️ 운영중 상태 변경
/// - 🛑 종료
///
/// **API 모델: Booth**
/// **디자인 토큰 100% 사용!**
class ManageQueueBottomSheet extends ConsumerStatefulWidget {
  final Booth booth;
  final VoidCallback? onJoinQueue;

  const ManageQueueBottomSheet({
    super.key,
    required this.booth,
    this.onJoinQueue,
  });

  /// 바텀시트 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required Booth booth,
    VoidCallback? onJoinQueue,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ManageQueueBottomSheet(booth: booth, onJoinQueue: onJoinQueue),
    );
  }

  @override
  ConsumerState<ManageQueueBottomSheet> createState() =>
      _ManageQueueBottomSheetState();
}

class _ManageQueueBottomSheetState
    extends ConsumerState<ManageQueueBottomSheet> {
  bool _isLoading = false;

  /// 📣 다음 팀 입장 (rotate)
  Future<void> _handleRotate() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(queueControllerProvider.notifier)
        .rotateQueue(widget.booth.id);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📣 다음 팀이 입장합니다!'),
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

  /// 상태 변경 (PREPARING <-> OPERATING <-> ENDED)
  Future<void> _handleStatusChange(String newStatus) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(queueControllerProvider.notifier)
        .updateBoothStatus(widget.booth.id, newStatus);

    setState(() => _isLoading = false);

    if (mounted && success) {
      final statusText = switch (newStatus) {
        'OPERATING' => '▶️ 부스가 운영을 시작합니다!',
        'PREPARING' => '⏸️ 부스가 준비 중으로 변경되었어요',
        'ENDED' => '🛑 부스 운영이 종료되었어요',
        _ => '상태가 변경되었어요',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(statusText),
          backgroundColor: newStatus == 'OPERATING'
              ? AppColors.success
              : newStatus == 'ENDED'
              ? AppColors.error
              : AppColors.warning,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 실시간 부스 상태 구독
    final queueState = ref.watch(queueControllerProvider);
    final currentBooth = queueState.booths.firstWhere(
      (b) => b.id == widget.booth.id,
      orElse: () => widget.booth,
    );

    final isOperating = currentBooth.status == 'OPERATING';
    final isPreparing = currentBooth.status == 'PREPARING';
    final isEnded = currentBooth.status == 'ENDED';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
                      currentBooth.title,
                      style: AppTextStyles.headingBold20,
                    ),
                  ),
                  _buildStatusBadge(currentBooth.status),
                ],
              ),

              AppSpacing.verticalSpaceMD,

              // 부스 정보 카드
              _buildInfoCard(currentBooth),

              AppSpacing.verticalSpaceXL,

              // 📣 다음 호출 버튼 (운영 중일 때만!)
              if (isOperating) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleRotate,
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
                      '다음 팀 입장',
                      style: AppTextStyles.buttonSemiBold16.copyWith(
                        color: AppColors.pureWhite,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandCrimson,
                      disabledBackgroundColor: AppColors.brandCrimson
                          .withValues(alpha: 0.3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                AppSpacing.verticalSpaceSM,

                // 🎫 나도 줄서기 버튼 (관리자도 줄 설 수 있음!)
                if (widget.onJoinQueue != null)
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              widget.onJoinQueue?.call();
                            },
                      icon: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 20.sp,
                        color: AppColors.brandCrimson,
                      ),
                      label: Text(
                        '나도 줄서기',
                        style: AppTextStyles.buttonMedium15.copyWith(
                          color: AppColors.brandCrimson,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.brandCrimson.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                AppSpacing.verticalSpaceMD,
              ],

              // 관리 버튼들
              Row(
                children: [
                  // 준비중 버튼 (운영중 → 준비중)
                  if (isOperating)
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.pause_rounded,
                        label: '준비중',
                        color: AppColors.warning,
                        onTap: () => _handleStatusChange('PREPARING'),
                      ),
                    ),

                  // 운영 시작 버튼 (준비중 → 운영중)
                  if (isPreparing)
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.play_arrow_rounded,
                        label: '운영 시작',
                        color: AppColors.success,
                        onTap: () => _handleStatusChange('OPERATING'),
                      ),
                    ),

                  if (!isEnded) ...[
                    AppSpacing.horizontalSpaceSM,
                    // 🛑 종료
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.block_rounded,
                        label: '종료',
                        color: AppColors.error,
                        onTap: () => _handleStatusChange('ENDED'),
                      ),
                    ),
                  ],

                  // 종료된 상태에서는 다시 준비중으로
                  if (isEnded)
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.refresh_rounded,
                        label: '다시 준비',
                        color: AppColors.success,
                        onTap: () => _handleStatusChange('PREPARING'),
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
      'OPERATING' => (AppColors.success, '운영중'),
      'PREPARING' => (AppColors.warning, '준비중'),
      'ENDED' => (AppColors.error, '종료'),
      _ => (AppColors.textSecondary, '알 수 없음'),
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
  Widget _buildInfoCard(Booth booth) {
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
            icon: Icons.event_seat_outlined,
            label: '좌석 수',
            value: '${booth.seatCount}석',
            color: AppColors.trustAcademic,
          ),
          Container(width: 1, height: 40.h, color: AppColors.divider),
          _buildInfoItem(
            icon: Icons.timer_outlined,
            label: '평균 대기',
            value: '${booth.avgWaitMinutes}분',
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
