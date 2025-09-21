import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../shared/value_card_list.dart';

/// 💫 애니메이션이 적용된 가치 카드 컴포넌트
/// 글래스모피즘 디자인 + 순차 애니메이션 + 호버 효과
class AnimatedValueCard extends StatelessWidget {
  final ValueItem value;
  final int index;
  final AnimationController? controller;
  final ValueCardStyle style;

  const AnimatedValueCard({
    super.key,
    required this.value,
    required this.index,
    this.controller,
    this.style = ValueCardStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final dimensions = _getCardDimensions(screenHeight);

    Widget card = Container(
      padding: EdgeInsets.all(dimensions.padding),
      decoration: _getCardDecoration(),
      child: Row(
        children: [
          // 🎨 아이콘 영역 (왼쪽)
          _buildIconContainer(dimensions),

          SizedBox(width: 16.w),

          // 📝 텍스트 영역 (중간)
          Expanded(child: _buildTextSection(dimensions)),

          // ✅ 체크 아이콘 (오른쪽)
          _buildCheckIcon(dimensions),
        ],
      ),
    );

    // 애니메이션이 있으면 적용
    if (controller != null) {
      card = card
          .animate(controller: controller!)
          .slideX(
            begin: index.isEven ? -0.3 : 0.3,
            duration: 600.ms,
            delay: (600 + index * 150).ms,
            curve: Curves.easeOutExpo,
          )
          .fadeIn(delay: (600 + index * 150).ms, duration: 500.ms)
          .then()
          .shimmer(
            delay: (1000 + index * 300).ms,
            duration: 1500.ms,
            color: value.color.withValues(alpha: 0.1),
          );
    }

    return card;
  }

  /// 📏 화면 크기별 카드 치수 계산
  CardDimensions _getCardDimensions(double screenHeight) {
    switch (style) {
      case ValueCardStyle.compact:
        return CardDimensions(
          padding: screenHeight < 700 ? 12.w : 14.w,
          iconSize: screenHeight < 700 ? 32.w : 36.w,
          titleSize: screenHeight < 700 ? 12.sp : 14.sp,
          subtitleSize: screenHeight < 700 ? 10.sp : 11.sp,
          checkSize: screenHeight < 700 ? 20.w : 22.w,
        );
      case ValueCardStyle.minimal:
        return CardDimensions(
          padding: screenHeight < 700 ? 16.w : 18.w,
          iconSize: screenHeight < 700 ? 36.w : 40.w,
          titleSize: screenHeight < 700 ? 13.sp : 15.sp,
          subtitleSize: screenHeight < 700 ? 11.sp : 12.sp,
          checkSize: screenHeight < 700 ? 22.w : 24.w,
        );
      case ValueCardStyle.normal:
        return CardDimensions(
          padding: screenHeight < 700 ? 10.w : screenHeight < 850 ? 14.w : 18.w,
          iconSize: screenHeight < 700 ? 32.w : screenHeight < 850 ? 40.w : 48.w,
          titleSize: screenHeight < 700 ? 12.sp : screenHeight < 850 ? 14.sp : 16.sp,
          subtitleSize: screenHeight < 700 ? 10.sp : screenHeight < 850 ? 11.sp : 13.sp,
          checkSize: screenHeight < 700 ? 20.w : screenHeight < 850 ? 24.w : 28.w,
        );
    }
  }

  /// 🎨 카드 장식 생성 (글래스모피즘)
  BoxDecoration _getCardDecoration() {
    final intensity = style == ValueCardStyle.minimal ? 0.5 : 1.0;

    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      // 글래스모피즘 배경
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.95 * intensity),
          Colors.white.withValues(alpha: 0.85 * intensity),
        ],
      ),
      border: Border.all(
        color: value.color.withValues(alpha: 0.3),
        width: 1.5,
      ),
      boxShadow: style == ValueCardStyle.minimal ? _getMinimalShadows() : _getPremiumShadows(),
    );
  }

  /// 🌟 프리미엄 섀도우 (일반/컴팩트 스타일용)
  List<BoxShadow> _getPremiumShadows() {
    return [
      BoxShadow(
        color: value.color.withValues(alpha: 0.15),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: 0.05),
        blurRadius: 30,
        offset: const Offset(0, 12),
        spreadRadius: -8,
      ),
    ];
  }

  /// 🌫️ 미니멀 섀도우 (미니멀 스타일용)
  List<BoxShadow> _getMinimalShadows() {
    return [
      BoxShadow(
        color: value.color.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  /// 🎨 아이콘 컨테이너 생성
  Widget _buildIconContainer(CardDimensions dimensions) {
    return Container(
      width: dimensions.iconSize,
      height: dimensions.iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            value.color.withValues(alpha: 0.2),
            value.color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          value.icon,
          style: TextStyle(fontSize: dimensions.iconSize * 0.45),
        ),
      ),
    );
  }

  /// 📝 텍스트 섹션 생성
  Widget _buildTextSection(CardDimensions dimensions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.title,
          style: TextStyle(
            fontSize: dimensions.titleSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            height: 1.3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value.subtitle,
          style: TextStyle(
            fontSize: dimensions.subtitleSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  /// ✅ 체크 아이콘 생성
  Widget _buildCheckIcon(CardDimensions dimensions) {
    return Container(
      width: dimensions.checkSize,
      height: dimensions.checkSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            value.color,
            value.color.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: value.color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: dimensions.checkSize * 0.6,
      ),
    );
  }
}

/// 📏 카드 치수 데이터 클래스
class CardDimensions {
  final double padding;
  final double iconSize;
  final double titleSize;
  final double subtitleSize;
  final double checkSize;

  const CardDimensions({
    required this.padding,
    required this.iconSize,
    required this.titleSize,
    required this.subtitleSize,
    required this.checkSize,
  });
}

/// 🎯 애니메이션 프리셋들 - 빠른 애니메이션 설정용
class CardAnimationPresets {
  // 순차 등장 애니메이션
  static Widget slideInSequence({
    required ValueItem value,
    required int index,
    required AnimationController controller,
    ValueCardStyle style = ValueCardStyle.normal,
  }) {
    return AnimatedValueCard(
      value: value,
      index: index,
      controller: controller,
      style: style,
    );
  }

  // 동시 등장 애니메이션
  static Widget fadeInTogether({
    required ValueItem value,
    required AnimationController controller,
    ValueCardStyle style = ValueCardStyle.normal,
  }) {
    return AnimatedValueCard(
      value: value,
      index: 0, // 모두 같은 타이밍
      controller: controller,
      style: style,
    );
  }
}