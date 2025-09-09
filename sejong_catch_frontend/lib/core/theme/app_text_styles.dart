import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Nucleus UI Design System 타이포그래피 정의
/// Figma MCP를 통해 추출된 공식 Typography 토큰들
/// Inter 폰트 기반의 체계적인 텍스트 스타일 시스템
class AppTextStyles {
  // ============================================================================
  // FONT FAMILY
  // ============================================================================
  
  /// 기본 폰트 패밀리 - Inter (Nucleus UI 공식)
  static const String fontFamily = 'Inter';
  
  // ============================================================================
  // TITLE STYLES - 큰 제목들 (48px ~ 24px)
  // ============================================================================
  
  /// Title 1 - 메인 화면 제목, 온보딩 제목 등
  /// Font: Inter Bold 48px/56px (weight: 700)
  static TextStyle title1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48.sp,
    height: 56.sp / 48.sp, // lineHeight / fontSize
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02.sp, // 큰 제목은 자간을 좁게
  );

  /// Title 2 - 섹션 제목, 페이지 제목
  /// Font: Inter Bold 32px/36px (weight: 700)
  static TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.sp,
    height: 36.sp / 32.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01.sp,
  );

  /// Title 3 - 카드 제목, 컴포넌트 제목
  /// Font: Inter Bold 24px/32px (weight: 700)
  static TextStyle title3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.sp,
    height: 32.sp / 24.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // ============================================================================
  // LARGE STYLES - 큰 본문 텍스트 (18px)
  // ============================================================================
  
  /// Large Bold - 중요한 큰 텍스트
  /// Font: Inter Bold 18px/24px (weight: 700)
  static TextStyle largeBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 24.sp / 18.sp,
    fontWeight: FontWeight.w700,
  );

  /// Large Bold Tight - 줄간격이 좁은 큰 볼드
  /// Font: Inter Bold 18px/20px (weight: 700)
  static TextStyle largeBoldTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 20.sp / 18.sp,
    fontWeight: FontWeight.w700,
  );

  /// Large Bold None - 줄간격 없는 큰 볼드 (단일 라인용)
  /// Font: Inter Bold 18px/18px (weight: 700)
  static TextStyle largeBoldNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 1.0, // 18px / 18px = 1.0
    fontWeight: FontWeight.w700,
  );

  /// Large Medium - 세미볼드 큰 텍스트
  /// Font: Inter Medium 18px/24px (weight: 500)
  static TextStyle largeMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 24.sp / 18.sp,
    fontWeight: FontWeight.w500,
  );

  /// Large Medium Tight - 줄간격이 좁은 세미볼드
  /// Font: Inter Medium 18px/20px (weight: 500)
  static TextStyle largeMediumTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 20.sp / 18.sp,
    fontWeight: FontWeight.w500,
  );

  /// Large Medium None - 줄간격 없는 세미볼드
  /// Font: Inter Medium 18px/18px (weight: 500)
  static TextStyle largeMediumNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 1.0,
    fontWeight: FontWeight.w500,
  );

  /// Large Regular - 일반 큰 텍스트
  /// Font: Inter Regular 18px/24px (weight: 400)
  static TextStyle largeRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 24.sp / 18.sp,
    fontWeight: FontWeight.w400,
  );

  /// Large Regular Tight - 줄간격이 좁은 일반
  /// Font: Inter Regular 18px/20px (weight: 400)
  static TextStyle largeRegularTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 20.sp / 18.sp,
    fontWeight: FontWeight.w400,
  );

  /// Large Regular None - 줄간격 없는 일반
  /// Font: Inter Regular 18px/18px (weight: 400)
  static TextStyle largeRegularNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 1.0,
    fontWeight: FontWeight.w400,
  );

  // ============================================================================
  // REGULAR STYLES - 기본 본문 텍스트 (16px)
  // ============================================================================
  
  /// Regular Bold - 강조 본문 텍스트
  /// Font: Inter Bold 16px/24px (weight: 700)
  static TextStyle regularBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 24.sp / 16.sp,
    fontWeight: FontWeight.w700,
  );

  /// Regular Bold Tight - 줄간격이 좁은 강조
  /// Font: Inter Bold 16px/20px (weight: 700)
  static TextStyle regularBoldTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 20.sp / 16.sp,
    fontWeight: FontWeight.w700,
  );

  /// Regular Bold None - 줄간격 없는 강조 (버튼 등)
  /// Font: Inter Bold 16px/16px (weight: 700)
  static TextStyle regularBoldNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 1.0,
    fontWeight: FontWeight.w700,
  );

  /// Regular Medium - 세미볼드 본문
  /// Font: Inter Medium 16px/24px (weight: 500)
  static TextStyle regularMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 24.sp / 16.sp,
    fontWeight: FontWeight.w500,
  );

  /// Regular Medium Tight - 줄간격이 좁은 세미볼드
  /// Font: Inter Medium 16px/20px (weight: 500)
  static TextStyle regularMediumTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 20.sp / 16.sp,
    fontWeight: FontWeight.w500,
  );

  /// Regular Medium None - 줄간격 없는 세미볼드
  /// Font: Inter Medium 16px/16px (weight: 500)
  static TextStyle regularMediumNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 1.0,
    fontWeight: FontWeight.w500,
  );

  /// Regular Regular - 기본 본문 텍스트
  /// Font: Inter Regular 16px/24px (weight: 400)
  static TextStyle regularRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 24.sp / 16.sp,
    fontWeight: FontWeight.w400,
  );

  /// Regular Regular Tight - 줄간격이 좁은 기본
  /// Font: Inter Regular 16px/20px (weight: 400)
  static TextStyle regularRegularTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 20.sp / 16.sp,
    fontWeight: FontWeight.w400,
  );

  /// Regular Regular None - 줄간격 없는 기본
  /// Font: Inter Regular 16px/16px (weight: 400)
  static TextStyle regularRegularNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 1.0,
    fontWeight: FontWeight.w400,
  );

  // ============================================================================
  // SMALL STYLES - 작은 텍스트 (14px)
  // ============================================================================
  
  /// Small Bold - 작은 강조 텍스트
  /// Font: Inter Bold 14px/20px (weight: 700)
  static TextStyle smallBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20.sp / 14.sp,
    fontWeight: FontWeight.w700,
  );

  /// Small Bold Tight - 줄간격이 좁은 작은 강조
  /// Font: Inter Bold 14px/16px (weight: 700)
  static TextStyle smallBoldTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 16.sp / 14.sp,
    fontWeight: FontWeight.w700,
  );

  /// Small Bold None - 줄간격 없는 작은 강조
  /// Font: Inter Bold 14px/14px (weight: 700)
  static TextStyle smallBoldNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 1.0,
    fontWeight: FontWeight.w700,
  );

  /// Small Medium - 작은 세미볼드
  /// Font: Inter Medium 14px/20px (weight: 500)
  static TextStyle smallMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20.sp / 14.sp,
    fontWeight: FontWeight.w500,
  );

  /// Small Medium Tight - 줄간격이 좁은 작은 세미볼드
  /// Font: Inter Medium 14px/16px (weight: 500)
  static TextStyle smallMediumTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 16.sp / 14.sp,
    fontWeight: FontWeight.w500,
  );

  /// Small Medium None - 줄간격 없는 작은 세미볼드
  /// Font: Inter Medium 14px/14px (weight: 500)
  static TextStyle smallMediumNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 1.0,
    fontWeight: FontWeight.w500,
  );

  /// Small Regular - 작은 일반 텍스트
  /// Font: Inter Regular 14px/20px (weight: 400)
  static TextStyle smallRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20.sp / 14.sp,
    fontWeight: FontWeight.w400,
  );

  /// Small Regular Tight - 줄간격이 좁은 작은 일반
  /// Font: Inter Regular 14px/16px (weight: 400)
  static TextStyle smallRegularTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 16.sp / 14.sp,
    fontWeight: FontWeight.w400,
  );

  /// Small Regular None - 줄간격 없는 작은 일반
  /// Font: Inter Regular 14px/14px (weight: 400)
  static TextStyle smallRegularNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 1.0,
    fontWeight: FontWeight.w400,
  );

  // ============================================================================
  // TINY STYLES - 매우 작은 텍스트 (12px)
  // ============================================================================
  
  /// Tiny Bold - 매우 작은 강조 (라벨, 뱃지)
  /// Font: Inter Bold 12px/16px (weight: 700)
  static TextStyle tinyBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16.sp / 12.sp,
    fontWeight: FontWeight.w700,
  );

  /// Tiny Bold Tight - 줄간격이 좁은 매우 작은 강조
  /// Font: Inter Bold 12px/14px (weight: 700)
  static TextStyle tinyBoldTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 14.sp / 12.sp,
    fontWeight: FontWeight.w700,
  );

  /// Tiny Bold None - 줄간격 없는 매우 작은 강조
  /// Font: Inter Bold 12px/12px (weight: 700)
  static TextStyle tinyBoldNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 1.0,
    fontWeight: FontWeight.w700,
  );

  /// Tiny Medium - 매우 작은 세미볼드
  /// Font: Inter Medium 12px/16px (weight: 500)
  static TextStyle tinyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16.sp / 12.sp,
    fontWeight: FontWeight.w500,
  );

  /// Tiny Medium Tight - 줄간격이 좁은 매우 작은 세미볼드
  /// Font: Inter Medium 12px/14px (weight: 500)
  static TextStyle tinyMediumTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 14.sp / 12.sp,
    fontWeight: FontWeight.w500,
  );

  /// Tiny Medium None - 줄간격 없는 매우 작은 세미볼드
  /// Font: Inter Medium 12px/12px (weight: 500)
  static TextStyle tinyMediumNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 1.0,
    fontWeight: FontWeight.w500,
  );

  /// Tiny Regular - 매우 작은 일반 텍스트
  /// Font: Inter Regular 12px/16px (weight: 400)
  static TextStyle tinyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16.sp / 12.sp,
    fontWeight: FontWeight.w400,
  );

  /// Tiny Regular Tight - 줄간격이 좁은 매우 작은 일반
  /// Font: Inter Regular 12px/14px (weight: 400)
  static TextStyle tinyRegularTight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 14.sp / 12.sp,
    fontWeight: FontWeight.w400,
  );

  /// Tiny Regular None - 줄간격 없는 매우 작은 일반 (캡션, 타임스탬프)
  /// Font: Inter Regular 12px/12px (weight: 400)
  static TextStyle tinyRegularNone = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 1.0,
    fontWeight: FontWeight.w400,
  );

  // ============================================================================
  // SEMANTIC TEXT STYLES - 의미별 스타일 별칭
  // ============================================================================

  /// 메인 화면 제목 (온보딩, 랜딩페이지)
  static TextStyle get mainTitle => title1;

  /// 페이지 제목 (상단 앱바, 섹션 제목)
  static TextStyle get pageTitle => title2;

  /// 카드/컴포넌트 제목
  static TextStyle get cardTitle => title3;

  /// 본문 텍스트 (기사 내용, 설명)
  static TextStyle get bodyText => regularRegular;

  /// 부제목 (카드 부제, 섹션 설명)
  static TextStyle get subtitle => largeMedium;

  /// 라벨 텍스트 (폼 라벨, 카테고리)
  static TextStyle get label => smallMedium;

  /// 캡션 텍스트 (시간, 출처, 추가 정보)
  static TextStyle get caption => tinyRegular;

  /// 버튼 텍스트 (CTA, 액션 버튼)
  static TextStyle get button => regularBoldNone;

  /// 링크 텍스트 (하이퍼링크, 액션 링크)
  static TextStyle get link => regularMedium;

  /// 에러/경고 메시지
  static TextStyle get errorText => smallRegular;

  /// 힌트 텍스트 (플레이스홀더, 도움말)
  static TextStyle get hint => smallRegular;

  /// 뱃지/칩 텍스트 (태그, 상태 표시)
  static TextStyle get badge => tinyBoldNone;

  /// 타임스탬프 (작성일, 수정일)
  static TextStyle get timestamp => tinyRegular;

  /// 출처 정보 (신뢰도, 출처명)
  static TextStyle get source => tinyMedium;

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// 텍스트 스타일에 색상 적용
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// 텍스트 스타일에 데코레이션 적용 (밑줄, 취소선 등)
  static TextStyle withDecoration(
    TextStyle style, 
    TextDecoration decoration, {
    Color? decorationColor,
  }) {
    return style.copyWith(
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  /// 반응형 크기 조정 (특정 상황에서 폰트 크기 스케일링)
  static TextStyle withScale(TextStyle style, double scale) {
    return style.copyWith(
      fontSize: (style.fontSize ?? 16.sp) * scale,
    );
  }

  /// 자간 조정 (제목이나 특수한 경우)
  static TextStyle withLetterSpacing(TextStyle style, double letterSpacing) {
    return style.copyWith(letterSpacing: letterSpacing);
  }

  // ============================================================================
  // THEME-AWARE TEXT STYLES
  // ============================================================================

  /// 컨텍스트에 따른 동적 색상 적용
  static TextStyle primary(BuildContext context) {
    return regularMedium.copyWith(
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// 에러 색상 적용된 텍스트
  static TextStyle error(BuildContext context) {
    return regularRegular.copyWith(
      color: Theme.of(context).colorScheme.error,
    );
  }

  /// 성공 색상 적용된 텍스트 (사용자 정의 색상 필요)
  static TextStyle success(BuildContext context) {
    return regularRegular.copyWith(
      color: Theme.of(context).colorScheme.secondary,
    );
  }

  /// 비활성화된 텍스트
  static TextStyle disabled(BuildContext context) {
    return regularRegular.copyWith(
      color: Theme.of(context).disabledColor,
    );
  }

  // ============================================================================
  // ACCESSIBILITY HELPERS
  // ============================================================================

  /// 접근성을 위한 최소 크기 보장 (14sp 이상)
  static TextStyle ensureAccessibleSize(TextStyle style) {
    final fontSize = style.fontSize ?? 16.sp;
    if (fontSize < 14.sp) {
      return style.copyWith(fontSize: 14.sp);
    }
    return style;
  }

  /// 고대비 모드용 텍스트 스타일
  static TextStyle highContrast(TextStyle style, BuildContext context) {
    return style.copyWith(
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Colors.white,
      fontWeight: FontWeight.w500, // 가독성 향상을 위해 약간 굵게
    );
  }
}