import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🎨 세종 캐치 앱의 페이지 트랜지션 정의
///
/// CLAUDE.md 원칙:
/// ✅ 부드러운 화면 전환 (Fade + Slide)
/// ✅ Material Design 권장 300ms
/// ✅ 일관된 사용자 경험

/// Fade + Slide Up 트랜지션
///
/// **애니메이션**:
/// - Fade In/Out: 투명도 0 → 1
/// - Slide Up: 화면 하단 3%에서 위로 슬라이드
/// - Duration: 300ms
/// - Curve: easeOutCubic (부드러운 감속)
CustomTransitionPage<T> buildFadeSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade 애니메이션 (투명도)
      const fadeBegin = 0.0;
      const fadeEnd = 1.0;
      final fadeTween = Tween(begin: fadeBegin, end: fadeEnd);
      final fadeAnimation = animation.drive(fadeTween);

      // Slide 애니메이션 (위치)
      const slideBegin = Offset(0.0, 0.03); // 화면 높이의 3% 아래에서 시작
      const slideEnd = Offset.zero;
      final slideTween = Tween(
        begin: slideBegin,
        end: slideEnd,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      final slideAnimation = animation.drive(slideTween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: slideAnimation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
  );
}

/// Fade Only 트랜지션 (가벼운 화면 전환용)
///
/// **사용 예시**:
/// - 탭 전환
/// - 모달 오버레이
/// - 설정 화면 등
CustomTransitionPage<T> buildFadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 150),
  );
}

/// 애니메이션 없음 (즉시 전환)
///
/// **사용 예시**:
/// - 로그인 → 홈 화면 (상태 변경)
/// - 에러 페이지
CustomTransitionPage<T> buildNoTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: Duration.zero,
  );
}
