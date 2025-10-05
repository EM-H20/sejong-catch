import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🔄 Before vs After 비교 컴포넌트
/// 좌우 분할로 문제 상황과 해결 상황을 시각적으로 비교하는 핵심 위젯
class BeforeAfterComparison extends StatelessWidget {
  final Widget beforeState;
  final Widget afterState;
  final String beforeTitle;
  final String afterTitle;
  final AnimationController? controller;
  final bool showTransitionArrow;
  final VoidCallback? onTransition;

  const BeforeAfterComparison({
    super.key,
    required this.beforeState,
    required this.afterState,
    this.beforeTitle = "BEFORE",
    this.afterTitle = "AFTER",
    this.controller,
    this.showTransitionArrow = true,
    this.onTransition,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 320.h;
        final containerHeight = isCompact ? 260.h : 320.h;

        return SizedBox(
          height: containerHeight,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 📱 Before 상태 (왼쪽 절반)
                    Expanded(
                      flex: 1,
                      child: _buildStateSection(
                        child: beforeState,
                        title: beforeTitle,
                        backgroundColor: const Color(0xFFFEF2F2), // 연한 빨강 배경
                        titleColor: const Color(0xFFDC2626),
                        isCompact: isCompact,
                        slideDirection: -1, // 왼쪽에서 들어옴
                      ),
                    ),

                    // 🔄 전환 화살표 (중앙)
                    if (showTransitionArrow)
                      _buildTransitionArrow(),

                    // ✅ After 상태 (오른쪽 절반)
                    Expanded(
                      flex: 1,
                      child: _buildStateSection(
                        child: afterState,
                        title: afterTitle,
                        backgroundColor: const Color(0xFFF0FDF4), // 연한 초록 배경
                        titleColor: const Color(0xFF059669),
                        isCompact: isCompact,
                        slideDirection: 1, // 오른쪽에서 들어옴
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 📱 개별 상태 섹션 빌더
  Widget _buildStateSection({
    required Widget child,
    required String title,
    required Color backgroundColor,
    required Color titleColor,
    required bool isCompact,
    required int slideDirection,
  }) {
    Widget sectionWidget = Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12.w : 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📌 상태 제목
            Text(
              title,
              style: TextStyle(
                fontSize: isCompact ? 10.sp : 12.sp,
                fontWeight: FontWeight.w800,
                color: titleColor,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: isCompact ? 8.h : 12.h),

            // 🎨 상태 비주얼 - Expanded 대신 Flexible 사용
            Flexible(
              flex: 1,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 애니메이션 적용
    if (controller != null) {
      sectionWidget = sectionWidget
          .animate(controller: controller!)
          .slideX(
            begin: slideDirection * 0.5,
            duration: 800.ms,
            curve: Curves.easeOutExpo,
          )
          .fadeIn(duration: 600.ms);
    }

    return sectionWidget;
  }

  /// 🔄 전환 화살표 위젯
  Widget _buildTransitionArrow() {
    Widget arrowWidget = Container(
      width: 3.w,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFDC2626).withValues(alpha: 0.7), // 빨강에서
            const Color(0xFF059669).withValues(alpha: 0.7), // 초록으로
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 상단 원
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(height: 4.h),

          // 화살표 아이콘
          GestureDetector(
            onTap: onTransition,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // 하단 원
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Color(0xFF059669),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );

    // 애니메이션 적용
    if (controller != null) {
      arrowWidget = arrowWidget
          .animate(controller: controller!)
          .scale(
            begin: const Offset(0.7, 0.7),
            duration: 600.ms,
            delay: 400.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(delay: 400.ms, duration: 400.ms);
    }

    return arrowWidget;
  }
}

/// 🎨 Before/After 컴포넌트 테마 프리셋
class BeforeAfterTheme {
  // 문제/해결 테마
  static const problemSolution = BeforeAfterStyle(
    beforeBg: Color(0xFFFEF2F2),     // 연한 빨강
    afterBg: Color(0xFFF0FDF4),      // 연한 초록
    beforeTitle: Color(0xFFDC2626),  // 빨강
    afterTitle: Color(0xFF059669),   // 초록
  );

  // 혼란/정리 테마
  static const chaosOrder = BeforeAfterStyle(
    beforeBg: Color(0xFFFEF3C7),     // 연한 노랑
    afterBg: Color(0xFFEFF6FF),      // 연한 파랑
    beforeTitle: Color(0xFFD97706),  // 주황
    afterTitle: Color(0xFF2563EB),   // 파랑
  );
}

/// 🎨 Before/After 스타일 데이터 클래스
class BeforeAfterStyle {
  final Color beforeBg;
  final Color afterBg;
  final Color beforeTitle;
  final Color afterTitle;

  const BeforeAfterStyle({
    required this.beforeBg,
    required this.afterBg,
    required this.beforeTitle,
    required this.afterTitle,
  });
}