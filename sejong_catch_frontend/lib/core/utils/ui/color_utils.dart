import 'package:flutter/material.dart';

/// 🎨 세종 캐치 Color 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 색상 변환 및 조작 도구
/// ✅ 접근성 고려 (대비 색상)
/// ✅ 16진수 변환 지원
class ColorUtils {
  ColorUtils._();

  /// 색상을 더 밝게 만들기
  static Color lightenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// 색상을 더 어둡게 만들기
  static Color darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// 텍스트에 적합한 대비 색상 반환 (흰색 또는 검은색)
  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// 16진수 문자열을 Color로 변환
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // 알파값 추가
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Color를 16진수 문자열로 변환
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}