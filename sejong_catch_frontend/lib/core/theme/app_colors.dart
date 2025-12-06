import 'package:flutter/material.dart';

/// Sejong Catch 앱의 모든 색상 토큰을 정의합니다.
///
/// Crimson Red를 메인 컬러로 하며,
/// Soft Ivory (#FAF9F6) 기반의 따뜻하고 세련된 색상 팔레트를 사용합니다.
///
/// 디자인 철학:
/// - 눈의 피로를 줄이는 부드러운 오프화이트 배경
/// - 크림슨 레드의 정열과 소프트 그레이의 우아함 조화
/// - 프리미엄 대학교 앱다운 세련미
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================================
  // Brand Colors (Crimson Red Theme)
  // ============================================================================

  /// 메인 브랜드 색상 - 크림슨 레드
  /// 주요 CTA 버튼, 액센트, 선택 상태에 사용
  static const Color brandCrimson = Color(0xFFDC143C);

  /// 어두운 크림슨 - pressed 상태, 다크 모드용
  /// 버튼 눌림 상태, 강조 효과에 사용
  static const Color brandCrimsonDark = Color(0xFFB0102F);

  /// 밝은 크림슨 - 선택된 칩, 라이트 배경용
  /// FilterChip 선택 상태, 하이라이트 배경에 사용
  /// 기존보다 더 소프트하게 조정
  static const Color brandCrimsonLight = Color(0xFFF9E8EC);

  /// 투명도 30% 적용된 밝은 크림슨 - SliverAppBar 배경용
  static final Color brandCrimsonLight30 = brandCrimsonLight.withValues(
    alpha: 0.3,
  );

  /// 투명도 10% 적용된 크림슨 - 섬세한 테두리용
  static final Color brandCrimson10 = brandCrimson.withValues(alpha: 0.1);

  // ============================================================================
  // Base Colors (Soft Ivory Palette)
  // ============================================================================

  /// 소프트 아이보리 - 기본 배경, 카드 색상
  /// 순수 흰색보다 따뜻하고 눈의 피로가 적음
  /// 앱의 주요 배경색으로 사용
  static const Color white = Color(0xFFFAF9F6);

  /// 라이트 웜 그레이 - 앱 메인 배경
  /// white보다 살짝 어두워 계층 구분에 사용
  static const Color surface = Color(0xFFF5F4F1);

  /// 미드 웜 그레이 - 더 어두운 배경
  /// 3단계 계층 구조에서 가장 어두운 배경
  static const Color background = Color(0xFFEFEEEB);

  // ============================================================================
  // Text Colors (Warm Gray Palette)
  // ============================================================================

  /// 주요 텍스트 색상 - 따뜻한 다크 그레이
  /// 제목, 중요한 텍스트에 사용
  /// 순흑색보다 부드럽고 따뜻함
  static const Color textPrimary = Color(0xFF2C2C2C);

  /// 보조 텍스트 색상 - 중립 그레이
  /// 설명 텍스트, 메타데이터에 사용
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// 3차 텍스트 색상 - 라이트 그레이
  /// 캡션, 덜 중요한 정보에 사용
  static const Color textTertiary = Color(0xFF9E9E9E);

  // ============================================================================
  // Semantic Colors
  // ============================================================================

  /// 성공 색상 - 완료, 성공 메시지
  static const Color success = Color(0xFF16A34A);

  /// 경고 색상 - 주의, 알림
  static const Color warning = Color(0xFFF59E0B);

  /// 에러 색상 - 오류, 삭제, 위험
  static const Color error = Color(0xFFDC2626);

  // ============================================================================
  // Queue-Specific Colors (큐 기능 전용 색상)
  // ============================================================================

  /// 큐 타이머/예상 시간 색상 - 보라색
  static const Color queueTimer = Color(0xFF8B5CF6);

  // ============================================================================
  // UI Element Colors
  // ============================================================================

  /// 구분선 색상 - 따뜻한 베이지 톤
  /// 소프트 아이보리와 조화로운 구분선
  static const Color divider = Color(0xFFE0DED9);

  /// 비활성화된 요소 색상 - 소프트 그레이
  static const Color disabled = Color(0xFF8F8C87);

  /// 그림자 색상 - 부드러운 다크 그레이
  /// 순흑색보다 자연스러운 그림자 표현
  static const Color shadow = Color(0xFF3C3C3C);

  // ============================================================================
  // Special Colors
  // ============================================================================

  /// 투명 색상 (Material 3 표준)
  /// AppBar 배경, StatusBar, Checkbox 등에 사용
  static const Color transparent = Colors.transparent;

  /// 미세한 오버레이용 색상
  /// 모달 배경, hover 효과 등에 사용
  static const Color overlay = Color(0x0A000000); // 4% 검정

  /// 순수 흰색 (특수 용도)
  /// 크림슨 버튼의 텍스트 등 특별한 경우에만 사용
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// 순수 검정 (특수 용도)
  /// 극도로 강한 대비가 필요한 경우에만 사용
  static const Color pureBlack = Color(0xFF000000);

  // ============================================================================
  // Trust & Priority Colors (앱 특화 색상)
  // ============================================================================

  /// 공식 출처 신뢰도 색상 (Official)
  static const Color trustOfficial = brandCrimson;

  /// 학술 출처 신뢰도 색상 (Academic)
  static const Color trustAcademic = Color(0xFF3B82F6);

  /// 언론 출처 신뢰도 색상 (Press)
  static const Color trustPress = Color(0xFF6B7280);

  /// 커뮤니티 출처 신뢰도 색상 (Community)
  static const Color trustCommunity = Color(0xFF9CA3AF);

  /// 높은 우선순위 색상 (High Priority)
  static const Color priorityHigh = brandCrimson;

  /// 중간 우선순위 색상 (Mid Priority)
  static const Color priorityMid = brandCrimsonLight;

  /// 낮은 우선순위는 투명 (색상 없음)

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// 신뢰도 레벨에 따른 색상 반환
  static Color getTrustColor(String trustLevel) {
    switch (trustLevel.toLowerCase()) {
      case 'official':
        return trustOfficial;
      case 'academic':
        return trustAcademic;
      case 'press':
        return trustPress;
      case 'community':
        return trustCommunity;
      default:
        return textSecondary;
    }
  }

  /// 우선순위 레벨에 따른 색상 반환
  static Color? getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return priorityHigh;
      case 'mid':
      case 'medium':
        return priorityMid;
      case 'low':
        return null; // 투명/색상 없음
      default:
        return null;
    }
  }
}
