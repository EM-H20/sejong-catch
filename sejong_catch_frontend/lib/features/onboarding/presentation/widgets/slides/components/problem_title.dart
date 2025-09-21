import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🎯 Problem Slide 임팩트 타이틀 컴포넌트
/// 사용자 공감대 형성을 위한 그라데이션 텍스트
class ProblemTitle extends StatelessWidget {
  const ProblemTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "이런 일로" - 서브타이틀
        Text(
          "이런 일로",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF6B7280),
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),

        // "시간 낭비하셨나요?" - 메인 임팩트 (그라데이션)
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF1F2937),
              Color(0xFFDC143C),
              Color(0xFF1F2937),
            ],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            "시간 낭비하셨나요?",
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white, // ShaderMask가 적용됨
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}