/// 📭 빈 상태 위젯
///
/// 데이터가 없을 때 표시하는 친화적 UI
/// Features:
/// ✅ 커스텀 아이콘 & 메시지
/// ✅ 선택적 액션 버튼
/// ✅ 일러스트레이션 지원
/// ✅ ScreenUtil 반응형 적용

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';

class AppEmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? illustration;

  const AppEmptyWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.actionText,
    this.onActionPressed,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPaddingLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎨 일러스트레이션 또는 아이콘
            if (illustration != null)
              illustration!
            else if (icon != null)
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(icon!, size: 40.sp, color: AppColors.disabled),
              ),

            AppSpacing.verticalSpaceXXL,

            // 📝 제목
            Text(
              title,
              style: AppTextStyles.headingSemiBold20.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceSM,

            // 📝 설명
            Text(
              subtitle,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // 🔥 액션 버튼
            if (actionText != null && onActionPressed != null) ...[
              AppSpacing.verticalSpaceXXL,
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandCrimson,
                  foregroundColor: AppColors.white,
                  padding: AppSpacing.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(actionText!, style: AppTextStyles.labelMedium14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 📭 리스트형 빈 상태 위젯
class EmptyListWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyListWidget({super.key, required this.message, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.screenPaddingLarge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 48.sp,
            color: AppColors.disabled,
          ),
          AppSpacing.verticalSpaceLG,
          Text(
            message,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
