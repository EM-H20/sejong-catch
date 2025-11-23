import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/queue_item.dart';
import 'queue_stat_item.dart';

/// 📇 큐 카드 위젯
///
/// 큐 정보를 보여주는 카드 컴포넌트입니다.
/// - 큐 이름, 상태 배지
/// - 대기 인원, 예상 시간, 현재 순번 통계
/// - 활성 상태일 경우 "줄서기" 버튼
///
/// **디자인 토큰 100% 사용!**
class QueueCard extends StatelessWidget {
  final QueueItem queue;
  final VoidCallback onTap;

  const QueueCard({
    super.key,
    required this.queue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = queue.status == 'active';

    // 상태별 색상/텍스트 결정 (비즈니스 로직 분리!)
    final (statusColor, statusText) = _getStatusInfo();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.basic,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (이름 + 상태)
            _buildHeader(statusColor, statusText),

            AppSpacing.verticalSpaceLG,

            // 통계 정보
            _buildStats(),

            if (isActive) ...[
              AppSpacing.verticalSpaceLG,
              _buildJoinButton(),
            ],
          ],
        ),
      ),
    );
  }

  /// 상태 정보 반환 (색상, 텍스트)
  (Color, String) _getStatusInfo() {
    switch (queue.status) {
      case 'active':
        return (AppColors.success, '운영중');
      case 'paused':
        return (AppColors.warning, '일시정지');
      default:
        return (AppColors.error, '마감');
    }
  }

  Widget _buildHeader(Color statusColor, String statusText) {
    return Row(
      children: [
        Text(queue.name, style: AppTextStyles.titleSemiBold18),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            statusText,
            style: AppTextStyles.captionBold12.copyWith(color: statusColor),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        QueueStatItem(
          icon: Icons.people_outline,
          label: '대기',
          value: '${queue.waiting}명',
          color: AppColors.trustAcademic,
        ),
        AppSpacing.horizontalSpaceLG,
        QueueStatItem(
          icon: Icons.timer_outlined,
          label: '예상',
          value: '${queue.avgWaitTime}분',
          color: AppColors.queueTimer,
        ),
        AppSpacing.horizontalSpaceLG,
        QueueStatItem(
          icon: Icons.confirmation_number_outlined,
          label: '현재',
          value: '#${queue.currentNumber}',
          color: AppColors.brandCrimson,
        ),
      ],
    );
  }

  Widget _buildJoinButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandCrimson,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Text(
          '줄서기',
          style: AppTextStyles.buttonSemiBold15.copyWith(
            color: AppColors.pureWhite,
          ),
        ),
      ),
    );
  }
}
