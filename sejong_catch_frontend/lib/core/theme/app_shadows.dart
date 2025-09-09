import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Nucleus UI Design System 그림자 및 고급 스타일링 정의
/// 일관된 elevation과 visual depth를 제공하는 그림자 시스템
class AppShadows {
  // ============================================================================
  // ELEVATION SHADOWS - Material Design 3 기반
  // ============================================================================

  /// Level 0 - 그림자 없음
  static const List<BoxShadow> none = [];

  /// Level 1 - 가벼운 그림자 (버튼 hover, 칩)
  static List<BoxShadow> level1(BuildContext context) {
    final shadowColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkDarkest.withValues(alpha: 0.05)
        : AppColors.inkDarkest.withValues(alpha: 0.15);
    
    return [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ];
  }

  /// Level 2 - 기본 카드 그림자
  static List<BoxShadow> level2(BuildContext context) {
    final shadowColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkDarkest.withValues(alpha: 0.08)
        : AppColors.inkDarkest.withValues(alpha: 0.2);
    
    return [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];
  }

  /// Level 3 - 강조된 카드, 네비게이션
  static List<BoxShadow> level3(BuildContext context) {
    final shadowColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkDarkest.withValues(alpha: 0.1)
        : AppColors.inkDarkest.withValues(alpha: 0.25);
    
    return [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 4),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  /// Level 4 - 플로팅 액션 버튼, 중요한 요소
  static List<BoxShadow> level4(BuildContext context) {
    final shadowColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkDarkest.withValues(alpha: 0.12)
        : AppColors.inkDarkest.withValues(alpha: 0.3);
    
    return [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 6),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  /// Level 5 - 모달, 다이얼로그
  static List<BoxShadow> level5(BuildContext context) {
    final shadowColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.inkDarkest.withValues(alpha: 0.15)
        : AppColors.inkDarkest.withValues(alpha: 0.35);
    
    return [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0, 8),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ];
  }

  // ============================================================================
  // COLORED SHADOWS - 특별한 시각적 효과
  // ============================================================================

  /// Primary 색상 그림자 (특별한 강조용)
  static List<BoxShadow> primaryGlow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  /// Success 색상 그림자 (성공 상태)
  static List<BoxShadow> successGlow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.success.withValues(alpha: 0.25),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  /// Error 색상 그림자 (에러 상태)
  static List<BoxShadow> errorGlow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.error.withValues(alpha: 0.25),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  /// Warning 색상 그림자 (경고 상태)
  static List<BoxShadow> warningGlow(BuildContext context) {
    return [
      BoxShadow(
        color: AppColors.warning.withValues(alpha: 0.25),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ];
  }

  // ============================================================================
  // INNER SHADOWS - 함몰 효과
  // ============================================================================

  /// Inner shadow 효과 (CSS box-shadow inset과 유사)
  /// Flutter에서는 직접 지원하지 않으므로 Container + CustomPainter로 구현
  static BoxDecoration innerShadow(BuildContext context, {
    Color? shadowColor,
    Offset offset = const Offset(0, 2),
    double blurRadius = 4,
  }) {
    final color = shadowColor ?? 
        (Theme.of(context).brightness == Brightness.light
            ? AppColors.inkDarkest.withValues(alpha: 0.1)
            : AppColors.inkDarkest.withValues(alpha: 0.2));
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          Colors.transparent,
          Colors.transparent,
          color.withValues(alpha: color.a * 0.5),
        ],
        stops: const [0.0, 0.1, 0.9, 1.0],
      ),
    );
  }

  // ============================================================================
  // CUSTOM SHADOW EFFECTS
  // ============================================================================

  /// 네온 글로우 효과 (Primary 컬러)
  static List<BoxShadow> neonGlow({
    Color? glowColor,
    double intensity = 1.0,
  }) {
    final color = glowColor ?? AppColors.primary;
    
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.6 * intensity),
        offset: const Offset(0, 0),
        blurRadius: 4,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.3 * intensity),
        offset: const Offset(0, 0),
        blurRadius: 8,
        spreadRadius: 4,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.1 * intensity),
        offset: const Offset(0, 0),
        blurRadius: 16,
        spreadRadius: 8,
      ),
    ];
  }

  /// 드롭 섀도우 효과 (이미지나 텍스트용)
  static List<Shadow> dropShadow(BuildContext context, {
    Color? shadowColor,
    Offset offset = const Offset(0, 2),
    double blurRadius = 4,
  }) {
    final color = shadowColor ?? 
        (Theme.of(context).brightness == Brightness.light
            ? AppColors.inkDarkest.withValues(alpha: 0.3)
            : AppColors.inkDarkest.withValues(alpha: 0.5));
    
    return [
      Shadow(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
      ),
    ];
  }

  // ============================================================================
  // BORDER EFFECTS
  // ============================================================================

  /// 기본 테두리
  static Border defaultBorder(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.skyBase
        : AppColors.inkLight;
    
    return Border.all(
      color: borderColor,
      width: 1,
    );
  }

  /// 강조된 테두리 (선택된 상태)
  static Border activeBorder(BuildContext context) {
    return Border.all(
      color: AppColors.primary,
      width: 2,
    );
  }

  /// 에러 테두리
  static Border errorBorder(BuildContext context) {
    return Border.all(
      color: AppColors.error,
      width: 1,
    );
  }

  /// 성공 테두리
  static Border successBorder(BuildContext context) {
    return Border.all(
      color: AppColors.success,
      width: 1,
    );
  }

  // ============================================================================
  // GRADIENT EFFECTS
  // ============================================================================

  /// 메인 브랜드 그라데이션 박스
  static BoxDecoration primaryGradientBox({
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      boxShadow: boxShadow,
    );
  }

  /// 성공 그라데이션 박스
  static BoxDecoration successGradientBox({
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      gradient: AppColors.successGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      boxShadow: boxShadow,
    );
  }

  /// 글래스모피즘 효과
  static BoxDecoration glassmorphism(BuildContext context, {
    double opacity = 0.1,
    double blur = 10,
    BorderRadius? borderRadius,
  }) {
    final backgroundColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.skyWhite.withValues(alpha: opacity)
        : AppColors.inkBase.withValues(alpha: opacity);
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.skyLight.withValues(alpha: 0.5)
            : AppColors.inkLight.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: level2(context),
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// 그림자 강도 조절
  static List<BoxShadow> adjustShadowIntensity(
    List<BoxShadow> shadows,
    double intensity,
  ) {
    return shadows
        .map((shadow) => shadow.copyWith(
              color: shadow.color.withValues(
                alpha: shadow.color.a * intensity,
              ),
            ))
        .toList();
  }

  /// 그림자 색상 변경
  static List<BoxShadow> changeShadowColor(
    List<BoxShadow> shadows,
    Color newColor,
  ) {
    return shadows
        .map((shadow) => shadow.copyWith(
              color: newColor.withValues(alpha: shadow.color.a),
            ))
        .toList();
  }

  /// 반응형 그림자 (화면 크기에 따라 조절)
  static List<BoxShadow> responsive(
    BuildContext context,
    List<BoxShadow> baseShadows,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth < 600 ? 0.8 : 1.0;
    
    return baseShadows
        .map((shadow) => shadow.copyWith(
              blurRadius: shadow.blurRadius * scaleFactor,
              spreadRadius: shadow.spreadRadius * scaleFactor,
            ))
        .toList();
  }

  // ============================================================================
  // PRESET COMBINATIONS
  // ============================================================================

  /// 카드용 완성된 BoxDecoration
  static BoxDecoration cardDecoration(BuildContext context, {
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool elevated = true,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? 
          (Theme.of(context).brightness == Brightness.light
              ? AppColors.skyWhite
              : AppColors.inkBase),
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      boxShadow: elevated ? level2(context) : none,
      border: Theme.of(context).brightness == Brightness.dark
          ? Border.all(
              color: AppColors.inkLight.withValues(alpha: 0.1),
              width: 1,
            )
          : null,
    );
  }

  /// 버튼용 완성된 BoxDecoration
  static BoxDecoration buttonDecoration(
    BuildContext context, {
    Color? backgroundColor,
    BorderRadius? borderRadius,
    bool isPrimary = true,
    bool isPressed = false,
  }) {
    final bgColor = backgroundColor ??
        (isPrimary ? AppColors.primary : AppColors.skyLight);
    
    return BoxDecoration(
      color: isPressed ? AppColors.darken(bgColor, 0.1) : bgColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      boxShadow: isPressed ? level1(context) : level2(context),
    );
  }

  /// 모달/다이얼로그용 완성된 BoxDecoration
  static BoxDecoration modalDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).brightness == Brightness.light
          ? AppColors.skyWhite
          : AppColors.inkBase,
      borderRadius: BorderRadius.circular(16),
      boxShadow: level5(context),
      border: Theme.of(context).brightness == Brightness.dark
          ? Border.all(
              color: AppColors.inkLight.withValues(alpha: 0.2),
              width: 1,
            )
          : null,
    );
  }
}