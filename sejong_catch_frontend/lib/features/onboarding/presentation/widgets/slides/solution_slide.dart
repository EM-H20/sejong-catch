import 'package:flutter/material.dart';
import '../shared/adaptive_slide_layout.dart';
import '../shared/slide_header.dart';
import '../shared/solution_visual.dart';
import '../shared/value_card_list.dart';

/// 🎯 혁신적인 조립식 Solution 슬라이드 - 555줄 → 80줄 달성!
/// 6개의 스마트 컴포넌트로 분해된 완전히 새로운 아키텍처
class SolutionSlide extends StatefulWidget {
  const SolutionSlide({super.key});

  @override
  State<SolutionSlide> createState() => _SolutionSlideState();
}

class _SolutionSlideState extends State<SolutionSlide>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
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
    return AdaptiveSlideLayout(
      header: SlideHeader(
        brandTitle: "세종 캐치가",
        subtitle: "모든 걸 해결해드릴게요!",
        controller: _controller,
      ),
      visual: SolutionVisual(
        size: VisualSize.large,
        style: VisualStyle.success,
        controller: _controller,
      ),
      content: ValueCardList(
        values: ValueCardPresets.solutionValues,
        controller: _controller,
      ),
    );
  }
}