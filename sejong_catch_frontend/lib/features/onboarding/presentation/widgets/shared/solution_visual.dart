import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ✨ 재사용 가능한 솔루션 비주얼 컴포넌트
/// 메인 체크 아이콘 + 그라데이션 + 멀티레이어 섀도우를 담당
class SolutionVisual extends StatelessWidget {
  final VisualSize size;
  final VisualStyle style;
  final AnimationController? controller;
  final IconData? customIcon;

  const SolutionVisual({
    super.key,
    this.size = VisualSize.medium,
    this.style = VisualStyle.success,
    this.controller,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final visualSize = _getVisualSize(screenHeight);
    final iconSize = _getIconSize(screenHeight);

    Widget visual = Container(
      width: visualSize,
      height: visualSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _getGradient(),
        boxShadow: _getBoxShadows(),
      ),
      child: Icon(
        customIcon ?? Icons.check_circle_rounded,
        color: Colors.white,
        size: iconSize,
      ),
    );

    // 애니메이션이 있으면 적용
    if (controller != null) {
      visual = visual
          .animate(controller: controller!)
          .scale(
            begin: const Offset(0.3, 0.3),
            duration: 800.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(delay: 400.ms, duration: 600.ms)
          .then()
          .shimmer(
            duration: 2500.ms,
            color: Colors.white.withValues(alpha: 0.6),
          );
    }

    return visual;
  }

  /// 📏 화면 크기별 비주얼 사이즈 계산
  double _getVisualSize(double screenHeight) {
    double baseSize;

    switch (size) {
      case VisualSize.small:
        baseSize = screenHeight < 700 ? 60.w : 80.w;
        break;
      case VisualSize.medium:
        baseSize = screenHeight < 700 ? 80.w :
                  screenHeight < 850 ? 110.w : 140.w;
        break;
      case VisualSize.large:
        baseSize = screenHeight < 700 ? 100.w :
                  screenHeight < 850 ? 130.w : 160.w;
        break;
    }

    return baseSize;
  }

  /// 📏 화면 크기별 아이콘 사이즈 계산
  double _getIconSize(double screenHeight) {
    final visualSize = _getVisualSize(screenHeight);
    return visualSize * 0.55; // 비주얼 크기의 55%
  }

  /// 🌈 스타일별 그라데이션 생성
  RadialGradient _getGradient() {
    final colors = style.colors;

    return RadialGradient(
      center: const Alignment(-0.3, -0.3),
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.7, 1.0],
    );
  }

  /// 🌟 프리미엄 멀티레이어 섀도우 생성
  List<BoxShadow> _getBoxShadows() {
    final primaryColor = style.colors.first;

    return [
      // 메인 컬러 섀도우
      BoxShadow(
        color: primaryColor.withValues(alpha: 0.4),
        blurRadius: 30,
        offset: const Offset(0, 10),
        spreadRadius: 2,
      ),
      // 액센트 섀도우 (골드)
      BoxShadow(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
        blurRadius: 40,
        offset: const Offset(0, 15),
        spreadRadius: -5,
      ),
      // 깊이감 섀도우 (블랙)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.1),
        blurRadius: 60,
        offset: const Offset(0, 25),
        spreadRadius: -10,
      ),
    ];
  }
}

/// 📐 비주얼 크기 타입
enum VisualSize {
  small,   // 작은 크기 (60-80w)
  medium,  // 중간 크기 (80-140w)
  large;   // 큰 크기 (100-160w)
}

/// 🎨 비주얼 스타일 타입
enum VisualStyle {
  success,    // 성공 (크림슨 → 다크크림슨 → 블러드레드)
  warning,    // 경고 (오렌지 → 다크오렌지 → 레드오렌지)
  info,       // 정보 (블루 → 다크블루 → 네이비)
  custom;     // 커스텀

  /// 스타일별 컬러 팔레트
  List<Color> get colors {
    switch (this) {
      case VisualStyle.success:
        return [
          const Color(0xFFDC143C),  // 크림슨 레드
          const Color(0xFFB0102F),  // 다크 크림슨
          const Color(0xFF8B0000),  // 블러드 레드
        ];
      case VisualStyle.warning:
        return [
          const Color(0xFFF59E0B),  // 골드
          const Color(0xFFD97706),  // 다크 골드
          const Color(0xFFB45309),  // 브론즈
        ];
      case VisualStyle.info:
        return [
          const Color(0xFF3B82F6),  // 블루
          const Color(0xFF1D4ED8),  // 다크 블루
          const Color(0xFF1E3A8A),  // 네이비
        ];
      case VisualStyle.custom:
        return [
          const Color(0xFF6366F1),  // 인디고
          const Color(0xFF4F46E5),  // 다크 인디고
          const Color(0xFF3730A3),  // 딥 인디고
        ];
    }
  }
}

/// 🎯 비주얼 테마 프리셋들 - 빠른 스타일링용
class SolutionVisualTheme {
  // 성공/완료 비주얼
  static const success = SolutionVisual(
    size: VisualSize.large,
    style: VisualStyle.success,
  );

  // 경고/주의 비주얼
  static const warning = SolutionVisual(
    size: VisualSize.medium,
    style: VisualStyle.warning,
  );

  // 정보/안내 비주얼
  static const info = SolutionVisual(
    size: VisualSize.medium,
    style: VisualStyle.info,
  );

  // 작은 성공 비주얼 (카드 내부용)
  static const smallSuccess = SolutionVisual(
    size: VisualSize.small,
    style: VisualStyle.success,
  );
}

/// 🔧 비주얼 빌더 - 커스텀 비주얼 생성용
class SolutionVisualBuilder {
  VisualSize _size = VisualSize.medium;
  VisualStyle _style = VisualStyle.success;
  IconData? _icon;
  AnimationController? _controller;

  SolutionVisualBuilder size(VisualSize size) {
    _size = size;
    return this;
  }

  SolutionVisualBuilder style(VisualStyle style) {
    _style = style;
    return this;
  }

  SolutionVisualBuilder icon(IconData icon) {
    _icon = icon;
    return this;
  }

  SolutionVisualBuilder animation(AnimationController controller) {
    _controller = controller;
    return this;
  }

  SolutionVisual build() {
    return SolutionVisual(
      size: _size,
      style: _style,
      customIcon: _icon,
      controller: _controller,
    );
  }
}