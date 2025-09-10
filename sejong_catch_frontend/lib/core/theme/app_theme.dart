import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Nucleus UI Design System + Material Design 3 통합 테마
/// 세종캐치 앱의 전체 UI/UX를 담당하는 메인 테마 시스템
class AppTheme {
  // ============================================================================
  // THEME CONFIGURATION
  // ============================================================================

  /// 라이트 테마 생성
  static ThemeData lightTheme() {
    const brightness = Brightness.light;

    return ThemeData(
      // Material 3 활성화
      useMaterial3: true,

      // 기본 설정
      brightness: brightness,
      fontFamily: AppTextStyles.fontFamily,

      // 색상 스키마 (Nucleus UI Purple 기반)
      colorScheme: _lightColorScheme(),

      // 텍스트 테마
      textTheme: _textTheme(brightness),

      // 컴포넌트 테마들
      appBarTheme: _appBarTheme(brightness),
      scaffoldBackgroundColor: AppColors.surface(_mockContext(brightness)),

      // 카드 테마
      cardTheme: _cardTheme(brightness),

      // 버튼 테마들
      elevatedButtonTheme: _elevatedButtonTheme(brightness),
      filledButtonTheme: _filledButtonTheme(brightness),
      outlinedButtonTheme: _outlinedButtonTheme(brightness),
      textButtonTheme: _textButtonTheme(brightness),

      // 입력 필드 테마
      inputDecorationTheme: _inputDecorationTheme(brightness),

      // 바텀 네비게이션
      bottomNavigationBarTheme: _bottomNavigationBarTheme(brightness),

      // 칩 테마
      chipTheme: _chipTheme(brightness),

      // 다이얼로그 테마
      dialogTheme: _dialogTheme(brightness),

      // 디바이더 테마
      dividerTheme: _dividerTheme(brightness),

      // 플로팅 액션 버튼
      floatingActionButtonTheme: _floatingActionButtonTheme(brightness),

      // 리스트 타일
      listTileTheme: _listTileTheme(brightness),

      // 스낵바
      snackBarTheme: _snackBarTheme(brightness),

      // 탭바
      tabBarTheme: _tabBarTheme(brightness),

      // 시스템 UI 설정은 별도 처리
    );
  }

  /// 다크 테마 생성
  static ThemeData darkTheme() {
    const brightness = Brightness.dark;

    return ThemeData(
      // Material 3 활성화
      useMaterial3: true,

      // 기본 설정
      brightness: brightness,
      fontFamily: AppTextStyles.fontFamily,

      // 색상 스키마 (Nucleus UI Purple 기반)
      colorScheme: _darkColorScheme(),

      // 텍스트 테마
      textTheme: _textTheme(brightness),

      // 컴포넌트 테마들
      appBarTheme: _appBarTheme(brightness),
      scaffoldBackgroundColor: AppColors.surface(_mockContext(brightness)),

      // 카드 테마
      cardTheme: _cardTheme(brightness),

      // 버튼 테마들
      elevatedButtonTheme: _elevatedButtonTheme(brightness),
      filledButtonTheme: _filledButtonTheme(brightness),
      outlinedButtonTheme: _outlinedButtonTheme(brightness),
      textButtonTheme: _textButtonTheme(brightness),

      // 입력 필드 테마
      inputDecorationTheme: _inputDecorationTheme(brightness),

      // 바텀 네비게이션
      bottomNavigationBarTheme: _bottomNavigationBarTheme(brightness),

      // 칩 테마
      chipTheme: _chipTheme(brightness),

      // 다이얼로그 테마
      dialogTheme: _dialogTheme(brightness),

      // 디바이더 테마
      dividerTheme: _dividerTheme(brightness),

      // 플로팅 액션 버튼
      floatingActionButtonTheme: _floatingActionButtonTheme(brightness),

      // 리스트 타일
      listTileTheme: _listTileTheme(brightness),

      // 스낵바
      snackBarTheme: _snackBarTheme(brightness),

      // 탭바
      tabBarTheme: _tabBarTheme(brightness),

      // 시스템 UI 설정은 별도 처리
    );
  }

