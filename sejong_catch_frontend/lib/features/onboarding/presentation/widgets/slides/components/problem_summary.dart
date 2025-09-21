import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 💬 Problem Slide 해결책 요약 컴포넌트
/// 세종 캐치 솔루션을 제시하는 글래스모피즘 카드
class ProblemSummary extends StatelessWidget {
  const ProblemSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        // 글래스모피즘 그라데이션 (성능 최적화)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        // 심플한 테두리
        border: Border.all(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.8),
          width: 1.5,
        ),
        // 최적화된 섀도우 (단일 레이어)
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
          // 메인 문제 설명
          Text(
            "정보 찾느라 밤새고,\n공지 놓쳐서 후회하고...",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 10.h),

          // 세종 캐치 솔루션 제시
          Text(
            "이제 그만! 세종 캐치가 해결해드릴게요",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}