import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/onboarding_controller.dart';

/// 온보딩 슬라이드 위젯
class OnboardingSlide extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            // 상단 Flexible 여백
            const Flexible(flex: 1, child: SizedBox()),

            // 이미지 또는 아이콘 (고정 크기)
            _buildVisual(),

            SizedBox(height: 32.h), // 줄어든 간격

            // 제목
            Text(
              data.title,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h), // 줄어든 간격

            // 부제목
            Text(
              data.subtitle,
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // 하단 Flexible 여백 (버튼과 인디케이터를 위한 공간)
            const Flexible(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildVisual() {
    // 이미지가 있는 경우
    if (data.imagePath != null) {
      return Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xFFF7E3E8), // 크림슨 레드의 연한 버전
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Image.asset(data.imagePath!, fit: BoxFit.contain),
        ),
      );
    }

    // 아이콘이 있는 경우
    if (data.icon != null) {
      return Container(
        width: 200.w,
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xFFF7E3E8), // 크림슨 레드의 연한 버전
        ),
        child: Icon(
          data.icon,
          size: 80.sp,
          color: const Color(0xFFDC143C), // 크림슨 레드
        ),
      );
    }

    // 기본 placeholder
    return Container(
      width: 200.w,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFF7E3E8),
      ),
      child: Icon(
        Icons.info_outline,
        size: 80.sp,
        color: const Color(0xFFDC143C),
      ),
    );
  }
}
