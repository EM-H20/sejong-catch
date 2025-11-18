import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';

/// Sejong Catch 앱의 테마를 정의하는 클래스입니다.
///
/// Material 3 디자인 시스템을 기반으로 하며,
/// Crimson Red를 메인 컬러로 하는 일관된 브랜딩을 적용합니다.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// 세종 캐치 앱의 라이트 테마를 반환합니다.
  ///
  /// Crimson Red를 seed color로 사용하여 Material 3의
  /// 일관된 색상 팔레트를 생성합니다.
  static ThemeData get lightTheme => _buildTheme();

  static ThemeData _buildTheme() {
    // Crimson Red 기반 ColorScheme 생성
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandCrimson,
      primary: AppColors.brandCrimson,
      secondary: AppColors.brandCrimson,
      surface: AppColors.surface,
      // background: AppColors.white, // deprecated, using surface instead
      brightness: Brightness.light,
    );

    return ThemeData(
      // Material 3 활성화
      useMaterial3: true,

      // ColorScheme 적용
      colorScheme: colorScheme,

      // 🎨 Pretendard 폰트를 전체 앱의 기본 폰트로 설정
      fontFamily: 'Pretendard',

      // 📝 전체 텍스트 테마 (Pretendard 폰트 적용)
      textTheme: _buildTextTheme(),

      // 기본 배경 색상
      scaffoldBackgroundColor: AppColors.white,

      // AppBar 테마 - extendBodyBehindAppBar용 투명 설정
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.transparent, // Material 3 tint 제거
        titleTextStyle: AppTextStyles.headingSemiBold20,
        // 상태바 스타일 설정
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.dark, // 아이콘 어둡게
          statusBarBrightness: Brightness.light, // iOS용 라이트 바
        ),
      ),

      // Card 테마 - 8dp 라운드 코너 적용
      cardTheme: CardThemeData(
        color: AppColors.white,
        shadowColor: AppColors.shadow.withValues(alpha: 0.08),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
      ),

      // 버튼 테마들
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandCrimson,
          foregroundColor: AppColors.pureWhite,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.pureWhite.withValues(alpha: 0.7),
          elevation: 2,
          shadowColor: AppColors.brandCrimson.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(44, 44), // 접근성을 위한 최소 터치 영역
          padding: AppSpacing.buttonPadding,
          textStyle: AppTextStyles.buttonSemiBold16,
        ),
      ),

      // Outlined 버튼 테마
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandCrimson,
          side: const BorderSide(color: AppColors.brandCrimson, width: 1.5),
          disabledForegroundColor: AppColors.disabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(44, 44),
          padding: AppSpacing.buttonPadding,
        ),
      ),

      // Text 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandCrimson,
          disabledForegroundColor: AppColors.disabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(44, 44),
          padding: AppSpacing.buttonPaddingSmall,
        ),
      ),

      // Chip 테마 - 선택 시 Crimson Light 배경
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.brandCrimsonLight,
        disabledColor: AppColors.disabled.withValues(alpha: 0.3),
        labelStyle: AppTextStyles.bodyRegular14,
        secondaryLabelStyle: AppTextStyles.labelMedium14.copyWith(
          color: AppColors.brandCrimson,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      // Input 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.brandCrimson, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: AppSpacing.cardPadding,
        hintStyle: AppTextStyles.bodyRegular14.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Bottom Navigation Bar 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.brandCrimson,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTextStyles.captionRegular10.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTextStyles.captionRegular10,
      ),

      // Tab Bar 테마
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.brandCrimson,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.brandCrimson,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTextStyles.bodySemiBold16.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodySemiBold16,
      ),

      // Divider 테마
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Progress Indicator 테마
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brandCrimson,
        linearTrackColor: AppColors.brandCrimsonLight,
        circularTrackColor: AppColors.brandCrimsonLight,
      ),

      // Switch 테마
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brandCrimson;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brandCrimsonLight;
          }
          return AppColors.divider;
        }),
      ),

      // Checkbox 테마
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brandCrimson;
          }
          return AppColors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.pureWhite),
        side: const BorderSide(color: AppColors.divider, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio 테마
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.brandCrimson;
          }
          return AppColors.textSecondary;
        }),
      ),

      // Floating Action Button 테마
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brandCrimson,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  /// 🎨 Material 3 TextTheme 생성
  ///
  /// Material 3의 TextTheme을 기반으로 반응형 폰트 크기 적용
  /// fontFamily는 ThemeData의 전역 설정(Line 41)을 자동 상속합니다.
  ///
  /// CLAUDE.md 원칙: 모든 크기 값은 ScreenUtil(.sp) 필수 적용!
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // 📖 Display 스타일 (큰 제목)
      displayLarge: TextStyle(
        fontSize: 57.sp,
        fontWeight: FontWeight.w700, // Bold
        color: AppColors.textPrimary,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45.sp,
        fontWeight: FontWeight.w700, // Bold
        color: AppColors.textPrimary,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36.sp,
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.textPrimary,
        height: 1.22,
      ),

      // 📰 Headline 스타일 (헤드라인)
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.textPrimary,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600, // SemiBold
        color: AppColors.textPrimary,
        height: 1.33,
      ),

      // 📝 Title 스타일 (제목)
      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textPrimary,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textPrimary,
        height: 1.43,
      ),

      // 📄 Body 스타일 (본문)
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400, // Regular
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400, // Regular
        color: AppColors.textPrimary,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400, // Regular
        color: AppColors.textSecondary,
        height: 1.33,
      ),

      // 🏷️ Label 스타일 (라벨, 버튼)
      labelLarge: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textPrimary,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textPrimary,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500, // Medium
        color: AppColors.textSecondary,
        height: 1.45,
      ),
    );
  }
}
