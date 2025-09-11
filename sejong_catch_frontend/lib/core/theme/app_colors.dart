import 'package:flutter/material.dart';

/// Sejong Catch 앱의 모든 색상 토큰을 정의합니다.
/// 
/// Crimson Red를 메인 컬러로 하는 브랜딩 색상과
/// Material 3 디자인 시스템에 맞는 보조 색상들을 포함합니다.
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
  static const Color brandCrimsonLight = Color(0xFFF7E3E8);

  // ============================================================================
  // Base Colors
  // ============================================================================
  
  /// 순수 흰색 - 카드 배경, 텍스트
  static const Color white = Color(0xFFFFFFFF);
  
  /// 메인 배경 색상 (라이트 모드)
  /// 앱 전체 배경, AppBar 배경에 사용
  static const Color surface = Color(0xFFF7F7F8);

  // ============================================================================
  // Text Colors
  // ============================================================================
  
  /// 주요 텍스트 색상 (라이트 모드)
  /// 제목, 중요한 텍스트에 사용
  static const Color textPrimary = Color(0xFF111111);
  
  /// 보조 텍스트 색상
  /// 설명 텍스트, 메타데이터에 사용
  static const Color textSecondary = Color(0xFF6B7280);

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
  // UI Element Colors
  // ============================================================================
  
  /// 구분선 색상
  static const Color divider = Color(0xFFE5E7EB);
  
  /// 비활성화된 요소 색상
  static const Color disabled = Color(0xFF9CA3AF);
  
  /// 그림자 색상 (투명도 적용 필요)
  static const Color shadow = Color(0xFF000000);

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