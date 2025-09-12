/// 로그인 단계별 헤더 위젯
/// 
/// 각 단계에서 사용자에게 명확한 제목과 설명을 제공하는 헤더 컴포넌트입니다.
/// 토스처럼 친근하고 직관적인 텍스트로 사용자를 안내해요! 💬
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/login_step.dart';

/// 단계별 헤더 위젯
/// 
/// 제목, 서브타이틀, 그리고 선택적 아이콘을 포함하는 헤더입니다.
/// 각 로그인 단계에서 사용자가 무엇을 해야 하는지 명확히 안내합니다.
class StepHeader extends StatelessWidget {
  /// 제목 텍스트
  final String title;

  /// 서브타이틀 (설명 텍스트)
  final String subtitle;

  /// 헤더 아이콘 (선택사항)
  final Widget? icon;

  /// 제목 스타일 (기본값: 자동 설정)
  final TextStyle? titleStyle;

  /// 서브타이틀 스타일 (기본값: 자동 설정)
  final TextStyle? subtitleStyle;

  /// 텍스트 정렬 (기본값: 왼쪽 정렬)
  final TextAlign textAlign;

  /// 제목과 서브타이틀 사이 간격
  final double spacing;

  /// 애니메이션 적용 여부 (기본값: true)
  final bool animated;

  const StepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.titleStyle,
    this.subtitleStyle,
    this.textAlign = TextAlign.start,
    this.spacing = 8.0,
    this.animated = true,
  });

  /// LoginStep enum을 사용한 편의 생성자
  /// 
  /// 단계별로 미리 정의된 제목과 서브타이틀을 사용합니다.
  factory StepHeader.fromStep({
    Key? key,
    required LoginStep step,
    String? phoneNumber,
    Widget? icon,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextAlign textAlign = TextAlign.start,
    double spacing = 8.0,
    bool animated = true,
  }) {
    return StepHeader(
      key: key,
      title: step.title,
      subtitle: step.getSubtitle(phoneNumber: phoneNumber),
      icon: icon,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      textAlign: textAlign,
      spacing: spacing,
      animated: animated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      crossAxisAlignment: _getCrossAxisAlignment(),
      children: [
        // 아이콘이 있으면 표시
        if (icon != null) ...[
          icon!,
          SizedBox(height: spacing.h),
        ],
        
        // 제목
        Text(
          title,
          style: titleStyle ?? _getDefaultTitleStyle(),
          textAlign: textAlign,
        ),
        
        SizedBox(height: spacing.h),
        
        // 서브타이틀
        Text(
          subtitle,
          style: subtitleStyle ?? _getDefaultSubtitleStyle(),
          textAlign: textAlign,
        ),
      ],
    );

    // 애니메이션 적용 여부에 따라 감싸기
    if (animated) {
      return _AnimatedStepHeader(child: content);
    } else {
      return content;
    }
  }

  /// 텍스트 정렬에 따른 CrossAxisAlignment 계산
  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (textAlign) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.end:
      case TextAlign.right:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  /// 기본 제목 스타일
  TextStyle _getDefaultTitleStyle() {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  /// 기본 서브타이틀 스타일
  TextStyle _getDefaultSubtitleStyle() {
    return TextStyle(
      fontSize: 16.sp,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }
}

/// 애니메이션이 적용된 헤더 래퍼
/// 
/// 페이드 인과 슬라이드 애니메이션을 제공합니다.
class _AnimatedStepHeader extends StatefulWidget {
  final Widget child;

  const _AnimatedStepHeader({required this.child});

  @override
  State<_AnimatedStepHeader> createState() => _AnimatedStepHeaderState();
}

class _AnimatedStepHeaderState extends State<_AnimatedStepHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2), // 아래에서 위로
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  void _startAnimation() {
    // 약간의 지연 후 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 아이콘과 함께 표시되는 특별한 헤더
/// 
/// 성공, 오류, 경고 등의 상태를 시각적으로 강조하는 헤더입니다.
class IconStepHeader extends StatelessWidget {
  /// 제목 텍스트
  final String title;

  /// 서브타이틀 (설명 텍스트)
  final String subtitle;

  /// 아이콘
  final IconData iconData;

  /// 아이콘 색상
  final Color iconColor;

  /// 아이콘 배경 색상 (선택사항)
  final Color? iconBackgroundColor;

  /// 아이콘 크기
  final double iconSize;

  /// 전체 텍스트 정렬
  final TextAlign textAlign;

  const IconStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    this.iconBackgroundColor,
    this.iconSize = 64.0,
    this.textAlign = TextAlign.center,
  });

  /// 성공 상태 헤더
  factory IconStepHeader.success({
    Key? key,
    required String title,
    required String subtitle,
    double iconSize = 64.0,
  }) {
    return IconStepHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      iconData: Icons.check_circle_rounded,
      iconColor: AppColors.success,
      iconSize: iconSize,
    );
  }

  /// 오류 상태 헤더
  factory IconStepHeader.error({
    Key? key,
    required String title,
    required String subtitle,
    double iconSize = 64.0,
  }) {
    return IconStepHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      iconData: Icons.error_rounded,
      iconColor: AppColors.error,
      iconSize: iconSize,
    );
  }

  /// 정보 상태 헤더
  factory IconStepHeader.info({
    Key? key,
    required String title,
    required String subtitle,
    double iconSize = 64.0,
  }) {
    return IconStepHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      iconData: Icons.info_rounded,
      iconColor: AppColors.brandCrimson,
      iconSize: iconSize,
    );
  }

  /// 로딩 상태 헤더
  factory IconStepHeader.loading({
    Key? key,
    required String title,
    required String subtitle,
    double iconSize = 64.0,
  }) {
    return IconStepHeader(
      key: key,
      title: title,
      subtitle: subtitle,
      iconData: Icons.hourglass_empty_rounded,
      iconColor: AppColors.textSecondary,
      iconSize: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepHeader(
      title: title,
      subtitle: subtitle,
      textAlign: textAlign,
      icon: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    Widget iconWidget = Icon(
      iconData,
      size: iconSize.w,
      color: iconColor,
    );

    // 배경색이 있으면 원형 배경 추가
    if (iconBackgroundColor != null) {
      iconWidget = Container(
        width: (iconSize * 1.4).w,
        height: (iconSize * 1.4).h,
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: iconBackgroundColor!.withValues(alpha: 0.3),
              blurRadius: 12.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Center(child: iconWidget),
      );
    }

    // 입장 애니메이션 추가
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: iconWidget,
          ),
        );
      },
    );
  }
}

