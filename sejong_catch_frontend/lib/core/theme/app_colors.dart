import 'package:flutter/material.dart';

/// Nucleus UI Design System 색상 정의
/// Figma MCP를 통해 추출된 공식 디자인 토큰들
class AppColors {
  // ============================================================================
  // PRIMARY COLORS - Nucleus UI Purple System
  // ============================================================================
  
  /// Primary brand color - Purple from Nucleus UI
  static const Color primary = Color(0xFF6B4EFF);        // Primary/Base
  static const Color primaryDark = Color(0xFF5538EE);     // Primary/Dark
  static const Color primaryLight = Color(0xFF9990FF);    // Primary/Light
  static const Color primaryLighter = Color(0xFFC6C4FF);  // Primary/Lighter
  static const Color primaryLightest = Color(0xFFE7E7FF); // Primary/Lightest

  // ============================================================================
  // SEJONG CRIMSON RED SYSTEM - 세종대학교 대표 색상
  // ============================================================================
  
  /// 세종대학교 크림슨 레드 - 공식 브랜드 컬러
  static const Color crimsonRed = Color(0xFFDC143C);      // Crimson/Base
  static const Color crimsonRedDark = Color(0xFFB0102F);  // Crimson/Dark  
  static const Color crimsonRedLight = Color(0xFFE85D75); // Crimson/Light
  static const Color crimsonRedLighter = Color(0xFFF4A6B7); // Crimson/Lighter
  static const Color crimsonRedLightest = Color(0xFFFDE8EC); // Crimson/Lightest

  // ============================================================================
  // STATUS COLORS - Nucleus UI Semantic Colors
  // ============================================================================

  // Success Colors (Green System)
  static const Color success = Color(0xFF23C16B);         // Green/Base
  static const Color successLight = Color(0xFF4CD471);    // Green/Light
  static const Color successLighter = Color(0xFF7DDE86); // Green/Lighter
  static const Color successLightest = Color(0xFFECFCE5); // Green/Lightest
  static const Color successDarkest = Color(0xFF198155); // Green/Darkest

  // Warning Colors (Yellow System)
  static const Color warning = Color(0xFFFFB323);         // Yellow/Base
  static const Color warningLight = Color(0xFFFFC462);    // Yellow/Light
  static const Color warningLighter = Color(0xFFFFD188); // Yellow/Lighter
  static const Color warningLightest = Color(0xFFFFEFD7); // Yellow/Lightest
  static const Color warningDarkest = Color(0xFFA05E03); // Yellow/Darkest

  // Error Colors (Red System)
  static const Color error = Color(0xFFFF5247);           // Red/Base
  static const Color errorLight = Color(0xFFFF6D6D);      // Red/Light
  static const Color errorLighter = Color(0xFFFF9898);   // Red/Lighter
  static const Color errorLightest = Color(0xFFFFE5E5);  // Red/Lightest
  static const Color errorDarkest = Color(0xFFD3180C);   // Red/Darkest

  // Info Colors (Blue System)
  static const Color info = Color(0xFF48A7F8);            // Blue/Base
  static const Color infoLight = Color(0xFF6EC2FB);       // Blue/Light
  static const Color infoLighter = Color(0xFF9BDCFD);    // Blue/Lighter
  static const Color infoLightest = Color(0xFFC9F0FF);   // Blue/Lightest
  static const Color infoDarkest = Color(0xFF0065D0);    // Blue/Darkest

  // ============================================================================
  // NEUTRAL COLORS - Nucleus UI Ink & Sky System
  // ============================================================================

  // Ink Colors (텍스트 및 진한 요소용)
  static const Color inkDarkest = Color(0xFF090A0A);      // Ink/Darkest
  static const Color inkDarker = Color(0xFF202325);       // Ink/Darker
  static const Color inkDark = Color(0xFF303437);         // Ink/Dark
  static const Color inkBase = Color(0xFF404446);         // Ink/Base
  static const Color inkLight = Color(0xFF6C7072);        // Ink/Light
  static const Color inkLighter = Color(0xFF72777A);      // Ink/Lighter

  // Sky Colors (배경 및 연한 요소용)
  static const Color skyWhite = Color(0xFFFFFFFF);        // Sky/White
  static const Color skyLightest = Color(0xFFF7F9FA);     // Sky/Lightest
  static const Color skyLighter = Color(0xFFF2F4F5);      // Sky/Lighter
  static const Color skyLight = Color(0xFFE3E5E5);        // Sky/Light
  static const Color skyBase = Color(0xFFCDCFD0);         // Sky/Base
  static const Color skyDark = Color(0xFF979C9E);         // Sky/Dark

