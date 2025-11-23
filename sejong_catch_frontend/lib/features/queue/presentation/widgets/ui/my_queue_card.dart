import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/my_queue_item.dart';

/// 🎫 내 큐 카드 위젯
///
/// 내가 참여한 큐의 정보를 보여주는 크림슨 그라디언트 카드입니다.
/// - 큐 이름
/// - 내 순번 (크게 강조!)
/// - 현재 순번, 앞 대기 인원, 예상 대기 시간
/// - 줄서기 포기 버튼
///
/// **디자인 토큰 100% 사용!**
class MyQueueCard extends StatelessWidget {
  final MyQueueItem myQueue;
  final VoidCallback onCancel;

  const MyQueueCard({
    super.key,
    required this.myQueue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
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
          // 큐 이름
          Text(
            myQueue.name,
            style: AppTextStyles.headingBold22,
          ),

          AppSpacing.verticalSpaceXXL,

          // 내 번호 (크게)
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
                  '#${myQueue.myNumber}',
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
                _buildMyQueueStat('현재 번호', '#${myQueue.currentNumber}'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: AppColors.pureWhite.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('내 앞 대기', '${myQueue.peopleAhead}명'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: AppColors.pureWhite.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('예상 대기', '${myQueue.estimatedWait}분'),
              ],
            ),
          ),

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
      ),
    );
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
