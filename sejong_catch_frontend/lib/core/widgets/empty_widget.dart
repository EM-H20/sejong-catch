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
        padding: EdgeInsets.all(32.w),
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
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  icon!,
                  size: 40.sp,
                  color: Colors.grey[400],
                ),
              ),

            SizedBox(height: 24.h),

            // 📝 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            // 📝 설명
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 🔥 액션 버튼
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandCrimson,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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

  const EmptyListWidget({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 48.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}