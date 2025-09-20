/// ❌ 에러 상태 위젯
///
/// 오류 발생 시 사용자 친화적 UI
/// Features:
/// ✅ 다양한 에러 타입 지원
/// ✅ 재시도 버튼
/// ✅ 한국어 메시지
/// ✅ ScreenUtil 반응형 적용

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final bool showRetryButton;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🚨 에러 아이콘
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 40.sp,
                color: AppColors.error,
              ),
            ),

            SizedBox(height: 24.h),

            // 📝 에러 메시지
            Text(
              '앗, 문제가 발생했어요',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 🔄 재시도 버튼
            if (showRetryButton && onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh,
                  size: 18.sp,
                  color: Colors.white,
                ),
                label: Text(
                  retryText ?? '다시 시도',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ❌ 네트워크 에러 위젯
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: '인터넷 연결을 확인하고 다시 시도해주세요',
      icon: Icons.wifi_off,
      onRetry: onRetry,
      retryText: '새로고침',
    );
  }
}

/// ❌ 서버 에러 위젯
class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: '서버에 문제가 있어요. 잠시 후 다시 시도해주세요',
      icon: Icons.cloud_off,
      onRetry: onRetry,
      retryText: '다시 시도',
    );
  }
}

/// ❌ 권한 에러 위젯
class PermissionErrorWidget extends StatelessWidget {
  final VoidCallback? onAction;
  final String? actionText;

  const PermissionErrorWidget({
    super.key,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      message: '이 기능을 사용하려면 학생 인증이 필요해요',
      icon: Icons.lock_outline,
      onRetry: onAction,
      retryText: actionText ?? '인증하기',
    );
  }
}