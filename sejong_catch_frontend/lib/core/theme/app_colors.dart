import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color crimson = Color(0xFFDC143C);
  static const Color crimsonDark = Color(0xFFB0102F);
  static const Color crimsonLight = Color(0xFFF7E3E8);
  
  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Surface Colors
  static const Color surfaceLight = Color(0xFFF7F7F8);
  static const Color surfaceDark = Color(0xFF121212);
  
  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF111111);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  
  // Text Colors - Dark Theme  
  static const Color textPrimaryDark = Color(0xFFEDEDED);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  
  // Status Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);
  
  // Divider Colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF2A2A2A);
  
  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1F2937);
  
  // Button State Colors
  static const Color buttonDisabled = Color(0xFF9CA3AF);
  static const Color buttonDisabledDark = Color(0xFF4B5563);
  
  // Trust Badge Colors
  static const Color trustOfficial = crimson;
  static const Color trustAcademic = Color(0xFF6B7280);
  static const Color trustPress = Color(0xFF9CA3AF);
  static const Color trustCommunity = Color(0xFFD1D5DB);
  
  // Priority Colors
  static const Color priorityHigh = crimson;
  static const Color priorityMedium = crimsonLight;
  static const Color priorityLow = Color(0xFFE5E7EB);
  
  // Skeleton Loading
  static const Color skeletonBase = Color(0xFFE2E8F0);
  static const Color skeletonHighlight = Color(0xFFF1F5F9);
  
  // Background Gradients
  static const LinearGradient crimsonGradient = LinearGradient(
    colors: [crimson, crimsonDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
  
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}