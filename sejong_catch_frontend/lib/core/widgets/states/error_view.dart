import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/cta_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onRetry;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final bool showContactSupport;

  const ErrorView({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.actionText = '다시 시도',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = false,
  });

  // Factory constructors for common error states
  const ErrorView.network({
    super.key,
    this.subtitle = '네트워크 연결을 확인하고 다시 시도해주세요',
    this.actionText = '다시 시도',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = false,
  }) : message = '네트워크 오류',
        icon = Icons.wifi_off;

  const ErrorView.server({
    super.key,
    this.subtitle = '서버에 일시적인 문제가 발생했습니다',
    this.actionText = '다시 시도',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = true,
  }) : message = '서버 오류',
        icon = Icons.error_outline;

  const ErrorView.notFound({
    super.key,
    this.subtitle = '요청하신 정보를 찾을 수 없습니다',
    this.actionText = '홈으로 이동',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = false,
  }) : message = '페이지를 찾을 수 없습니다',
        icon = Icons.search_off;

  const ErrorView.unauthorized({
    super.key,
    this.subtitle = '로그인이 필요한 서비스입니다',
    this.actionText = '로그인하기',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = false,
  }) : message = '접근 권한이 없습니다',
        icon = Icons.lock_outline;

  const ErrorView.generic({
    super.key,
    this.subtitle = '잠시 후 다시 시도해주세요',
    this.actionText = '다시 시도',
    this.onRetry,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.showContactSupport = true,
  }) : message = '문제가 발생했습니다',
        icon = Icons.error_outline;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 40.w,
                color: AppColors.error,
              ),
            ),

            SizedBox(height: 24.h),

            // Error message
            Text(
              message,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            SizedBox(height: 32.h),

            // Primary action button
            if (actionText != null && onRetry != null)
              CTAButton.primary(
                text: actionText!,
                onPressed: onRetry,
                isFullWidth: true,
              ),

            // Secondary action button
            if (secondaryActionText != null && onSecondaryAction != null) ...[
              SizedBox(height: 12.h),
              CTAButton.text(
                text: secondaryActionText!,
                onPressed: onSecondaryAction,
                isFullWidth: true,
              ),
            ],

            // Contact support
            if (showContactSupport) ...[
              SizedBox(height: 24.h),
              CTAButton.text(
                text: '문제 신고하기',
                onPressed: () => _showContactSupport(context),
                size: CTAButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('문제 신고'),
        content: const Text(
          '지속적인 문제가 발생한다면\nsejongcatch@sejong.ac.kr로\n문의해주세요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}