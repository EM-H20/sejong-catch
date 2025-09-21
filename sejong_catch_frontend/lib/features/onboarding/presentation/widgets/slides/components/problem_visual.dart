import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🎨 Problem Slide 중앙 비주얼 컴포넌트
/// 문제 상황을 시각적으로 표현하는 60fps 보장 애니메이션
class ProblemVisual extends StatefulWidget {
  const ProblemVisual({super.key});

  @override
  State<ProblemVisual> createState() => _ProblemVisualState();
}

class _ProblemVisualState extends State<ProblemVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 스케일 애니메이션 (부드러운 등장)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // 페이드 애니메이션 (자연스러운 등장)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 200ms 딜레이 후 애니메이션 시작
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // 심플한 라디얼 그라데이션 (성능 최적화)
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 1.2,
                  colors: [
                    const Color(0xFFDC143C).withValues(alpha: 0.15),
                    const Color(0xFFDC143C).withValues(alpha: 0.05),
                  ],
                ),
                // 단순한 테두리 (GPU 가속)
                border: Border.all(
                  color: const Color(0xFFDC143C).withValues(alpha: 0.2),
                  width: 2,
                ),
                // 최적화된 섀도우 (단일 레이어)
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC143C).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "🤯",
                  style: TextStyle(fontSize: 50.sp),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}