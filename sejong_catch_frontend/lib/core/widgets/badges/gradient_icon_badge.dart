import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_shadows.dart';

/// 🎨 그라데이션 아이콘 배지
///
/// 둥근 모서리의 정사각형/직사각형 그라데이션 배경에 아이콘을 표시하는 위젯
///
/// Features:
/// ✅ 커스텀 그라데이션 색상 지원 (기본: brandCrimson)
/// ✅ 크기 조절 가능 (아이콘 크기 자동 조정)
/// ✅ 그림자 효과 on/off (AppShadows 사용)
/// ✅ 둥근 모서리 비율 조절 가능
/// ✅ ScreenUtil 반응형 적용
///
/// Usage:
/// ```dart
/// GradientIconBadge(
///   icon: Icons.celebration_rounded,
///   size: 100.w,
/// )
///
/// GradientIconBadge(
///   icon: Icons.star,
///   size: 60.w,
///   gradientColors: [Colors.purple, Colors.deepPurple],
///   withShadow: false,
/// )
/// ```
class GradientIconBadge extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 배지 크기 (정사각형)
  final double size;

  /// 그라데이션 색상 리스트 (null이면 기본 brandCrimson 그라데이션)
  final List<Color>? gradientColors;

  /// 아이콘 크기 비율 (배지 크기 대비, 기본 0.5 = 50%)
  final double iconSizeFactor;

  /// 둥근 모서리 비율 (배지 크기 대비, 기본 0.25 = 25%)
  final double borderRadiusFactor;

  /// 그림자 효과 표시 여부
  final bool withShadow;

  /// 아이콘 색상 (기본: white)
  final Color? iconColor;

  const GradientIconBadge({
    super.key,
    required this.icon,
    required this.size,
    this.gradientColors,
    this.iconSizeFactor = 0.5,
    this.borderRadiusFactor = 0.25,
    this.withShadow = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [AppColors.brandCrimson, AppColors.brandCrimsonDark];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(size * borderRadiusFactor),
        boxShadow: withShadow
            ? AppShadows.custom(
                color: colors.first,
                blurRadius: 15,
                offset: Offset(0, 8.h),
                alpha: 0.3,
              )
            : null,
      ),
      child: Icon(
        icon,
        size: size * iconSizeFactor,
        color: iconColor ?? AppColors.white,
      ),
    );
  }
}