  // ============================================================================
  // COLOR SCHEMES
  // ============================================================================

  /// 라이트 모드 색상 스키마 - 세종대 크림슨 레드 적용
  static ColorScheme _lightColorScheme() {
    return ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.crimsonRed, // 세종대 크림슨 레드 사용!

      // Primary Colors - 크림슨 레드 시스템
      primary: AppColors.crimsonRed,
      onPrimary: AppColors.skyWhite,
      primaryContainer: AppColors.crimsonRedLightest,
      onPrimaryContainer: AppColors.crimsonRedDark,

      // Secondary Colors (Success Green 활용)
      secondary: AppColors.success,
      onSecondary: AppColors.skyWhite,
      secondaryContainer: AppColors.successLightest,
      onSecondaryContainer: AppColors.successDarkest,

      // Tertiary Colors (Warning Yellow 활용)
      tertiary: AppColors.warning,
      onTertiary: AppColors.inkDarkest,
      tertiaryContainer: AppColors.warningLightest,
      onTertiaryContainer: AppColors.warningDarkest,

      // Error Colors
      error: AppColors.error,
      onError: AppColors.skyWhite,
      errorContainer: AppColors.errorLightest,
      onErrorContainer: AppColors.errorDarkest,

      // Surface Colors
      surface: AppColors.skyLightest,
      onSurface: AppColors.inkDarkest,
      surfaceContainerLowest: AppColors.skyWhite,
      surfaceContainerLow: AppColors.skyLightest,
      surfaceContainer: AppColors.skyLighter,
      surfaceContainerHigh: AppColors.skyLight,
      surfaceContainerHighest: AppColors.skyBase,
      onSurfaceVariant: AppColors.inkLight,

      // Outline
      outline: AppColors.skyBase,
      outlineVariant: AppColors.skyLight,

      // Other
      shadow: AppColors.inkDarkest,
      scrim: AppColors.inkDarkest,
      inverseSurface: AppColors.inkDarkest,
      onInverseSurface: AppColors.skyWhite,
      inversePrimary: AppColors.primaryLight,
    );
  }

  /// 다크 모드 색상 스키마 - Nucleus Purple 유지 (가독성)
  static ColorScheme _darkColorScheme() {
    return ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.primary, // Nucleus Purple 유지

      // Primary Colors - 보라색 시스템 (다크모드 가독성)
      primary: AppColors.primaryLight,
      onPrimary: AppColors.inkDarkest,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryLightest,

      // Secondary Colors
      secondary: AppColors.successLight,
      onSecondary: AppColors.inkDarkest,
      secondaryContainer: AppColors.successDarkest,
      onSecondaryContainer: AppColors.successLightest,

      // Tertiary Colors
      tertiary: AppColors.warningLight,
      onTertiary: AppColors.inkDarkest,
      tertiaryContainer: AppColors.warningDarkest,
      onTertiaryContainer: AppColors.warningLightest,

      // Error Colors
      error: AppColors.errorLight,
      onError: AppColors.inkDarkest,
      errorContainer: AppColors.errorDarkest,
      onErrorContainer: AppColors.errorLightest,

      // Surface Colors - 일관된 다크 배경색 적용
      surface: AppColors.inkDarkest,              // inkDarker → inkDarkest 통일!
      onSurface: AppColors.skyWhite,
      surfaceContainerLowest: AppColors.inkDarkest,
      surfaceContainerLow: AppColors.inkDarkest,  // inkDarker → inkDarkest 통일!
      surfaceContainer: AppColors.inkDark,
      surfaceContainerHigh: AppColors.inkBase,
      surfaceContainerHighest: AppColors.inkLight,
      onSurfaceVariant: AppColors.skyBase,

      // Outline
      outline: AppColors.inkLight,
      outlineVariant: AppColors.inkBase,

      // Other
      shadow: AppColors.inkDarkest,
      scrim: AppColors.inkDarkest,
      inverseSurface: AppColors.skyWhite,
      onInverseSurface: AppColors.inkDarkest,
      inversePrimary: AppColors.primary,
    );
  }

  // ============================================================================
  // TEXT THEME
  // ============================================================================

  /// 통합 텍스트 테마
  static TextTheme _textTheme(Brightness brightness) {
    final textColor = brightness == Brightness.light
        ? AppColors.inkDarkest
        : AppColors.skyWhite;

    final secondaryTextColor = brightness == Brightness.light
        ? AppColors.inkLight
        : AppColors.skyBase;

    return TextTheme(
      // Display Styles (가장 큰 텍스트)
      displayLarge: AppTextStyles.title1.copyWith(color: textColor),
      displayMedium: AppTextStyles.title2.copyWith(color: textColor),
      displaySmall: AppTextStyles.title3.copyWith(color: textColor),

      // Headline Styles
      headlineLarge: AppTextStyles.title2.copyWith(color: textColor),
      headlineMedium: AppTextStyles.title3.copyWith(color: textColor),
      headlineSmall: AppTextStyles.largeBold.copyWith(color: textColor),

      // Title Styles
      titleLarge: AppTextStyles.largeBold.copyWith(color: textColor),
      titleMedium: AppTextStyles.regularBold.copyWith(color: textColor),
      titleSmall: AppTextStyles.smallBold.copyWith(color: textColor),

      // Body Styles (본문)
      bodyLarge: AppTextStyles.largeRegular.copyWith(color: textColor),
      bodyMedium: AppTextStyles.regularRegular.copyWith(color: textColor),
      bodySmall: AppTextStyles.smallRegular.copyWith(color: secondaryTextColor),

      // Label Styles (버튼, 라벨)
      labelLarge: AppTextStyles.regularMedium.copyWith(color: textColor),
      labelMedium: AppTextStyles.smallMedium.copyWith(color: textColor),
      labelSmall: AppTextStyles.tinyMedium.copyWith(color: secondaryTextColor),
    );
  }

  // ============================================================================
  // COMPONENT THEMES
  // ============================================================================

  /// 앱바 테마
  static AppBarTheme _appBarTheme(Brightness brightness) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: brightness == Brightness.light
          ? AppColors.skyWhite
          : AppColors.inkDarker,
      foregroundColor: brightness == Brightness.light
          ? AppColors.inkDarkest
          : AppColors.skyWhite,
      titleTextStyle: AppTextStyles.title3.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
      ),
    );
  }

  /// 카드 테마
  static CardThemeData _cardTheme(Brightness brightness) {
    return CardThemeData(
      elevation: 2,
      color: brightness == Brightness.light
          ? AppColors.skyWhite
          : AppColors.inkBase,
      shadowColor: brightness == Brightness.light
          ? AppColors.inkDarkest.withValues(alpha: 0.1)
          : AppColors.inkDarkest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    );
  }

  /// Filled Button 테마 (주요 CTA)
  static FilledButtonThemeData _filledButtonTheme(Brightness brightness) {
    // 테마별 Primary 색상 사용
    final primaryColor = brightness == Brightness.light
        ? AppColors.crimsonRed
        : AppColors.primary;
        
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.skyWhite,
        disabledBackgroundColor: brightness == Brightness.light
            ? AppColors.skyDark
            : AppColors.inkLight,
        disabledForegroundColor: brightness == Brightness.light
            ? AppColors.inkLighter
            : AppColors.skyBase,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Elevated Button 테마
  static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brightness == Brightness.light
            ? AppColors.skyWhite
            : AppColors.inkBase,
        foregroundColor: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
        elevation: 2,
        shadowColor: AppColors.inkDarkest.withValues(alpha: 0.1),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Outlined Button 테마
  static OutlinedButtonThemeData _outlinedButtonTheme(Brightness brightness) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
        side: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.skyBase
              : AppColors.inkLight,
          width: 1.5,
        ),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Text Button 테마
  static TextButtonThemeData _textButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(48, 36),
      ),
    );
  }

  /// 입력 필드 테마
  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    return InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? AppColors.skyLighter
          : AppColors.inkDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.skyBase
              : AppColors.inkLight,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: brightness == Brightness.light
              ? AppColors.skyBase
              : AppColors.inkLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: AppTextStyles.hint.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkLighter
            : AppColors.skyDark,
      ),
      labelStyle: AppTextStyles.label.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkLight
            : AppColors.skyBase,
      ),
    );
  }

  /// 바텀 네비게이션 테마
  static BottomNavigationBarThemeData _bottomNavigationBarTheme(
    Brightness brightness,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.skyWhite
          : AppColors.inkDarker,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: brightness == Brightness.light
          ? AppColors.inkLight
          : AppColors.skyBase,
      selectedLabelStyle: AppTextStyles.tinyMedium,
      unselectedLabelStyle: AppTextStyles.tinyRegular,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  /// 칩 테마
  static ChipThemeData _chipTheme(Brightness brightness) {
    return ChipThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.skyLight
          : AppColors.inkBase,
      selectedColor: AppColors.primaryLightest,
      deleteIconColor: brightness == Brightness.light
          ? AppColors.inkLight
          : AppColors.skyBase,
      labelStyle: AppTextStyles.smallMedium,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  /// 다이얼로그 테마
  static DialogThemeData _dialogTheme(Brightness brightness) {
    return DialogThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.skyWhite
          : AppColors.inkBase,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: AppTextStyles.title3.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
      ),
      contentTextStyle: AppTextStyles.bodyText.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkLight
            : AppColors.skyBase,
      ),
    );
  }

  /// 디바이더 테마
  static DividerThemeData _dividerTheme(Brightness brightness) {
    return DividerThemeData(
      color: brightness == Brightness.light
          ? AppColors.skyLight
          : AppColors.inkBase,
      thickness: 1,
      space: 1,
    );
  }

  /// 플로팅 액션 버튼 테마
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
    Brightness brightness,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.skyWhite,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  /// 리스트 타일 테마
  static ListTileThemeData _listTileTheme(Brightness brightness) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      titleTextStyle: AppTextStyles.regularMedium.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkDarkest
            : AppColors.skyWhite,
      ),
      subtitleTextStyle: AppTextStyles.smallRegular.copyWith(
        color: brightness == Brightness.light
            ? AppColors.inkLight
            : AppColors.skyBase,
      ),
      iconColor: brightness == Brightness.light
          ? AppColors.inkLight
          : AppColors.skyBase,
    );
  }

  /// 스낵바 테마
  static SnackBarThemeData _snackBarTheme(Brightness brightness) {
    return SnackBarThemeData(
      backgroundColor: brightness == Brightness.light
          ? AppColors.inkDarkest
          : AppColors.skyWhite,
      contentTextStyle: AppTextStyles.regularRegular.copyWith(
        color: brightness == Brightness.light
            ? AppColors.skyWhite
            : AppColors.inkDarkest,
      ),
      actionTextColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  /// 탭바 테마
  static TabBarThemeData _tabBarTheme(Brightness brightness) {
    return TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: brightness == Brightness.light
          ? AppColors.inkLight
          : AppColors.skyBase,
      labelStyle: AppTextStyles.regularMedium,
      unselectedLabelStyle: AppTextStyles.regularRegular,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }


  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// 임시 BuildContext 생성 (테마 생성 시 색상 함수 호출용)
  static BuildContext _mockContext(Brightness brightness) {
    // 실제 앱에서는 Provider.of<BuildContext> 사용
    // 여기서는 테마 생성 시에만 사용하는 임시 해결책
    return _MockBuildContext(brightness);
  }

  /// 현재 테마가 다크 모드인지 확인
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 동적 색상 가져오기 (Material You 지원 준비)
  static Future<ColorScheme?> getDynamicColorScheme(
    Brightness brightness,
  ) async {
    // dynamic_color 패키지를 사용한 시스템 색상 추출 로직
    // 현재는 null 반환 (추후 구현)
    return null;
  }
}

/// 임시 BuildContext 구현 (테마 생성용)
class _MockBuildContext extends BuildContext {
  final Brightness brightness;

  _MockBuildContext(this.brightness);

  @override
  // Theme.of() 호출 시 사용될 더미 테마 데이터
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) {
    if (T == Theme) {
      return ThemeData(brightness: brightness) as T;
    }
    return null;
  }

  // 나머지 BuildContext 메소드들은 구현하지 않음 (테마 생성 시 불필요)
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
