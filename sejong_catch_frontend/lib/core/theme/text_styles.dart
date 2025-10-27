import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// 세종 캐치 텍스트 스타일 정의
///
/// DRY 원칙: fontFamily는 _baseStyle에서 한 번만 정의하고
/// 모든 스타일은 copyWith로 상속받아 사용
class AppTextStyles {
  AppTextStyles._();

  // ✨ 기본 스타일 (Pretendard 폰트 한 번만 선언!)
  static const TextStyle _baseStyle = TextStyle(fontFamily: 'Pretendard');

  // Display Styles (Large headlines)
  static TextStyle display1 = _baseStyle.copyWith(
    fontSize: 52.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle display2 = _baseStyle.copyWith(
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Heading Styles
  static TextStyle heading1 = _baseStyle.copyWith(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading2 = _baseStyle.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle heading3 = _baseStyle.copyWith(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body Styles
  static TextStyle bodyLarge = _baseStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = _baseStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = _baseStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Caption & Label
  static TextStyle caption = _baseStyle.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static TextStyle label = _baseStyle.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Button Text
  static TextStyle button = _baseStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // Timer Specific
  static TextStyle timerDisplay = _baseStyle.copyWith(
    fontSize: 72.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle timerLabel = _baseStyle.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.2,
  );

  // Emoji Text (Pretendard 불필요, 이모지는 시스템 폰트 사용)
  static TextStyle emoji = TextStyle(fontSize: 80.sp, height: 1.0);

  static TextStyle emojiSmall = TextStyle(fontSize: 24.sp, height: 1.0);
}
