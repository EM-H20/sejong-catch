import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🎯 스마트 적응형 슬라이드 레이아웃 시스템
/// 화면 크기에 따라 동적으로 콘텐츠 배치를 최적화하는 핵심 컴포넌트
class AdaptiveSlideLayout extends StatelessWidget {
  final Widget header;
  final Widget visual;
  final Widget content;
  final EdgeInsets? padding;

  const AdaptiveSlideLayout({
    super.key,
    required this.header,
    required this.visual,
    required this.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final density = _getDensity(screenHeight);
          final layout = _calculateLayout(screenHeight, density);

          return Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // 🎯 상단 여백 (동적 조정)
                  SizedBox(height: layout.topPadding),

                  // 📱 헤더 영역 (유연한 높이, 최대 제한)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: layout.headerHeight,
                    ),
                    child: header,
                  ),

                  SizedBox(height: layout.headerBottomPadding),

                  // ✨ 비주얼 영역 (유연한 높이, 최대 제한)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: layout.visualHeight,
                    ),
                    child: Center(child: visual),
                  ),

                  SizedBox(height: layout.visualBottomPadding),

                  // 📋 콘텐츠 영역 (자연스러운 높이)
                  content,

                  // 🌊 하단 여백 (적응형)
                  SizedBox(height: layout.bottomPadding),

                  // 🛡️ 추가 안전 여백 (작은 화면 대응)
                  if (screenHeight < 700)
                    SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📐 화면 밀도 결정 - 콘텐츠를 얼마나 압축할지 결정
  ScreenDensity _getDensity(double height) {
    if (height < 700) return ScreenDensity.compact;   // 작은 폰: 모든 걸 작게
    if (height < 850) return ScreenDensity.balanced;  // 일반 폰: 적당한 크기
    return ScreenDensity.spacious;                    // 큰 폰: 여유롭게
  }

  /// 📊 스마트 레이아웃 계산기 - overflow 방지 완벽 보장!
  LayoutDimensions _calculateLayout(double screenHeight, ScreenDensity density) {
    // 🎯 1단계: 전체 패딩 계산 (고정값들)
    final totalPadding = density.topPadding +
                        (density.sectionPadding * 2) + // header-visual, visual-content 간격
                        density.bottomPadding;

    // 🎯 2단계: 패딩 제외한 실제 콘텐츠 높이 계산
    final availableContentHeight = screenHeight - totalPadding;

    // 🎯 3단계: 안전 마진 적용 (10% 여유분)
    final safeContentHeight = availableContentHeight * 0.90;

    // 🎯 4단계: 각 섹션에 비율 배분 (총합 100%)
    final headerHeight = safeContentHeight * 0.22;   // 22% (헤더 약간 줄임)
    final visualHeight = safeContentHeight * 0.43;   // 43% (Before/After 영역 확장)
    final contentHeight = safeContentHeight * 0.35;  // 35% (하단 메시지 줄임)

    return LayoutDimensions(
      headerHeight: headerHeight,
      visualHeight: visualHeight,
      contentHeight: contentHeight,
      topPadding: density.topPadding,
      headerBottomPadding: density.sectionPadding,
      visualBottomPadding: density.sectionPadding,
      bottomPadding: density.bottomPadding,
    );
  }
}

/// 📐 화면 밀도 타입 - 콘텐츠 압축 레벨
enum ScreenDensity {
  compact,   // 작은 화면: 최대한 압축해서 다 보이게
  balanced,  // 중간 화면: 적당한 여백으로 균형감
  spacious;  // 큰 화면: 여유로운 간격으로 편안하게

  /// 상단 패딩
  double get topPadding {
    switch (this) {
      case ScreenDensity.compact: return 16.h;
      case ScreenDensity.balanced: return 24.h;
      case ScreenDensity.spacious: return 32.h;
    }
  }

  /// 섹션 간 패딩
  double get sectionPadding {
    switch (this) {
      case ScreenDensity.compact: return 12.h;
      case ScreenDensity.balanced: return 20.h;
      case ScreenDensity.spacious: return 28.h;
    }
  }

  /// 하단 패딩
  double get bottomPadding {
    switch (this) {
      case ScreenDensity.compact: return 16.h;
      case ScreenDensity.balanced: return 24.h;
      case ScreenDensity.spacious: return 32.h;
    }
  }
}

/// 📏 레이아웃 치수 데이터 클래스
class LayoutDimensions {
  final double headerHeight;
  final double visualHeight;
  final double contentHeight;
  final double topPadding;
  final double headerBottomPadding;
  final double visualBottomPadding;
  final double bottomPadding;

  const LayoutDimensions({
    required this.headerHeight,
    required this.visualHeight,
    required this.contentHeight,
    required this.topPadding,
    required this.headerBottomPadding,
    required this.visualBottomPadding,
    required this.bottomPadding,
  });
}