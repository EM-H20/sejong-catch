import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/response/queue_item.dart';

/// 🎫 큐 참여 확인 다이얼로그
///
/// 사용자가 큐에 줄서기를 시도할 때 확인을 받는 다이얼로그입니다.
/// - 큐 정보 표시 (이름, 대기 인원, 예상 시간)
/// - 참여 확인/취소 버튼
///
/// **디자인 토큰 100% 사용!**
class JoinQueueDialog extends StatelessWidget {
  final QueueItem queue;
  final VoidCallback onConfirm;

  const JoinQueueDialog({
    super.key,
    required this.queue,
    required this.onConfirm,
  });

  /// 다이얼로그 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required QueueItem queue,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => JoinQueueDialog(
        queue: queue,
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
            // 아이콘
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: AppColors.brandCrimson.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.queue_rounded,
                size: 32.sp,
                color: AppColors.brandCrimson,
              ),
            ),

            AppSpacing.verticalSpaceLG,

            // 제목
            Text(
              '줄서기 하시겠어요?',
              style: AppTextStyles.headingBold20,
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceSM,

            // 큐 이름
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                queue.name,
                style: AppTextStyles.titleSemiBold16,
                textAlign: TextAlign.center,
              ),
            ),

            AppSpacing.verticalSpaceMD,

            // 대기 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoItem(
                  icon: Icons.people_outline,
                  label: '대기 인원',
                  value: '${queue.waiting}명',
                  color: AppColors.trustAcademic,
                ),
                Container(
                  width: 1.5,
                  height: 40.h,
                  color: AppColors.divider,
                ),
                _buildInfoItem(
                  icon: Icons.timer_outlined,
                  label: '예상 시간',
                  value: '${queue.avgWaitTime}분',
                  color: AppColors.queueTimer,
                ),
              ],
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
                        '취소',
                        style: AppTextStyles.buttonSemiBold15.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                AppSpacing.horizontalSpaceMD,

                // 확인 버튼
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandCrimson,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        '줄서기',
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

  /// 정보 아이템 위젯
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: color),
        SizedBox(height: 6.h),
        Text(
          label,
          style: AppTextStyles.captionMedium11.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.bodyBold14.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
