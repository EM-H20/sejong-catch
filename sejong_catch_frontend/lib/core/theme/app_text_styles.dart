import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';

/// 세종 캐치 TextStyle 시스템
///
/// 명명 규칙: {용도}{Weight}{Size}
/// 예: titleSemiBold16 = 제목용 SemiBold 16sp
///
/// 사용 예시:
/// ```dart
/// Text('제목', style: AppTextStyles.titleSemiBold16)
/// Text('강조', style: AppTextStyles.titleSemiBold16.copyWith(color: AppColors.brandCrimson))
/// ```
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ============================================================================
  // Display Styles (대형 타이틀) - Bold
  // ============================================================================

  /// Display Bold 48sp - 메인 페이지 대형 타이틀
  static TextStyle get displayBold48 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 48.sp,
        color: AppColors.textPrimary,
      );

  /// Display Bold 36sp - 서브 대형 타이틀
  static TextStyle get displayBold36 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 36.sp,
        color: AppColors.textPrimary,
      );

  // ============================================================================
  // Heading Styles (제목) - Bold & SemiBold
  // ============================================================================

  /// Heading Bold 32sp - 페이지 제목
  static TextStyle get headingBold32 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 32.sp,
        color: AppColors.textPrimary,
      );

  /// Heading Bold 24sp - 섹션 제목
  static TextStyle get headingBold24 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 24.sp,
        color: AppColors.textPrimary,
      );

  /// Heading SemiBold 20sp - 카드 제목
  static TextStyle get headingSemiBold20 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 20.sp,
        color: AppColors.textPrimary,
      );

  /// Heading Bold 20sp - AppBar 타이틀
  static TextStyle get headingBold20 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 20.sp,
        color: AppColors.textPrimary,
      );

  // ============================================================================
  // Title Styles (카드/컴포넌트 제목) - SemiBold & Bold
  // ============================================================================

  /// Title SemiBold 16sp - 기본 카드 타이틀
  static TextStyle get titleSemiBold16 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      );

  /// Title Bold 16sp - 강조 카드 타이틀
  static TextStyle get titleBold16 => TextStyle(
        fontFamily: 'Pretendard-Bold',
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      );

  // ============================================================================
  // Body Styles (본문) - Regular & SemiBold & Medium
  // ============================================================================

  /// Body SemiBold 16sp - 강조 본문
  static TextStyle get bodySemiBold16 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      );

  /// Body Medium 14sp - 약간 강조 본문
  static TextStyle get bodyMedium14 => TextStyle(
        fontFamily: 'Pretendard-Medium',
        fontSize: 14.sp,
        color: AppColors.textSecondary,
      );

  /// Body Regular 14sp - 기본 본문
  static TextStyle get bodyRegular14 => TextStyle(
        fontFamily: 'Pretendard-Regular',
        fontSize: 14.sp,
        color: AppColors.textSecondary,
      );

  /// Body Regular 12sp - 작은 본문
  static TextStyle get bodyRegular12 => TextStyle(
        fontFamily: 'Pretendard-Regular',
        fontSize: 12.sp,
        color: AppColors.textSecondary,
      );

  // ============================================================================
  // Label Styles (라벨, 칩, 배지) - Medium & SemiBold
  // ============================================================================

  /// Label Medium 14sp - 기본 라벨, 칩
  static TextStyle get labelMedium14 => TextStyle(
        fontFamily: 'Pretendard-Medium',
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      );

  /// Label SemiBold 12sp - 작은 강조 라벨
  static TextStyle get labelSemiBold12 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 12.sp,
        color: AppColors.textSecondary,
      );

  // ============================================================================
  // Caption Styles (캡션, 힌트) - Regular
  // ============================================================================

  /// Caption Regular 10sp - 캡션, 힌트
  static TextStyle get captionRegular10 => TextStyle(
        fontFamily: 'Pretendard-Regular',
        fontSize: 10.sp,
        color: AppColors.textTertiary,
      );

  // ============================================================================
  // Button Styles (버튼) - SemiBold
  // ============================================================================

  /// Button SemiBold 16sp - 기본 버튼
  static TextStyle get buttonSemiBold16 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 16.sp,
        color: AppColors.pureWhite,
      );

  /// Button SemiBold 14sp - 작은 버튼
  static TextStyle get buttonSemiBold14 => TextStyle(
        fontFamily: 'Pretendard-SemiBold',
        fontSize: 14.sp,
        color: AppColors.pureWhite,
      );
}
