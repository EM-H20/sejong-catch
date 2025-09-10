import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 진행도 표시 컴포넌트 시스템
/// 세종캐치 앱의 모든 진행상황 표시를 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppProgressBar(
///   progress: 0.6,
///   showPercentage: true,
/// )
/// ```

enum AppProgressBarType {
  /// 선형 진행바 (기본)
  linear,
  
  /// 원형 진행바
  circular,
  
  /// 단계별 진행바 (1/5, 2/5 등)
  step,
  
  /// 얇은 선형 진행바 (상단 로딩용)
  thin,
}

enum AppProgressBarSize {
  /// 작은 크기
  small,
  
  /// 중간 크기 (기본)
  medium,
  
  /// 큰 크기
  large,
}

/// 기본 진행도 바
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.progress,
    this.type = AppProgressBarType.linear,
    this.size = AppProgressBarSize.medium,
    this.color,
    this.backgroundColor,
    this.showPercentage = false,
    this.showLabel = false,
    this.label,
    this.isAnimated = true,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress must be between 0.0 and 1.0');

  /// 진행률 (0.0 ~ 1.0)
  final double progress;
  
  /// 진행바 타입
  final AppProgressBarType type;
  
  /// 진행바 크기
  final AppProgressBarSize size;
  
  /// 진행바 색상 (오버라이드)
  final Color? color;
  
  /// 배경 색상 (오버라이드)
  final Color? backgroundColor;
  
  /// 퍼센트 표시 여부
  final bool showPercentage;
  
  /// 라벨 표시 여부
  final bool showLabel;
  
  /// 커스텀 라벨 텍스트
  final String? label;
  
  /// 애니메이션 여부
  final bool isAnimated;
  
  /// 애니메이션 지속시간
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppProgressBarType.linear:
        return _buildLinearProgress(context);
      case AppProgressBarType.circular:
        return _buildCircularProgress(context);
      case AppProgressBarType.step:
        return _buildStepProgress(context);
      case AppProgressBarType.thin:
        return _buildThinProgress(context);
    }
  }

  // ============================================================================
  // LINEAR PROGRESS BAR
  // ============================================================================
  
  Widget _buildLinearProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showLabel)
                Text(
                  label ?? "진행률",
                  style: _getLabelStyle().copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              if (showPercentage)
                Text(
                  "${(progress * 100).round()}%",
                  style: _getLabelStyle().copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          height: _getLinearHeight(),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.surfaceVariant(context),
            borderRadius: BorderRadius.circular(_getLinearHeight() / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_getLinearHeight() / 2),
            child: isAnimated
                ? TweenAnimationBuilder<double>(
                    duration: animationDuration,
                    tween: Tween<double>(begin: 0.0, end: progress),
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          color ?? AppColors.themePrimary(context),
                        ),
                      );
                    },
                  )
                : LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color ?? AppColors.themePrimary(context),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // CIRCULAR PROGRESS BAR
  // ============================================================================
  
  Widget _buildCircularProgress(BuildContext context) {
    final diameter = _getCircularDiameter();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: diameter,
          height: diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 배경 원
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: _getCircularStrokeWidth(),
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  backgroundColor ?? AppColors.surfaceVariant(context),
                ),
              ),
              // 진행 원
              isAnimated
                  ? TweenAnimationBuilder<double>(
                      duration: animationDuration,
                      tween: Tween<double>(begin: 0.0, end: progress),
                      builder: (context, value, child) {
                        return CircularProgressIndicator(
                          value: value,
                          strokeWidth: _getCircularStrokeWidth(),
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            color ?? AppColors.themePrimary(context),
                          ),
                        );
                      },
                    )
                  : CircularProgressIndicator(
                      value: progress,
                      strokeWidth: _getCircularStrokeWidth(),
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        color ?? AppColors.themePrimary(context),
                      ),
                    ),
              // 중앙 텍스트
              if (showPercentage)
                Text(
                  "${(progress * 100).round()}%",
                  style: _getCircularTextStyle().copyWith(
                    color: AppColors.textPrimary(context),
                  ),
                ),
            ],
          ),
        ),
        if (showLabel && label != null) ...[
          SizedBox(height: 8.h),
          Text(
            label!,
            style: _getLabelStyle().copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================================
  // STEP PROGRESS BAR  
  // ============================================================================
  
  Widget _buildStepProgress(BuildContext context) {
    // Step progress는 별도의 StepProgressBar 위젯으로 구현
    return _buildLinearProgress(context);
  }

  // ============================================================================
  // THIN PROGRESS BAR (상단 로딩용)
  // ============================================================================
  
  Widget _buildThinProgress(BuildContext context) {
    return Container(
      height: 2.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceVariant(context),
      ),
      child: isAnimated
          ? TweenAnimationBuilder<double>(
              duration: animationDuration,
              tween: Tween<double>(begin: 0.0, end: progress),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? AppColors.themePrimary(context),
                  ),
                );
              },
            )
          : LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.themePrimary(context),
              ),
            ),
    );
  }

  // ============================================================================
  // SIZE CALCULATIONS
  // ============================================================================

  double _getLinearHeight() {
    switch (size) {
      case AppProgressBarSize.small:
        return 4.h;
      case AppProgressBarSize.medium:
        return 6.h;
      case AppProgressBarSize.large:
        return 8.h;
    }
  }

  double _getCircularDiameter() {
    switch (size) {
      case AppProgressBarSize.small:
        return 32.w;
      case AppProgressBarSize.medium:
        return 48.w;
      case AppProgressBarSize.large:
        return 64.w;
    }
  }

  double _getCircularStrokeWidth() {
    switch (size) {
      case AppProgressBarSize.small:
        return 3.0;
      case AppProgressBarSize.medium:
        return 4.0;
      case AppProgressBarSize.large:
        return 5.0;
    }
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case AppProgressBarSize.small:
        return AppTextStyles.tinyRegular;
      case AppProgressBarSize.medium:
        return AppTextStyles.smallRegular;
      case AppProgressBarSize.large:
        return AppTextStyles.regularRegular;
    }
  }

  TextStyle _getCircularTextStyle() {
    switch (size) {
      case AppProgressBarSize.small:
        return AppTextStyles.tinyBold;
      case AppProgressBarSize.medium:
        return AppTextStyles.smallBold;
      case AppProgressBarSize.large:
        return AppTextStyles.regularBold;
    }
  }
}

