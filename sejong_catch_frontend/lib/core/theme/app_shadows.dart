import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// 세종 캐치 앱의 표준 그림자 스타일을 정의합니다.
///
/// 일관된 그림자 효과로 앱 전체의 비주얼 통일성을 제공합니다.
class AppShadows {
  AppShadows._(); // Private constructor

  // ============================================================================
  // Standard Shadow Styles
  // ============================================================================

  /// 기본 그림자 - 카드, 버튼 등에 사용
  /// 부드럽고 자연스러운 기본 효과
  static List<BoxShadow> get basic => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.1),
      blurRadius: 4.r,
      offset: Offset(0, 2.h),
    ),
  ];

  /// 네비게이션 바 그림자 - 상단 그림자
  /// 떠있는 듯한 효과로 구분감 제공
  static List<BoxShadow> get navigationBar => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.1),
      blurRadius: 10.r,
      offset: Offset(0, -2.h),
    ),
  ];

  /// 중간 그림자 - 중요한 컴포넌트에 사용
  /// 약간의 강조 효과 제공
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.15),
      blurRadius: 8.r,
      offset: Offset(0, 4.h),
    ),
  ];

  /// 강한 그림자 - 모달, 다이얼로그에 사용
  /// 선명한 구분과 포커스 효과
  static List<BoxShadow> get strong => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.2),
      blurRadius: 16.r,
      offset: Offset(0, 8.h),
    ),
  ];

  /// 플로팅 액션 버튼 그림자
  /// 높은 Z-depth로 뚜렷한 부유감 연출
  static List<BoxShadow> get floating => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.3),
      blurRadius: 20.r,
      offset: Offset(0, 10.h),
    ),
  ];

  // ============================================================================
  // Specialized Shadow Effects
  // ============================================================================

  /// 내부 그림자 효과 (inset 대신 사용)
  /// 눌린 듯한 효과나 입력 필드에 활용
  static List<BoxShadow> get inset => [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.05),
      blurRadius: 4.r,
      offset: Offset(0, 2.h),
      spreadRadius: -2.r,
    ),
  ];

  /// 브랜드 색상 그림자 (크림슨 계열)
  /// 중요한 CTA 버튼이나 액센트 요소에 사용
  static List<BoxShadow> get crimsonGlow => [
    BoxShadow(
      color: AppColors.brandCrimson.withValues(alpha: 0.2),
      blurRadius: 12.r,
      offset: Offset(0, 4.h),
    ),
  ];

  /// 성공 상태 그림자 (녹색 계열)
  /// 성공 메시지나 완료 버튼에 사용
  static List<BoxShadow> get successGlow => [
    BoxShadow(
      color: AppColors.success.withValues(alpha: 0.2),
      blurRadius: 12.r,
      offset: Offset(0, 4.h),
    ),
  ];

  /// 경고 상태 그림자 (주황색 계열)
  /// 경고 메시지나 주의 버튼에 사용
  static List<BoxShadow> get warningGlow => [
    BoxShadow(
      color: AppColors.warning.withValues(alpha: 0.2),
      blurRadius: 12.r,
      offset: Offset(0, 4.h),
    ),
  ];

  /// 에러 상태 그림자 (빨간색 계열)
  /// 에러 메시지나 위험 버튼에 사용
  static List<BoxShadow> get errorGlow => [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.2),
      blurRadius: 12.r,
      offset: Offset(0, 4.h),
    ),
  ];

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// 커스텀 그림자 생성 헬퍼
  /// 특별한 요구사항이 있을 때 사용
  static List<BoxShadow> custom({
    Color? color,
    double? blurRadius,
    double? spreadRadius,
    Offset? offset,
    double alpha = 0.1,
  }) => [
    BoxShadow(
      color: (color ?? AppColors.shadow).withValues(alpha: alpha),
      blurRadius: (blurRadius ?? 4).r,
      spreadRadius: (spreadRadius ?? 0).r,
      offset: offset ?? Offset(0, 2.h),
    ),
  ];
}
