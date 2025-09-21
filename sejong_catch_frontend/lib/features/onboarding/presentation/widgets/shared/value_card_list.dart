import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../interactive/animated_value_card.dart';

/// 📋 가치 카드 리스트 관리 컴포넌트
/// 3개의 핵심 가치 카드들의 배치와 순차 애니메이션을 담당
class ValueCardList extends StatelessWidget {
  final List<ValueItem> values;
  final AnimationController? controller;
  final EdgeInsets? padding;
  final double? spacing;
  final ValueCardStyle cardStyle;

  const ValueCardList({
    super.key,
    required this.values,
    this.controller,
    this.padding,
    this.spacing,
    this.cardStyle = ValueCardStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardSpacing = spacing ?? _getCardSpacing(screenHeight);

    return Column(
      mainAxisSize: MainAxisSize.min, // 🎯 필요한 만큼만 높이 차지
      children: values.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < values.length - 1 ? cardSpacing : 0,
          ),
          child: AnimatedValueCard(
            value: value,
            index: index,
            controller: controller,
            style: cardStyle,
          ),
        );
      }).toList(),
    );
  }

  /// 📏 화면 크기별 카드 간격 계산
  double _getCardSpacing(double screenHeight) {
    if (screenHeight < 700) return 6.h;  // compact
    if (screenHeight < 850) return 8.h;  // medium
    return 10.h;                         // large
  }
}

/// 🏷️ 가치 아이템 데이터 모델
class ValueItem {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const ValueItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  // copyWith 메서드
  ValueItem copyWith({
    String? icon,
    String? title,
    String? subtitle,
    Color? color,
  }) {
    return ValueItem(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      color: color ?? this.color,
    );
  }
}

/// 🎨 카드 스타일 타입
enum ValueCardStyle {
  normal,    // 일반 스타일 (글래스모피즘)
  compact,   // 압축 스타일 (작은 패딩)
  minimal;   // 미니멀 스타일 (섀도우 적음)
}

/// 🎯 가치 카드 프리셋들 - 빠른 데이터 생성용
class ValueCardPresets {
  // 세종 캐치 솔루션 가치들
  static const List<ValueItem> solutionValues = [
    ValueItem(
      icon: "🎯",
      title: "정확한 정보",
      subtitle: "신뢰할 수 있는 출처",
      color: Color(0xFF3B82F6),
    ),
    ValueItem(
      icon: "⚡",
      title: "빠른 알림",
      subtitle: "마감일 놓치지 않게",
      color: Color(0xFFF59E0B),
    ),
    ValueItem(
      icon: "✨",
      title: "맞춤 추천",
      subtitle: "나에게 딱 맞는 정보",
      color: Color(0xFF10B981),
    ),
  ];

  // 문제점 관련 가치들
  static const List<ValueItem> problemValues = [
    ValueItem(
      icon: "😵",
      title: "정보 과부하",
      subtitle: "너무 많은 채널과 알림",
      color: Color(0xFFDC2626),
    ),
    ValueItem(
      icon: "⏰",
      title: "마감 놓침",
      subtitle: "중요한 기회를 실수로",
      color: Color(0xFFF59E0B),
    ),
    ValueItem(
      icon: "🔍",
      title: "신뢰도 불명",
      subtitle: "어떤 정보를 믿어야 할지",
      color: Color(0xFF6B7280),
    ),
  ];

  // 성공 사례 가치들
  static const List<ValueItem> successValues = [
    ValueItem(
      icon: "🏆",
      title: "성공적 지원",
      subtitle: "공모전 합격률 300% 증가",
      color: Color(0xFF059669),
    ),
    ValueItem(
      icon: "📚",
      title: "체계적 학습",
      subtitle: "관련 논문과 자료 큐레이션",
      color: Color(0xFF7C3AED),
    ),
    ValueItem(
      icon: "🤝",
      title: "네트워킹",
      subtitle: "같은 관심사 학생들과 연결",
      color: Color(0xFFDB2777),
    ),
  ];

  // 기능 소개 가치들
  static const List<ValueItem> featureValues = [
    ValueItem(
      icon: "🔔",
      title: "스마트 알림",
      subtitle: "개인 관심사 기반 푸시",
      color: Color(0xFF3B82F6),
    ),
    ValueItem(
      icon: "📊",
      title: "우선순위 표시",
      subtitle: "중요도별 정보 분류",
      color: Color(0xFFF59E0B),
    ),
    ValueItem(
      icon: "🎪",
      title: "축제 줄서기",
      subtitle: "실시간 대기열 참여",
      color: Color(0xFF8B5CF6),
    ),
  ];
}

/// 🔧 가치 카드 빌더 - 커스텀 리스트 생성용
class ValueCardListBuilder {
  final List<ValueItem> _values = [];
  AnimationController? _controller;
  ValueCardStyle _style = ValueCardStyle.normal;
  double? _spacing;
  EdgeInsets? _padding;

  ValueCardListBuilder add(ValueItem value) {
    _values.add(value);
    return this;
  }

  ValueCardListBuilder addAll(List<ValueItem> values) {
    _values.addAll(values);
    return this;
  }

  ValueCardListBuilder animation(AnimationController controller) {
    _controller = controller;
    return this;
  }

  ValueCardListBuilder style(ValueCardStyle style) {
    _style = style;
    return this;
  }

  ValueCardListBuilder spacing(double spacing) {
    _spacing = spacing;
    return this;
  }

  ValueCardListBuilder padding(EdgeInsets padding) {
    _padding = padding;
    return this;
  }

  ValueCardList build() {
    return ValueCardList(
      values: List.from(_values),
      controller: _controller,
      cardStyle: _style,
      spacing: _spacing,
      padding: _padding,
    );
  }

  // 편의 메서드들
  ValueCardListBuilder preset(List<ValueItem> preset) {
    _values.clear();
    _values.addAll(preset);
    return this;
  }

  ValueCardListBuilder solutionPreset() {
    return preset(ValueCardPresets.solutionValues);
  }

  ValueCardListBuilder problemPreset() {
    return preset(ValueCardPresets.problemValues);
  }

  ValueCardListBuilder successPreset() {
    return preset(ValueCardPresets.successValues);
  }

  ValueCardListBuilder featurePreset() {
    return preset(ValueCardPresets.featureValues);
  }
}