import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Sejong Catch 앱의 테마를 정의하는 클래스입니다.
///
/// Material 3 디자인 시스템을 기반으로 하며,
/// Crimson Red를 메인 컬러로 하는 일관된 브랜딩을 적용합니다.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// 세종 캐치 앱의 메인 테마를 반환합니다.
  ///
  /// Crimson Red를 seed color로 사용하여 Material 3의
  /// 일관된 색상 팔레트를 생성합니다.
  static ThemeData theme() {
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

      // 기본 배경 색상
      scaffoldBackgroundColor: AppColors.white,

      // AppBar 테마 - extendBodyBehindAppBar용 투명 설정
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent, // Material 3 tint 제거
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        // 상태바 스타일 설정
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // 버튼 테마들
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandCrimson,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.7),
          elevation: 2,
          shadowColor: AppColors.brandCrimson.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(44, 44), // 접근성을 위한 최소 터치 영역
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text 버튼 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandCrimson,
          disabledForegroundColor: AppColors.disabled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Chip 테마 - 선택 시 Crimson Light 배경
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.brandCrimsonLight,
        disabledColor: AppColors.disabled.withValues(alpha: 0.3),
        labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.brandCrimson,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: AppColors.textSecondary),
      ),

      // Bottom Navigation Bar 테마
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.brandCrimson,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Tab Bar 테마
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.brandCrimson,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.brandCrimson,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
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
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.white),
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
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }
}
