import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';

/// Sejong Catch 앱의 모든 텍스트 스타일을 정의합니다.
///
/// ScreenUtil (.sp) 기반 반응형 폰트 크기를 사용하며,
/// AppColors와 함께 일관된 타이포그래피를 제공합니다.
///
/// 사용 예시:
/// ```dart
/// Text('제목', style: AppTextStyles.heading1)
/// Text('본문', style: AppTextStyles.bodyMedium)
/// Text('캡션', style: AppTextStyles.caption.copyWith(color: AppColors.brandCrimson))
/// ```
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ============================================================================
  // Display Styles (메인 타이틀)
  // ============================================================================

  /// Display 1 - 48.sp - 메인 페이지 대형 타이틀
  static TextStyle get display1 => TextStyle(
        fontSize: 48.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Display 2 - 36.sp - 서브 대형 타이틀
  static TextStyle get display2 => TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  // ============================================================================
  // Heading Styles (제목)
  // ============================================================================

  /// Heading 1 - 32.sp - 페이지 제목
  static TextStyle get heading1 => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// Heading 2 - 24.sp - 섹션 제목
  static TextStyle get heading2 => TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// Heading 3 - 20.sp - 카드 제목
  static TextStyle get heading3 => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  // ============================================================================
  // Body Styles (본문)
  // ============================================================================

  /// Body Large - 16.sp - 큰 본문 텍스트, 카드 타이틀
  static TextStyle get bodyLarge => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  /// Body Medium - 14.sp - 기본 본문 텍스트
  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  /// Body Small - 12.sp - 작은 본문 텍스트
  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ============================================================================
  // Label Styles (라벨, 칩)
  // ============================================================================

  /// Label Large - 14.sp - 큰 라벨, 버튼 텍스트
  static TextStyle get labelLarge => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// Label Medium - 12.sp - 기본 라벨, 칩
  static TextStyle get labelMedium => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.3,
      );

  /// Label Small - 10.sp - 작은 라벨, 배지
  static TextStyle get labelSmall => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.2,
      );

  // ============================================================================
  // Caption Style (캡션, 힌트)
  // ============================================================================

  /// Caption - 10.sp - 캡션, 힌트 텍스트
  static TextStyle get caption => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.3,
      );

  // ============================================================================
  // Button Styles (버튼)
  // ============================================================================

  /// Button - 16.sp - 버튼 텍스트
  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.pureWhite,
        height: 1.2,
      );

  /// Button Small - 14.sp - 작은 버튼 텍스트
  static TextStyle get buttonSmall => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.pureWhite,
        height: 1.2,
      );

  // ============================================================================
  // Special Styles (특수 용도)
  // ============================================================================

  /// AppBar Title - 20.sp - 앱바 타이틀
  static TextStyle get appBarTitle => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.brandCrimson,
        height: 1.2,
      );

  /// Tab Label - 14.sp - 탭 라벨
  static TextStyle get tabLabel => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        height: 1.2,
      );

  /// Card Title - 16.sp - 카드 제목 (Feed Card 등)
  static TextStyle get cardTitle => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// Card Description - 14.sp - 카드 설명
  static TextStyle get cardDescription => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );
}
