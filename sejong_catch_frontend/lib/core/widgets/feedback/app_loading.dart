import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 로딩 및 피드백 컴포넌트 시스템
/// 세종캐치 앱의 모든 로딩, 에러, 빈 상태를 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppLoadingIndicator(
///   message: "데이터를 불러오는 중...",
/// )
/// ```

enum AppLoadingSize {
  /// 작은 로딩 (버튼 내부 등)
  small,
  
  /// 중간 로딩 (리스트 아이템 등)
  medium,
  
  /// 큰 로딩 (전체 화면 등)
  large,
}

/// 기본 로딩 인디케이터
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.message,
    this.color,
    this.strokeWidth,
  });

  final AppLoadingSize size;
  final String? message;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _getSize(),
          height: _getSize(),
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth ?? _getStrokeWidth(),
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.themePrimary(context),
            ),
          ),
        ),
        if (message != null) ...[
          SizedBox(height: 16.h),
          Text(
            message!,
            style: _getTextStyle().copyWith(
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  double _getSize() {
    switch (size) {
      case AppLoadingSize.small:
        return 16.w;
      case AppLoadingSize.medium:
        return 24.w;
      case AppLoadingSize.large:
        return 32.w;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AppLoadingSize.small:
        return 2.0;
      case AppLoadingSize.medium:
        return 3.0;
      case AppLoadingSize.large:
        return 4.0;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppLoadingSize.small:
        return AppTextStyles.tinyRegular;
      case AppLoadingSize.medium:
        return AppTextStyles.smallRegular;
      case AppLoadingSize.large:
        return AppTextStyles.regularRegular;
    }
  }
}

/// 스켈레톤 로딩 (placeholder 효과)
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.isCircle = false,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isCircle;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : (widget.borderRadius ?? BorderRadius.circular(4.r)),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                AppColors.skeletonBase(context),
                AppColors.skeletonHighlight(context),
                AppColors.skeletonBase(context),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// 스켈레톤 리스트 (여러 개의 스켈레톤 아이템)
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 80,
    this.showAvatar = true,
    this.showSubtitle = true,
    this.padding,
  });

  final int itemCount;
  final double itemHeight;
  final bool showAvatar;
  final bool showSubtitle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(16.w),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) => _buildSkeletonItem(context),
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    return Container(
      height: itemHeight.h,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          if (showAvatar) ...[
            AppSkeleton(
              width: 48.w,
              height: 48.w,
              isCircle: true,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(
                  width: double.infinity,
                  height: 16.h,
                ),
                if (showSubtitle) ...[
                  SizedBox(height: 8.h),
                  AppSkeleton(
                    width: 200.w,
                    height: 14.h,
                  ),
                ],
                const Spacer(),
                AppSkeleton(
                  width: 100.w,
                  height: 12.h,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          AppSkeleton(
            width: 24.w,
            height: 24.w,
          ),
        ],
      ),
    );
  }
}

/// 빈 상태 화면
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.description,
    this.actionText,
    this.onActionPressed,
    this.illustration,
  });

  final String message;
  final IconData? icon;
  final String? description;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? illustration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘 또는 일러스트레이션
            if (illustration != null) ...[
              illustration!,
              SizedBox(height: 24.h),
            ] else if (icon != null) ...[
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40.w,
                  color: AppColors.textTertiary(context),
                ),
              ),
              SizedBox(height: 24.h),
            ],
            
            // 메인 메시지
            Text(
              message,
              style: AppTextStyles.title3.copyWith(
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            
            // 설명 텍스트
            if (description != null) ...[
              SizedBox(height: 8.h),
              Text(
                description!,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 액션 버튼
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: 24.h),
              TextButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 에러 상태 화면
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    this.description,
    this.retryText = "다시 시도",
    this.onRetry,
    this.showIcon = true,
  });

  final String message;
  final String? description;
  final String retryText;
  final VoidCallback? onRetry;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 에러 아이콘
            if (showIcon) ...[
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.errorLightest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 40.w,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 24.h),
            ],
            
            // 에러 메시지
            Text(
              message,
              style: AppTextStyles.title3.copyWith(
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            
            // 에러 설명
            if (description != null) ...[
              SizedBox(height: 8.h),
              Text(
                description!,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondary(context),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            // 재시도 버튼
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, size: 16.w),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 네트워크 에러 상태 (특화된 에러 화면)
class AppNetworkErrorState extends StatelessWidget {
  const AppNetworkErrorState({
    super.key,
    this.onRetry,
  });

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(
      message: "인터넷 연결을 확인해주세요",
      description: "네트워크 연결이 불안정하거나\n인터넷에 연결되어 있지 않습니다.",
      onRetry: onRetry,
    );
  }
}

/// 토스트 메시지 (스낵바)
class AppToast {
  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getIcon(type),
              color: AppColors.skyWhite,
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.regularRegular.copyWith(
                  color: AppColors.skyWhite,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getBackgroundColor(context, type),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
        action: actionLabel != null && onActionPressed != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppColors.skyWhite,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }

  static IconData _getIcon(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return Icons.check_circle_outline;
      case AppToastType.warning:
        return Icons.warning_outlined;
      case AppToastType.error:
        return Icons.error_outline;
      case AppToastType.info:
        return Icons.info_outline;
    }
  }

  static Color _getBackgroundColor(BuildContext context, AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return AppColors.success;
      case AppToastType.warning:
        return AppColors.warning;
      case AppToastType.error:
        return AppColors.error;
      case AppToastType.info:
        return AppColors.info;
    }
  }

  /// 성공 토스트
  static void success(BuildContext context, String message) {
    show(context, message, type: AppToastType.success);
  }

  /// 경고 토스트
  static void warning(BuildContext context, String message) {
    show(context, message, type: AppToastType.warning);
  }

  /// 에러 토스트
  static void error(BuildContext context, String message) {
    show(context, message, type: AppToastType.error);
  }

  /// 정보 토스트
  static void info(BuildContext context, String message) {
    show(context, message, type: AppToastType.info);
  }
}

enum AppToastType {
  success,
  warning,
  error,
  info,
}

/// 풀 스크린 로딩 오버레이
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? 
                   AppColors.inkDarkest.withValues(alpha: 0.5),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer(context),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: AppLoadingIndicator(
                  size: AppLoadingSize.large,
                  message: message,
                ),
              ),
            ),
          ),
      ],
    );
  }
}