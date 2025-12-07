import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/my_queue_status.dart';
import '../../../data/models/response/booth.dart';

/// 🎫 내 대기 상태 카드 위젯
///
/// 내가 참여한 큐의 정보를 보여주는 크림슨 그라디언트 카드입니다.
/// - 부스 이름, 마스터(타입) 이름
/// - 내 티켓 번호 (크게 강조!)
/// - 내 앞 대기 인원, 현재 상태
/// - 줄서기 포기 버튼
///
/// **API 모델: MyQueueStatus**
/// **디자인 토큰 100% 사용!**
class MyQueueCard extends StatelessWidget {
  final MyQueueStatus myStatus;
  final Booth? booth; // 부스 정보 (제목 표시용)
  final VoidCallback onCancel;
  final String? masterName; // 부스 타입(마스터) 이름

  const MyQueueCard({
    super.key,
    required this.myStatus,
    this.booth,
    required this.onCancel,
    this.masterName,
  });

  @override
  Widget build(BuildContext context) {
    // 상태별 색상 결정
    final (statusColor, statusText) = _getStatusInfo();

    return Container(
      padding: AppSpacing.modalPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandCrimson, AppColors.brandCrimsonDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandCrimson.withValues(alpha: 0.4),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 부스 이름 + 마스터 타입 + 상태
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booth?.title ?? '부스',
                      style: AppTextStyles.headingBold22.copyWith(
                        color: AppColors.pureWhite,
                      ),
                    ),
                    if (masterName != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 14.sp,
                            color: AppColors.pureWhite.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            masterName!,
                            style: AppTextStyles.captionMedium11.copyWith(
                              color: AppColors.pureWhite.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  statusText,
                  style: AppTextStyles.captionBold12.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceXXL,

          // 내 티켓 번호 (크게)
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.pureWhite.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '내 번호',
                  style: AppTextStyles.bodyMedium14.copyWith(
                    color: AppColors.pureWhite.withValues(alpha: 0.9),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '#${myStatus.ticketNo}',
                  style: AppTextStyles.displayBold56,
                ),
              ],
            ),
          ),

          AppSpacing.verticalSpaceXXL,

          // 대기 정보
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMyQueueStat('내 순서', '#${myStatus.position}'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: AppColors.pureWhite.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('내 앞 대기', '${myStatus.teamsAhead}팀'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: AppColors.pureWhite.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('예상 대기', _calculateWaitTime()),
              ],
            ),
          ),

          // 대기 중 상태일 때만 포기 버튼 표시
          if (myStatus.state == 'WAITING') ...[
            AppSpacing.verticalSpaceLG,

            // 포기 버튼
            TextButton.icon(
              onPressed: onCancel,
              icon: Icon(
                Icons.close,
                size: 16.sp,
                color: AppColors.pureWhite.withValues(alpha: 0.9),
              ),
              label: Text(
                '줄서기 포기',
                style: AppTextStyles.bodyMedium14.copyWith(
                  color: AppColors.pureWhite.withValues(alpha: 0.9),
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.pureWhite.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],

          // 입장 중 상태
          if (myStatus.state == 'IN_SERVICE') ...[
            AppSpacing.verticalSpaceLG,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20.sp,
                    color: AppColors.pureWhite,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '지금 입장하세요! 🎉',
                    style: AppTextStyles.bodyBold14.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 예상 대기 시간 계산
  ///
  /// - IN_SERVICE: 이용 중이므로 "이용 중" 표시
  /// - WAITING + teamsAhead=0: 다음 차례! (현재 이용 중인 팀 시간만큼 대기)
  /// - WAITING + teamsAhead>0: (teamsAhead + 1) * avgWaitMinutes
  String _calculateWaitTime() {
    final avgMinutes = booth?.avgWaitMinutes ?? 10;

    if (myStatus.state == 'IN_SERVICE') {
      return '이용 중';
    }

    // WAITING 상태: 내 앞 대기팀 + 현재 이용 중인 팀(1) 고려
    // teamsAhead=0이어도 현재 IN_SERVICE 팀이 끝나야 하므로 최소 avgMinutes
    final waitMinutes = (myStatus.teamsAhead + 1) * avgMinutes;
    return '$waitMinutes분';
  }

  /// 상태 정보 반환 (색상, 텍스트)
  /// API state: WAITING | IN_SERVICE | COMPLETED | CANCELED
  (Color, String) _getStatusInfo() {
    switch (myStatus.state) {
      case 'WAITING':
        return (AppColors.pureWhite, '대기중');
      case 'IN_SERVICE':
        return (AppColors.success, '입장중');
      case 'COMPLETED':
        return (AppColors.textTertiary, '완료');
      case 'CANCELED':
        return (AppColors.error, '취소됨');
      default:
        return (AppColors.pureWhite, '알 수 없음');
    }
  }

  /// 📊 내 큐 통계 아이템
  Widget _buildMyQueueStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyRegular12.copyWith(
            color: AppColors.pureWhite.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: AppTextStyles.headingSemiBold20.copyWith(
            color: AppColors.pureWhite,
          ),
        ),
      ],
    );
  }
}
