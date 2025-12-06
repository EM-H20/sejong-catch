import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/booth.dart';
import 'queue_stat_item.dart';

/// 📇 부스 카드 위젯
///
/// 부스 정보를 보여주는 카드 컴포넌트입니다.
/// - 부스 이름, 마스터(타입) 이름, 상태 배지
/// - 좌석 수, 예상 대기 시간 통계
/// - 운영 중일 경우 "줄서기" 버튼
///
/// **API 모델: CatchBoothObject**
/// **디자인 토큰 100% 사용!**
class QueueCard extends StatelessWidget {
  final Booth booth;
  final VoidCallback onTap;
  final int? waitingCount; // 대기 인원 (옵션)
  final String? masterName; // 부스 타입(마스터) 이름

  const QueueCard({
    super.key,
    required this.booth,
    required this.onTap,
    this.waitingCount,
    this.masterName,
  });

  @override
  Widget build(BuildContext context) {
    final isOperating = booth.status == 'OPERATING';

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

            if (isOperating) ...[
              AppSpacing.verticalSpaceLG,
              _buildJoinButton(),
            ],
          ],
        ),
      ),
    );
  }

  /// 상태 정보 반환 (색상, 텍스트)
  /// API status: PREPARING | OPERATING | ENDED
  (Color, String) _getStatusInfo() {
    switch (booth.status) {
      case 'OPERATING':
        return (AppColors.success, '운영중');
      case 'PREPARING':
        return (AppColors.warning, '준비중');
      case 'ENDED':
        return (AppColors.error, '종료');
      default:
        return (AppColors.textSecondary, '알 수 없음');
    }
  }

  Widget _buildHeader(Color statusColor, String statusText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booth.title, style: AppTextStyles.titleSemiBold18),
              if (masterName != null) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      masterName!,
                      style: AppTextStyles.captionMedium11.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
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
          icon: Icons.event_seat_outlined,
          label: '좌석',
          value: '${booth.seatCount}석',
          color: AppColors.trustAcademic,
        ),
        AppSpacing.horizontalSpaceLG,
        QueueStatItem(
          icon: Icons.timer_outlined,
          label: '예상',
          value: '${booth.avgWaitMinutes}분',
          color: AppColors.queueTimer,
        ),
        if (waitingCount != null) ...[
          AppSpacing.horizontalSpaceLG,
          QueueStatItem(
            icon: Icons.people_outline,
            label: '대기',
            value: '$waitingCount명',
            color: AppColors.brandCrimson,
          ),
        ],
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
