/// 토스 스타일의 매끄러운 진행률 표시 위젯
/// 
/// 로그인 단계별 진행 상황을 시각적으로 보여주는 프로그레스 바입니다.
/// 애니메이션과 그라데이션으로 세련된 UX를 제공해요! ✨
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 로그인 진행률 표시 위젯
/// 
/// 토스처럼 부드럽고 직관적인 진행률 바를 제공합니다.
/// 현재 단계에 따라 자동으로 애니메이션되며, 접근성도 고려되어 있어요.
class LoginProgressBar extends StatefulWidget {
  /// 현재 진행률 (0.0 ~ 1.0)
  final double progress;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  /// 바의 높이 (기본값: 4.h)
  final double? height;

  /// 배경색 (기본값: AppColors.surface)
  final Color? backgroundColor;

  /// 진행률 바 색상 (기본값: 그라데이션)
  final Color? progressColor;

  /// 그라데이션 사용 여부 (기본값: true)
  final bool useGradient;

  /// 접근성 설명 텍스트
  final String? semanticsLabel;

  const LoginProgressBar({
    super.key,
    required this.progress,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height,
    this.backgroundColor,
    this.progressColor,
    this.useGradient = true,
    this.semanticsLabel,
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress must be between 0.0 and 1.0');

  @override
  State<LoginProgressBar> createState() => _LoginProgressBarState();
}

class _LoginProgressBarState extends State<LoginProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _animateToProgress(widget.progress);
  }

  @override
  void didUpdateWidget(LoginProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 진행률이 변경되면 새로운 애니메이션 시작
    if (oldWidget.progress != widget.progress) {
      _animateToProgress(widget.progress);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 애니메이션 컨트롤러 및 애니메이션 설정
  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // 토스 스타일의 자연스러운 커브
    ));
  }

  /// 새로운 진행률로 애니메이션
  void _animateToProgress(double newProgress) {
    // Tween 업데이트 (현재 위치에서 새 목표로)
    _progressAnimation = Tween<double>(
      begin: _previousProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // 애니메이션 시작
    _animationController.reset();
    _animationController.forward();

    // 이전 진행률 업데이트
    _previousProgress = newProgress;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = widget.height ?? 4.h;
    final effectiveBackgroundColor = widget.backgroundColor ?? AppColors.surface;

    return Semantics(
      label: widget.semanticsLabel ?? 
             '로그인 진행률 ${(widget.progress * 100).toInt()}%',
      value: '${(widget.progress * 100).toInt()}%',
      child: Container(
        width: double.infinity,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(effectiveHeight / 2),
          // 미묘한 그림자로 깊이감 연출
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _progressAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  // 그라데이션 또는 단색 선택
                  gradient: widget.useGradient ? _buildProgressGradient() : null,
                  color: widget.useGradient ? null : 
                         (widget.progressColor ?? AppColors.brandCrimson),
                  borderRadius: BorderRadius.circular(effectiveHeight / 2),
                  // 진행률 바에도 미묘한 그림자
                  boxShadow: [
                    BoxShadow(
                      color: (widget.progressColor ?? AppColors.brandCrimson)
                          .withValues(alpha: 0.3),
                      blurRadius: 4.r,
                      offset: Offset(0, 1.h),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 진행률 바 그라데이션 생성
  /// 
  /// 브랜드 색상을 기반으로 아름다운 그라데이션을 만듭니다.
  LinearGradient _buildProgressGradient() {
    return LinearGradient(
      colors: [
        AppColors.brandCrimson,
        AppColors.brandCrimson.withValues(alpha: 0.8),
        AppColors.brandCrimsonLight,
      ],
      stops: const [0.0, 0.7, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}

/// 단계 정보와 함께 표시되는 확장된 진행률 바
/// 
/// 진행률과 함께 현재 단계 정보를 표시하는 위젯입니다.
/// 더 자세한 정보를 제공하고 싶을 때 사용해요.
class DetailedProgressBar extends StatelessWidget {
  /// 현재 진행률 (0.0 ~ 1.0)
  final double progress;

  /// 현재 단계 번호
  final int currentStep;

  /// 전체 단계 수
  final int totalSteps;

  /// 단계 제목
  final String? stepTitle;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  const DetailedProgressBar({
    super.key,
    required this.progress,
    required this.currentStep,
    required this.totalSteps,
    this.stepTitle,
    this.animationDuration = const Duration(milliseconds: 600),
  }) : assert(currentStep >= 1 && currentStep <= totalSteps,
             'Current step must be between 1 and total steps');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 단계 정보 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (stepTitle != null)
              Text(
                stepTitle!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            Text(
              '$currentStep / $totalSteps',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brandCrimson,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 8.h),
        
        // 진행률 바
        LoginProgressBar(
          progress: progress,
          animationDuration: animationDuration,
          semanticsLabel: stepTitle != null 
              ? '$stepTitle 단계, $currentStep/$totalSteps 진행률 ${(progress * 100).toInt()}%'
              : '단계 $currentStep/$totalSteps 진행률 ${(progress * 100).toInt()}%',
        ),
      ],
    );
  }
}

/// 멀티 스텝 진행률 표시 위젯
/// 
/// 여러 단계를 동시에 보여주는 도트 스타일 진행률 바입니다.
/// 각 단계의 완료 상태를 명확히 구분할 수 있어요.
class MultiStepProgressBar extends StatelessWidget {
  /// 전체 단계 수
  final int totalSteps;

  /// 현재 단계 (1부터 시작)
  final int currentStep;

  /// 완료된 단계들 (1부터 시작하는 Set)
  final Set<int> completedSteps;

  /// 각 도트의 크기
  final double dotSize;

  /// 도트 간격
  final double dotSpacing;

  const MultiStepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.completedSteps = const {},
    this.dotSize = 8.0,
    this.dotSpacing = 12.0,
  }) : assert(totalSteps > 0, 'Total steps must be greater than 0'),
       assert(currentStep >= 1 && currentStep <= totalSteps,
              'Current step must be between 1 and total steps');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isCompleted = completedSteps.contains(stepNumber);
        final isCurrent = stepNumber == currentStep;
        final isPast = stepNumber < currentStep;

        return Padding(
          padding: EdgeInsets.only(
            right: index < totalSteps - 1 ? dotSpacing.w : 0,
          ),
          child: _buildStepDot(
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isPast: isPast,
          ),
        );
      }),
    );
  }

  /// 개별 단계 도트 위젯
  Widget _buildStepDot({
    required bool isCompleted,
    required bool isCurrent,
    required bool isPast,
  }) {
    Color dotColor;
    double size = dotSize;

    if (isCompleted) {
      dotColor = AppColors.success;
    } else if (isCurrent) {
      dotColor = AppColors.brandCrimson;
      size = dotSize * 1.2; // 현재 단계는 조금 크게
    } else if (isPast) {
      dotColor = AppColors.brandCrimsonLight;
    } else {
      dotColor = AppColors.surface;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
        border: !isCompleted && !isCurrent && !isPast
            ? Border.all(
                color: AppColors.divider,
                width: 1.w,
              )
            : null,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: AppColors.brandCrimson.withValues(alpha: 0.3),
                  blurRadius: 6.r,
                  spreadRadius: 1.r,
                ),
              ]
            : null,
      ),
      child: isCompleted
          ? Icon(
              Icons.check,
              size: (size * 0.6).w,
              color: Colors.white,
            )
          : null,
    );
  }
}