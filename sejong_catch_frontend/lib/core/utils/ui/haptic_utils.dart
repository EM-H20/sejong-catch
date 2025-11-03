import 'package:flutter/services.dart';

/// 📳 세종 캐치 Haptic 피드백 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 햅틱 피드백 강도별 제공
/// ✅ 사용자 경험 향상
/// ✅ 터치 반응성 개선
class HapticUtils {
  HapticUtils._();

  /// 가벼운 햅틱 피드백
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  /// 중간 햅틱 피드백
  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  /// 강한 햅틱 피드백
  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  /// 선택 햅틱 피드백
  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  /// 진동 패턴
  static void vibrate() {
    HapticFeedback.vibrate();
  }
}
