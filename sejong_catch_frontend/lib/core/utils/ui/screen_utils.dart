import 'dart:math';
import 'package:flutter/material.dart';

/// 📱 세종 캐치 Screen 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 화면 정보 및 기기 타입 감지
/// ✅ 반응형 UI 대응
/// ✅ 안전 영역 처리
class ScreenUtils {
  ScreenUtils._();

  /// 안전 영역 여백 가져오기
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// 상태바 높이 가져오기
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// 바텀 네비게이션 높이 가져오기
  static double getBottomNavigationHeight(BuildContext context) {
    return kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom;
  }

  /// 화면 방향 확인
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// 화면 방향 확인
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// 태블릿 여부 확인 (화면 대각선 크기 기준)
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal > 1100; // 7인치 이상
  }
}
