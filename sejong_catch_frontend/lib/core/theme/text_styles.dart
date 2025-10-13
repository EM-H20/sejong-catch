import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// 세종 캐치 텍스트 스타일 정의
class AppTextStyles {
  AppTextStyles._();

  // Display Styles (Large headlines)
  static TextStyle display1 = TextStyle(
    fontSize: 52.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    fontFamily: 'Pretendard',
  );

  static TextStyle display2 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
    fontFamily: 'Pretendard',
  );

  // Heading Styles
  static TextStyle heading1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
    fontFamily: 'Pretendard',
  );

  static TextStyle heading2 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
    fontFamily: 'Pretendard',
  );

  static TextStyle heading3 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
    fontFamily: 'Pretendard',
  );

  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
    fontFamily: 'Pretendard',
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
    fontFamily: 'Pretendard',
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
    fontFamily: 'Pretendard',
  );

  // Caption & Label
  static TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textTertiary,
    height: 1.4,
    fontFamily: 'Pretendard',
  );

  static TextStyle label = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
    fontFamily: 'Pretendard',
  );

  // Button Text
  static TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: 0.5,
    fontFamily: 'Pretendard',
  );

  // Timer Specific
  static TextStyle timerDisplay = TextStyle(
    fontSize: 72.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.0,
    fontFeatures: const [FontFeature.tabularFigures()],
    fontFamily: 'Pretendard',
  );

  static TextStyle timerLabel = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.2,
    fontFamily: 'Pretendard',
  );

  // Emoji Text
  static TextStyle emoji = TextStyle(fontSize: 80.sp, height: 1.0);

  static TextStyle emojiSmall = TextStyle(fontSize: 24.sp, height: 1.0);
}
