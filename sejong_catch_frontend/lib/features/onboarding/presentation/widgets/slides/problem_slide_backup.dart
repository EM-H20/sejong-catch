import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🚀 스마트 적응형 Problem 슬라이드 - "세련된 임팩트" 전략!
/// 화면 크기별 3단계 적응형: 안전성 + 임팩트 동시 확보
class ProblemSlide extends StatefulWidget {
  const ProblemSlide({super.key});

  @override
  State<ProblemSlide> createState() => _ProblemSlideState();
}

class _ProblemSlideState extends State<ProblemSlide>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // 슬라이드 진입 시 애니메이션 시작
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenType = _getScreenType(screenHeight);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // 🌟 스마트 상단 여백
                    SizedBox(height: screenType.topPadding),

                    // 💥 적응형 임팩트 타이틀
                    _buildAdaptiveTitle(screenType),

                    SizedBox(height: screenType.middlePadding),

                    // 😰 프리미엄 Problem 비주얼
                    _buildPremiumVisual(screenType),

                    SizedBox(height: screenType.bottomPadding),

                    // 📝 세련된 문제 요약
                    _buildStylishSummary(screenType),

                    // 하단 여백 (유연하게)
                    SizedBox(height: screenType.bottomMargin),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📐 화면 크기 타입 결정 - 스마트한 3단계 분류
  ScreenType _getScreenType(double height) {
    if (height < 700) {
      return ScreenType.compact; // iPhone SE, 작은 안드로이드
    } else if (height < 850) {
      return ScreenType.medium;  // 일반적인 폰들
    } else {
      return ScreenType.large;   // 큰 폰들, 태블릿
    }
  }

  /// 💥 적응형 임팩트 타이틀 - 화면별 최적 크기!
  Widget _buildAdaptiveTitle(ScreenType screenType) {
    return Column(
      children: [
        // 첫 번째 줄 - 세련된 질문
        Text(
          "이런 일로",
          style: TextStyle(
            fontSize: screenType.subtitleSize,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF6B7280),
            height: 1.2,
          ),
        )
        .animate(controller: _controller)
        .slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOutExpo)
        .fadeIn(duration: 400.ms),

        SizedBox(height: 6.h),

        // 두 번째 줄 - 강력한 임팩트 (프리미엄 그라데이션!)
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              const Color(0xFF1F2937),
              const Color(0xFFDC143C),
              const Color(0xFF1F2937),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            "시간 낭비하셨나요?",
            style: TextStyle(
              fontSize: screenType.titleSize,
              fontWeight: FontWeight.w800,
              color: Colors.white, // ShaderMask가 적용됨
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        )
        .animate(controller: _controller)
        .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutExpo)
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .then()
        .shimmer(duration: 2000.ms, color: const Color(0xFFDC143C).withValues(alpha: 0.3)),
      ],
    );
  }

  /// 😰 프리미엄 Problem 비주얼 - 고급스러운 멀티레이어!
  Widget _buildPremiumVisual(ScreenType screenType) {
    return Container(
      width: screenType.visualSize,
      height: screenType.visualSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // 프리미엄 멀티레이어 그라데이션
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.3),
          radius: 1.2,
          colors: [
            const Color(0xFFDC143C).withValues(alpha: 0.15),
            const Color(0xFFF59E0B).withValues(alpha: 0.12),
            const Color(0xFF8B5CF6).withValues(alpha: 0.08),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        // 고급스러운 멀티레이어 섀도우
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            blurRadius: 50,
            offset: const Offset(0, 20),
            spreadRadius: -5,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFDC143C).withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 세련된 배경 아이콘들 - 적응형 크기
          ...List.generate(4, (index) {
            final positions = [
              Offset(0.25, 0.2),   // 📚
              Offset(0.8, 0.3),    // 💻
              Offset(0.2, 0.75),   // 📄
              Offset(0.75, 0.8),   // 🔍
            ];
            final icons = ["📚", "💻", "📄", "🔍"];
            final delays = [300, 400, 500, 450];

            return Positioned(
              left: positions[index].dx * screenType.visualSize - 10.w,
              top: positions[index].dy * screenType.visualSize - 10.h,
              child: Text(
                icons[index],
                style: TextStyle(fontSize: screenType.iconSize),
              )
              .animate(controller: _controller)
              .slideX(
                begin: index.isEven ? -0.5 : 0.5,
                delay: delays[index].ms,
                duration: 800.ms,
                curve: Curves.easeOutExpo,
              )
              .fadeIn(delay: delays[index].ms),
            );
          }),

          // 중앙 메인 이모지 - 적응형 크기
          Text(
            "🤯",
            style: TextStyle(fontSize: screenType.emojiSize),
          )
          .animate(controller: _controller)
          .scale(
            begin: const Offset(0.3, 0.3),
            duration: 800.ms,
            curve: Curves.elasticOut,
          )
          .fadeIn(delay: 200.ms, duration: 500.ms)
          .then()
          .shake(duration: 1000.ms, hz: 1.5),
        ],
      ),
    );
  }

  /// 📝 세련된 문제 요약 - 프리미엄 글래스모피즘!
  Widget _buildStylishSummary(ScreenType screenType) {
    return Container(
      padding: EdgeInsets.all(screenType.cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        // 글래스모피즘 효과
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        children: [
          // 메인 메시지 - 적응형 크기
          Text(
            "정보 찾느라 밤새고,\n공지 놓쳐서 후회하고...",
            style: TextStyle(
              fontSize: screenType.bodyLargeSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10.h),

          // 서브 메시지 - 적응형 크기
          Text(
            "이제 그만! 세종 캐치가 해결해드릴게요",
            style: TextStyle(
              fontSize: screenType.bodySmallSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
    .animate(controller: _controller)
    .slideY(begin: 0.2, delay: 700.ms, duration: 600.ms, curve: Curves.easeOutExpo)
    .fadeIn(delay: 700.ms, duration: 500.ms)
    .then()
    .shimmer(duration: 2500.ms, color: const Color(0xFFDC143C).withValues(alpha: 0.1));
  }
}

/// 📐 화면 타입별 스마트 크기 시스템
enum ScreenType {
  compact,  // <700h: iPhone SE, 작은 안드로이드
  medium,   // 700-850h: 일반적인 폰들
  large;    // >850h: 큰 폰들, 태블릿

  // 🎯 상단 여백
  double get topPadding {
    switch (this) {
      case ScreenType.compact: return 20.h;
      case ScreenType.medium:  return 30.h;
      case ScreenType.large:   return 40.h;
    }
  }

  // 🎯 중간 여백
  double get middlePadding {
    switch (this) {
      case ScreenType.compact: return 20.h;
      case ScreenType.medium:  return 28.h;
      case ScreenType.large:   return 36.h;
    }
  }

  // 🎯 하단 여백
  double get bottomPadding {
    switch (this) {
      case ScreenType.compact: return 16.h;
      case ScreenType.medium:  return 20.h;
      case ScreenType.large:   return 24.h;
    }
  }

  // 🎯 최하단 마진
  double get bottomMargin {
    switch (this) {
      case ScreenType.compact: return 20.h;
      case ScreenType.medium:  return 30.h;
      case ScreenType.large:   return 40.h;
    }
  }

  // 📝 타이틀 크기
  double get titleSize {
    switch (this) {
      case ScreenType.compact: return 26.sp;
      case ScreenType.medium:  return 32.sp;
      case ScreenType.large:   return 38.sp;
    }
  }

  // 📝 서브타이틀 크기
  double get subtitleSize {
    switch (this) {
      case ScreenType.compact: return 20.sp;
      case ScreenType.medium:  return 24.sp;
      case ScreenType.large:   return 28.sp;
    }
  }

  // 🎨 비주얼 크기
  double get visualSize {
    switch (this) {
      case ScreenType.compact: return 100.w;
      case ScreenType.medium:  return 130.w;
      case ScreenType.large:   return 160.w;
    }
  }

  // 😀 이모지 크기
  double get emojiSize {
    switch (this) {
      case ScreenType.compact: return 45.sp;
      case ScreenType.medium:  return 60.sp;
      case ScreenType.large:   return 75.sp;
    }
  }

  // 🔤 아이콘 크기
  double get iconSize {
    switch (this) {
      case ScreenType.compact: return 12.sp;
      case ScreenType.medium:  return 15.sp;
      case ScreenType.large:   return 18.sp;
    }
  }

  // 📦 카드 패딩
  double get cardPadding {
    switch (this) {
      case ScreenType.compact: return 16.w;
      case ScreenType.medium:  return 20.w;
      case ScreenType.large:   return 24.w;
    }
  }

  // 📝 본문 큰 글씨
  double get bodyLargeSize {
    switch (this) {
      case ScreenType.compact: return 15.sp;
      case ScreenType.medium:  return 17.sp;
      case ScreenType.large:   return 19.sp;
    }
  }

  // 📝 본문 작은 글씨
  double get bodySmallSize {
    switch (this) {
      case ScreenType.compact: return 13.sp;
      case ScreenType.medium:  return 14.sp;
      case ScreenType.large:   return 15.sp;
    }
  }
}