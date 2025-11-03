import 'package:flutter/material.dart';

/// ⌨️ 세종 캐치 Keyboard 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 키보드 관련 헬퍼 함수 모음
/// ✅ 키보드 상태 관리 및 제어
/// ✅ 반응형 UI 대응
class KeyboardUtils {
  KeyboardUtils._();

  /// 키보드 숨기기
  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  /// 키보드 표시 여부 확인
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// 키보드 높이 반환
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}
