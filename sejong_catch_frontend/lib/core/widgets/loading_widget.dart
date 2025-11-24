/// 📱 로딩 위젯
///
/// 전역에서 사용하는 일관된 로딩 UI
/// Features:
/// ✅ Shimmer 애니메이션 지원
/// ✅ 커스텀 메시지
/// ✅ 크림슨 브랜드 컬러 적용
/// ✅ ScreenUtil 반응형 적용

library;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool showSpinner;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.message,
    this.showSpinner = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showSpinner)
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                strokeWidth: 3.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? AppColors.brandCrimson,
                ),
              ),
            ),

          if (message != null) ...[
            if (showSpinner) AppSpacing.verticalSpaceLG,
            Text(
              message!,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// 📱 카드형 로딩 위젯 (리스트용)
class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppSpacing.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 120.h,
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 영역
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.disabled,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                AppSpacing.horizontalSpaceMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.disabled,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      AppSpacing.verticalSpaceSM,
                      Container(
                        height: 12.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.disabled,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSpaceLG,

            // 하단 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.disabled,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.disabled,
                    borderRadius: BorderRadius.circular(10.r),
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