/// 단계별 진행바 (1/5, 2/5 등)
class AppStepProgressBar extends StatelessWidget {
  const AppStepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.size = AppProgressBarSize.medium,
    this.color,
    this.backgroundColor,
    this.completedColor,
    this.showLabels = false,
    this.stepLabels,
    this.isAnimated = true,
  }) : assert(currentStep >= 0 && currentStep <= totalSteps, 
              'Current step must be between 0 and totalSteps');

  /// 전체 단계 수
  final int totalSteps;
  
  /// 현재 단계 (0부터 시작)
  final int currentStep;
  
  /// 크기
  final AppProgressBarSize size;
  
  /// 활성 색상
  final Color? color;
  
  /// 비활성 배경 색상
  final Color? backgroundColor;
  
  /// 완료된 단계 색상
  final Color? completedColor;
  
  /// 라벨 표시 여부
  final bool showLabels;
  
  /// 각 단계별 라벨
  final List<String>? stepLabels;
  
  /// 애니메이션 여부
  final bool isAnimated;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 단계 인디케이터
        Row(
          children: List.generate(totalSteps, (index) {
            return Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildStepItem(context, index)),
                  if (index < totalSteps - 1) SizedBox(width: 4.w),
                ],
              ),
            );
          }),
        ),
        
        // 단계 라벨
        if (showLabels && stepLabels != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: List.generate(totalSteps, (index) {
              return Expanded(
                child: Text(
                  stepLabels![index],
                  style: AppTextStyles.tinyRegular.copyWith(
                    color: index <= currentStep
                        ? AppColors.textPrimary(context)
                        : AppColors.textTertiary(context),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildStepItem(BuildContext context, int index) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final isActive = isCompleted || isCurrent;
    
    Color getColor() {
      if (isCompleted) {
        return completedColor ?? AppColors.success;
      } else if (isCurrent) {
        return color ?? AppColors.themePrimary(context);
      } else {
        return backgroundColor ?? AppColors.surfaceVariant(context);
      }
    }

    return Container(
      height: _getStepHeight(),
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(_getStepHeight() / 2),
      ),
    );
  }

  double _getStepHeight() {
    switch (size) {
      case AppProgressBarSize.small:
        return 4.h;
      case AppProgressBarSize.medium:
        return 6.h;
      case AppProgressBarSize.large:
        return 8.h;
    }
  }
}

/// 로딩 진행도 오버레이 (indeterminate)
class AppLoadingProgressBar extends StatefulWidget {
  const AppLoadingProgressBar({
    super.key,
    this.type = AppProgressBarType.linear,
    this.size = AppProgressBarSize.medium,
    this.color,
    this.backgroundColor,
  });

  final AppProgressBarType type;
  final AppProgressBarSize size;
  final Color? color;
  final Color? backgroundColor;

  @override
  State<AppLoadingProgressBar> createState() => _AppLoadingProgressBarState();
}

class _AppLoadingProgressBarState extends State<AppLoadingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AppProgressBarType.linear:
      case AppProgressBarType.thin:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AppProgressBar(
              progress: _controller.value,
              type: widget.type,
              size: widget.size,
              color: widget.color,
              backgroundColor: widget.backgroundColor,
              isAnimated: false,
            );
          },
        );
      case AppProgressBarType.circular:
        return SizedBox(
          width: widget.size == AppProgressBarSize.small ? 32.w : 
                 widget.size == AppProgressBarSize.medium ? 48.w : 64.w,
          height: widget.size == AppProgressBarSize.small ? 32.w : 
                  widget.size == AppProgressBarSize.medium ? 48.w : 64.w,
          child: CircularProgressIndicator(
            strokeWidth: widget.size == AppProgressBarSize.small ? 3.0 : 
                        widget.size == AppProgressBarSize.medium ? 4.0 : 5.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? AppColors.themePrimary(context),
            ),
          ),
        );
      case AppProgressBarType.step:
        // Step에서는 indeterminate를 지원하지 않음
        return const SizedBox.shrink();
    }
  }
}

// ============================================================================
// 편의성 생성자들
// ============================================================================

/// 다운로드/업로드 진행바
class AppDownloadProgressBar extends AppProgressBar {
  const AppDownloadProgressBar({
    super.key,
    required super.progress,
    super.showPercentage = true,
    super.label = "다운로드",
  }) : super(
         showLabel: true,
         type: AppProgressBarType.linear,
         size: AppProgressBarSize.medium,
       );
}

/// 원형 로딩 인디케이터
class AppCircularProgress extends AppProgressBar {
  const AppCircularProgress({
    super.key,
    required super.progress,
    super.showPercentage = true,
  }) : super(
         type: AppProgressBarType.circular,
         size: AppProgressBarSize.medium,
       );
}

/// 상단 페이지 로딩바 (thin)
class AppPageLoadingBar extends AppProgressBar {
  const AppPageLoadingBar({
    super.key,
    required super.progress,
  }) : super(
         type: AppProgressBarType.thin,
         size: AppProgressBarSize.small,
       );
}