/// 단계별 번호가 표시되는 헤더
/// 
/// 진행 단계를 숫자로 명확히 보여주는 헤더입니다.
/// 온보딩이나 여러 단계가 있는 프로세스에 유용해요.
class NumberedStepHeader extends StatelessWidget {
  /// 현재 단계 번호
  final int stepNumber;

  /// 전체 단계 수
  final int totalSteps;

  /// 제목 텍스트
  final String title;

  /// 서브타이틀 (설명 텍스트)
  final String subtitle;

  /// 번호 원의 크기
  final double numberCircleSize;

  /// 번호 텍스트 색상
  final Color numberTextColor;

  /// 번호 배경 색상
  final Color numberBackgroundColor;

  const NumberedStepHeader({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
    this.numberCircleSize = 48.0,
    this.numberTextColor = Colors.white,
    this.numberBackgroundColor = AppColors.brandCrimson,
  });

  @override
  Widget build(BuildContext context) {
    return StepHeader(
      title: title,
      subtitle: subtitle,
      textAlign: TextAlign.center,
      icon: _buildNumberIcon(),
      spacing: 16.0,
    );
  }

  Widget _buildNumberIcon() {
    return Container(
      width: numberCircleSize.w,
      height: numberCircleSize.h,
      decoration: BoxDecoration(
        color: numberBackgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: numberBackgroundColor.withValues(alpha: 0.3),
            blurRadius: 8.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$stepNumber',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: numberTextColor,
              ),
            ),
            if (totalSteps > 1)
              Text(
                '/$totalSteps',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: numberTextColor.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}