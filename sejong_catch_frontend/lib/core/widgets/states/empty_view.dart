import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/cta_button.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyView({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.actionText,
    this.onAction,
    this.illustration,
  });

  // Factory constructors for common empty states
  const EmptyView.noResults({
    super.key,
    this.subtitle = '다른 검색어로 시도해보세요',
    this.actionText = '필터 초기화',
    this.onAction,
  }) : message = '검색 결과가 없습니다',
        icon = Icons.search_off,
        illustration = null;

  const EmptyView.noBookmarks({
    super.key,
    this.subtitle = '관심있는 정보를 북마크해보세요',
    this.actionText = '정보 둘러보기',
    this.onAction,
  }) : message = '저장된 북마크가 없습니다',
        icon = Icons.bookmark_border,
        illustration = null;

  const EmptyView.noRecommendations({
    super.key,
    this.subtitle = '관심사를 설정하면 맞춤 추천을 받을 수 있어요',
    this.actionText = '관심사 설정하기',
    this.onAction,
  }) : message = '추천할 정보가 없습니다',
        icon = Icons.recommend,
        illustration = null;

  const EmptyView.noNotifications({
    super.key,
    this.subtitle = '새로운 정보가 있으면 알려드릴게요',
    this.actionText,
    this.onAction,
  }) : message = '새로운 알림이 없습니다',
        icon = Icons.notifications_none,
        illustration = null;

  const EmptyView.offline({
    super.key,
    this.subtitle = '인터넷 연결을 확인해주세요',
    this.actionText = '다시 시도',
    this.onAction,
  }) : message = '연결할 수 없습니다',
        icon = Icons.wifi_off,
        illustration = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or icon
            if (illustration != null)
              illustration!
            else if (icon != null) ...[
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40.w,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Main message
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

            // Action button
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 24.h),
              CTAButton.outline(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}