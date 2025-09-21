import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🎯 재사용 가능한 슬라이드 헤더 컴포넌트
/// 브랜드 타이틀 + 그라데이션 서브타이틀을 담당하는 스마트 위젯
class SlideHeader extends StatelessWidget {
  final String brandTitle;
  final String subtitle;
  final AnimationController? controller;
  final bool useGradient;
  final List<Color>? gradientColors;

  const SlideHeader({
    super.key,
    required this.brandTitle,
    required this.subtitle,
    this.controller,
    this.useGradient = true,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 🏷️ 브랜드 타이틀 (적응형 크기)
        _buildBrandTitle(context),

        SizedBox(height: 8.h),

        // ✨ 서브타이틀 (그라데이션 효과)
        _buildSubtitle(context),
      ],
    );
  }

  /// 🏷️ 브랜드 타이틀 빌더 - "세종 캐치가" 스타일
  Widget _buildBrandTitle(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSize = _getTitleSize(screenHeight);

    // 브랜드명을 단어별로 분리해서 스타일링
    final brandWords = brandTitle.split(' ');

    Widget titleWidget = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: brandWords.asMap().entries.map((entry) {
          final index = entry.key;
          final word = entry.value;

          return TextSpan(
            text: index == brandWords.length - 1 ? word : '$word ',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: index == 0 ? FontWeight.w800 :
                         index == 1 ? FontWeight.w800 : FontWeight.w300,
              color: index == 0 ? const Color(0xFFDC143C) :  // "세종" - 크림슨
                     index == 1 ? const Color(0xFF1F2937) :  // "캐치" - 다크 그레이
                     const Color(0xFF6B7280),                // "가" - 라이트 그레이
              height: 1.1,
            ),
          );
        }).toList(),
      ),
    );

    // 애니메이션이 있으면 적용
    if (controller != null) {
      titleWidget = titleWidget
          .animate(controller: controller!)
          .slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOutExpo)
          .fadeIn(duration: 400.ms);
    }

    return titleWidget;
  }

  /// ✨ 서브타이틀 빌더 - 그라데이션 효과 적용
  Widget _buildSubtitle(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final subtitleSize = _getSubtitleSize(screenHeight);

    Widget subtitleWidget;

    if (useGradient) {
      // 그라데이션 텍스트
      subtitleWidget = ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ?? _getDefaultGradientColors(),
          stops: const [0.0, 0.5, 1.0],
        ).createShader(bounds),
        child: Text(
          subtitle,
          style: TextStyle(
            fontSize: subtitleSize,
            fontWeight: FontWeight.w700,
            color: Colors.white, // ShaderMask가 색상 적용
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // 일반 텍스트
      subtitleWidget = Text(
        subtitle,
        style: TextStyle(
          fontSize: subtitleSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1F2937),
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      );
    }

    // 애니메이션이 있으면 적용
    if (controller != null) {
      subtitleWidget = subtitleWidget
          .animate(controller: controller!)
          .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutExpo)
          .fadeIn(delay: 200.ms, duration: 400.ms);
    }

    return subtitleWidget;
  }

  /// 📏 화면 크기별 타이틀 사이즈 계산
  double _getTitleSize(double screenHeight) {
    if (screenHeight < 700) return 24.sp;  // compact
    if (screenHeight < 850) return 30.sp;  // medium
    return 36.sp;                          // large
  }

  /// 📏 화면 크기별 서브타이틀 사이즈 계산
  double _getSubtitleSize(double screenHeight) {
    if (screenHeight < 700) return 16.sp;  // compact
    if (screenHeight < 850) return 20.sp;  // medium
    return 24.sp;                          // large
  }

  /// 🌈 기본 그라데이션 컬러 - 크림슨 → 골드 → 크림슨
  List<Color> _getDefaultGradientColors() {
    return [
      const Color(0xFFDC143C),  // 크림슨 레드
      const Color(0xFFF59E0B),  // 골드
      const Color(0xFFDC143C),  // 크림슨 레드
    ];
  }
}

/// 🎨 헤더 테마 프리셋들 - 빠른 스타일링용
class SlideHeaderTheme {
  // 기본 솔루션 테마
  static const solution = SlideHeaderStyle(
    gradientColors: [
      Color(0xFFDC143C),  // 크림슨
      Color(0xFFF59E0B),  // 골드
      Color(0xFFDC143C),  // 크림슨
    ],
  );

  // 문제 제기 테마
  static const problem = SlideHeaderStyle(
    gradientColors: [
      Color(0xFFDC2626),  // 레드
      Color(0xFFEF4444),  // 라이트 레드
      Color(0xFFDC2626),  // 레드
    ],
  );

  // 성공 테마
  static const success = SlideHeaderStyle(
    gradientColors: [
      Color(0xFF059669),  // 그린
      Color(0xFF10B981),  // 에메랄드
      Color(0xFF059669),  // 그린
    ],
  );
}

/// 🎨 헤더 스타일 데이터 클래스
class SlideHeaderStyle {
  final List<Color> gradientColors;
  final bool useGradient;

  const SlideHeaderStyle({
    required this.gradientColors,
    this.useGradient = true,
  });
}