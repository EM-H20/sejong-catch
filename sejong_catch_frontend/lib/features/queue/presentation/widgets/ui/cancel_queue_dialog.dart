import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/my_queue_status.dart';
import '../../../data/models/response/booth.dart';

/// 🚫 줄서기 포기 확인 다이얼로그
///
/// 사용자가 줄서기를 포기할 때 확인을 받는 다이얼로그입니다.
/// - 부스 정보 및 현재 티켓 번호 표시
/// - 경고 메시지
/// - 포기 확인/취소 버튼
///
/// **API 모델: MyQueueStatus**
/// **디자인 토큰 100% 사용!**
class CancelQueueDialog extends StatelessWidget {
  final MyQueueStatus myStatus;
  final Booth? booth;
  final VoidCallback onConfirm;

  const CancelQueueDialog({
    super.key,
    required this.myStatus,
    this.booth,
    required this.onConfirm,
  });

  /// 다이얼로그 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required MyQueueStatus myStatus,
    Booth? booth,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CancelQueueDialog(
        myStatus: myStatus,
        booth: booth,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: AppSpacing.modalPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 경고 아이콘
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_rounded,
                size: 32.sp,
                color: AppColors.error,
              ),
            ),

            AppSpacing.verticalSpaceLG,

            // 제목
            Text(
              '줄서기를 포기하시겠어요?',
              style: AppTextStyles.headingBold20,
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceSM,

            // 부스 이름 및 내 번호
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Text(
                    booth?.title ?? '부스',
                    style: AppTextStyles.titleSemiBold16,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '내 번호:',
                        style: AppTextStyles.bodyRegular14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '#${myStatus.ticketNo}',
                        style: AppTextStyles.titleBold16.copyWith(
                          color: AppColors.brandCrimson,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSpaceMD,

            // 경고 메시지
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18.sp, color: AppColors.error),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      '포기하면 다시 줄을 서야 해요',
                      style: AppTextStyles.bodyRegular12.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSpaceXL,

            // 버튼들
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        '계속 대기',
                        style: AppTextStyles.buttonSemiBold15.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),

                AppSpacing.horizontalSpaceMD,

                // 포기 버튼
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        '포기하기',
                        style: AppTextStyles.buttonSemiBold15.copyWith(
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
