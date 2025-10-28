import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_shadows.dart';

/// 🎨 그라데이션 원형 배지
///
/// 완전한 원형(BoxShape.circle) 그라데이션 배경에 아이콘을 표시하는 위젯
/// 히어로 섹션, 프로필 아바타, 카테고리 아이콘 등에 활용
///
/// Features:
/// ✅ 완전한 원형 디자인 (BoxShape.circle)
/// ✅ 커스텀 그라데이션 색상 지원 (기본: brandCrimson)
/// ✅ 크기 조절 가능 (아이콘 크기 자동 조정)
/// ✅ 그림자 효과 on/off (AppShadows 사용)
/// ✅ ScreenUtil 반응형 적용
///
/// Usage:
/// ```dart
/// GradientCircleBadge(
///   icon: Icons.school_rounded,
///   size: 180.w,
/// )
///
/// GradientCircleBadge(
///   icon: Icons.person,
///   size: 120.w,
///   gradientColors: [Colors.blue, Colors.blueAccent],
///   withShadow: false,
/// )
/// ```
class GradientCircleBadge extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 배지 크기 (원형 지름)
  final double size;

  /// 그라데이션 색상 리스트 (null이면 기본 brandCrimson 그라데이션)
  final List<Color>? gradientColors;

  /// 아이콘 크기 비율 (배지 크기 대비, 기본 0.5 = 50%)
  final double iconSizeFactor;

  /// 그림자 효과 표시 여부
  final bool withShadow;

  /// 아이콘 색상 (기본: white)
  final Color? iconColor;

  const GradientCircleBadge({
    super.key,
    required this.icon,
    required this.size,
    this.gradientColors,
    this.iconSizeFactor = 0.5,
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
        shape: BoxShape.circle,
        boxShadow: withShadow
            ? AppShadows.custom(
                color: colors.first,
                blurRadius: 30,
                offset: Offset(0, 15.h),
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
