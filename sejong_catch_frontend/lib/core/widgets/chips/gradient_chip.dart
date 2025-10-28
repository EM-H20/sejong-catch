import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/text_styles.dart';

/// 🎨 그라데이션 칩 (정보 강조 태그)
///
/// 둥근 모서리 컨테이너 + 배경색 + 텍스트로 구성된 칩
/// 정보 강조, 태그, 상태 표시, 필터 칩 등에 활용
///
/// Features:
/// ✅ 커스텀 배경색/텍스트 색상 지원 (기본: brandCrimsonLight/brandCrimson)
/// ✅ 커스텀 패딩 지원
/// ✅ 탭 제스처 지원 (선택적)
/// ✅ AppSpacing, AppTextStyles 사용
/// ✅ ScreenUtil 반응형 적용
///
/// Usage:
/// ```dart
/// GradientChip(
///   text: '공모전·취업·논문·학교공지를 한 곳에서',
/// )
///
/// GradientChip(
///   text: '마감임박',
///   backgroundColor: AppColors.error,
///   textColor: AppColors.pureWhite,
///   onTap: () => print('Tapped!'),
/// )
/// ```
class GradientChip extends StatelessWidget {
  /// 표시할 텍스트
  final String text;

  /// 배경색 (기본: brandCrimsonLight)
  final Color? backgroundColor;

  /// 텍스트 색상 (기본: brandCrimson)
  final Color? textColor;

  /// 커스텀 패딩 (기본: symmetric(horizontal: 16, vertical: 12))
  final EdgeInsets? padding;

  /// 탭 이벤트 핸들러 (선택적)
  final VoidCallback? onTap;

  /// 둥근 모서리 반경 (기본: 20.r)
  final double? borderRadius;

  const GradientChip({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: padding ?? AppSpacing.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyLarge.copyWith(
          color: textColor ?? AppColors.brandCrimson,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );

    // 탭 이벤트가 있으면 InkWell로 감싸기
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        child: chip,
      );
    }

    return chip;
  }
}
