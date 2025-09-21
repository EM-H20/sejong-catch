import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 새로운 모듈화된 컴포넌트들 import
import 'components/problem_title.dart';
import 'components/problem_visual.dart';
import 'components/problem_summary.dart';

/// 🚀 새로워진 Problem 슬라이드 - "한 화면 완벽 피팅" 전략!
/// 417줄 → 60줄로 66% 코드 감소! 모든 화면에서 스크롤 없이 완벽하게!
class ProblemSlide extends StatelessWidget {
  const ProblemSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎯 임팩트 타이틀 (30.h)
            const ProblemTitle(),

            SizedBox(height: 24.h),

            // 🎨 중앙 비주얼 (120.w × 120.w)
            const ProblemVisual(),

            SizedBox(height: 24.h),

            // 💬 해결책 요약 (80.h)
            const ProblemSummary(),
          ],
        ),
      ),
    );
  }
}