  // ============================================================================
  // 3RD PARTY COLORS - 소셜 로그인 등
  // ============================================================================

  static const Color facebookBase = Color(0xFF0078FF);    // Facebook/Base
  static const Color facebookDark = Color(0xFF0067DB);    // Facebook/Dark
  static const Color twitterBase = Color(0xFF1DA1F2);     // Twitter/Base
  static const Color twitterDark = Color(0xFF0C90E1);     // Twitter/Dark

  // ============================================================================
  // THEME-AWARE SURFACE COLORS
  // ============================================================================

  /// 메인 배경 색상
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLightest    // F7F9FA - 부드러운 라이트 배경
        : inkDarkest;    // 090A0A - 진짜 다크 배경 (더 어둡게!)
  }

  /// 카드나 컨테이너 배경
  static Color surfaceContainer(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyWhite       // FFFFFF - 순백 카드
        : inkBase;       // 404446 - 다크 카드
  }

  /// 구분된 섹션 배경
  static Color surfaceVariant(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLighter     // F2F4F5 - 연한 섹션
        : inkDark;       // 303437 - 다크 섹션
  }

  /// 강조된 컨테이너
  static Color surfaceContainerHighest(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLight       // E3E5E5 - 강조 영역
        : inkLight;      // 6C7072 - 다크 강조
  }

  // ============================================================================
  // THEME-AWARE TEXT COLORS
  // ============================================================================

  /// 기본 텍스트 (제목, 중요 내용)
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? inkDarkest     // 090A0A - 최고 대비
        : skyWhite;      // FFFFFF - 다크모드 순백
  }

  /// 보조 텍스트 (설명, 부가 정보)
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? inkLight       // 6C7072 - 읽기 편한 회색
        : skyBase;       // CDCFD0 - 다크모드 보조
  }

  /// 부차적 텍스트 (라벨, 힌트)
  static Color textTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? inkLighter     // 72777A - 연한 힌트
        : skyDark;       // 979C9E - 다크모드 힌트
  }

  // ============================================================================
  // THEME-AWARE BORDER & DIVIDER COLORS
  // ============================================================================

  /// 구분선 (섹션, 리스트 아이템 등)
  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLight       // E3E5E5 - 자연스러운 구분
        : inkBase;       // 404446 - 다크 구분선
  }

  /// 테두리 (입력필드, 카드 등)
  static Color border(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyBase        // CDCFD0 - 명확한 테두리
        : inkLight;      // 6C7072 - 다크 테두리
  }

  /// 아웃라인 (버튼, 강조 요소)
  static Color outline(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyBase        // CDCFD0 - 버튼 테두리
        : inkLight;      // 6C7072 - 다크 아웃라인
  }

  // ============================================================================
  // SEMANTIC STATUS COLORS (Context-Aware)
  // ============================================================================

  /// 성공 상태 (완료, 승인 등)
  static Color successContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? success        // 23C16B - 선명한 성공
        : successLight;  // 4CD471 - 다크모드에서 밝게
  }

  /// 경고 상태 (주의, 확인 필요)
  static Color warningContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? warning        // FFB323 - 주의 색상
        : warningLight;  // FFC462 - 다크모드 경고
  }

  /// 에러 상태 (실패, 오류)
  static Color errorContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? error          // FF5247 - 명확한 에러
        : errorLight;    // FF6D6D - 다크모드 에러
  }

  /// 정보 상태 (알림, 도움말)
  static Color infoContext(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? info           // 48A7F8 - 정보 파랑
        : infoLight;     // 6EC2FB - 다크모드 정보
  }

  // ============================================================================
  // TRUST BADGE COLORS - 세종캐치 신뢰도 시스템
  // ============================================================================

  /// 공식 출처 (대학, 정부 기관)
  static Color trustOfficial(BuildContext context) => primary;

  /// 학술 출처 (논문, 학술지)
  static Color trustAcademic(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? inkLight       // 6C7072 - 신뢰할만한 회색
        : skyBase;       // CDCFD0 - 다크모드 학술
  }

  /// 언론 출처 (뉴스, 보도자료)
  static Color trustPress(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? inkLighter     // 72777A - 언론 회색
        : skyLight;      // E3E5E5 - 다크모드 언론
  }

  /// 커뮤니티 출처 (게시판, 사용자)
  static Color trustCommunity(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyBase        // CDCFD0 - 연한 커뮤니티
        : skyLighter;    // F2F4F5 - 다크모드 커뮤니티
  }

  // ============================================================================
  // THEME-AWARE PRIMARY COLORS - 테마별 Primary 색상
  // ============================================================================

  /// 테마에 따른 Primary 색상
  /// 라이트 테마: 세종대 크림슨 레드 / 다크 테마: Nucleus Purple
  static Color themePrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? crimsonRed     // 라이트 모드: 세종대 정체성
        : primary;       // 다크 모드: 보라색 (가독성)
  }

  /// 테마에 따른 Primary Dark 색상
  static Color themePrimaryDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? crimsonRedDark // 라이트 모드: 어두운 크림슨
        : primaryDark;   // 다크 모드: 어두운 보라
  }

  /// 테마에 따른 Primary Light 색상
  static Color themePrimaryLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? crimsonRedLight // 라이트 모드: 밝은 크림슨
        : primaryLight;   // 다크 모드: 밝은 보라
  }

  // ============================================================================
  // PRIORITY COLORS - 세종캐치 우선순위 시스템
  // ============================================================================

  /// 높은 우선순위 (마감임박, 중요)
  static Color priorityHigh(BuildContext context) => themePrimary(context);

  /// 중간 우선순위 (일반적)
  static Color priorityMedium(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryLight   // 9990FF - 연한 보라
        : primaryLighter; // C6C4FF - 다크모드 중간
  }

  /// 낮은 우선순위 (참고용)
  static Color priorityLow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLight       // E3E5E5 - 연한 배경
        : inkBase;       // 404446 - 다크모드 낮음
  }

  // ============================================================================
  // BUTTON STATE COLORS
  // ============================================================================

  /// 비활성화된 버튼
  static Color buttonDisabled(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyDark        // 979C9E - 회색 비활성
        : inkLight;      // 6C7072 - 다크 비활성
  }

  /// 호버/눌림 상태 버튼
  static Color buttonPressed(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryDark    // 5538EE - 짙은 보라
        : lighten(primary, 0.1); // 밝은 보라
  }

  // ============================================================================
  // SKELETON LOADING COLORS
  // ============================================================================

  /// 스켈레톤 베이스 색상
  static Color skeletonBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLighter     // F2F4F5 - 연한 스켈레톤
        : inkDark;       // 303437 - 다크 스켈레톤
  }

  /// 스켈레톤 하이라이트
  static Color skeletonHighlight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? skyLightest    // F7F9FA - 밝은 하이라이트
        : inkBase;       // 404446 - 다크 하이라이트
  }

  // ============================================================================
  // GRADIENTS & VISUAL EFFECTS
  // ============================================================================

  /// 메인 브랜드 그라데이션
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 성공 그라데이션
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 스켈레톤 시머 효과
  static LinearGradient shimmerGradient(BuildContext context) {
    final baseColor = skeletonBase(context);
    final highlightColor = skeletonHighlight(context);
    
    return LinearGradient(
      begin: const Alignment(-1.0, -0.3),
      end: const Alignment(1.0, 0.3),
      colors: [baseColor, highlightColor, baseColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// 색상 투명도 조절
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// 색상 어둡게 하기
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// 색상 밝게 하기
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// 접근성 대비 비율 계산
  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// 접근성 기준(4.5:1) 충족 여부 확인
  static bool hasGoodContrast(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// 색상이 어두운지 확인 (텍스트 색상 결정용)
  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  /// 색상에 따른 적절한 텍스트 색상 반환
  static Color getTextColorForBackground(Color backgroundColor) {
    return isDark(backgroundColor) ? skyWhite : inkDarkest;
  }

  // ============================================================================
  // LEGACY SUPPORT (하위 호환성)
  // ============================================================================

  // 기존 코드와의 호환성을 위한 별칭들
  static const Color white = skyWhite;
  static const Color black = inkDarkest;
  static const Color transparent = Colors.transparent;
  
  // 기존 crimson 색상을 primary로 매핑
  static const Color crimson = primary;
  static const Color crimsonDark = primaryDark;
  static const Color crimsonLight = primaryLight;
}