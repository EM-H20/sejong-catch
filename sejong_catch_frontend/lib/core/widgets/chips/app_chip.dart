import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';

/// 🏷️ 범용 칩 위젯 (정보 표시용)
///
/// 사용처:
/// - D-Day 표시 (피드, 검색 결과 등)
/// - 조회수, 좋아요 등 통계 정보
/// - 태그, 카테고리 등 메타 정보
///
/// 특징:
/// - 아이콘 + 텍스트 조합
/// - 커스터마이징 가능한 색상
/// - ScreenUtil 적용 (중복 사용 방지)
class AppChip extends StatelessWidget {
  /// 아이콘 (선택사항)
  final IconData? icon;

  /// 표시할 텍스트
  final String label;

  /// 텍스트 및 아이콘 색상
  final Color color;

  /// 배경 색상
  final Color backgroundColor;

  /// 크기 (small, medium, large)
  final AppChipSize size;

  const AppChip({
    super.key,
    this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.size = AppChipSize.medium,
  });

  /// 🏷️ 정보 칩 (기본 스타일)
  factory AppChip.info({
    required IconData icon,
    required String label,
    Color? color,
    Color? backgroundColor,
  }) {
    return AppChip(
      icon: icon,
      label: label,
      color: color ?? AppColors.textSecondary,
      backgroundColor: backgroundColor ?? AppColors.surface,
    );
  }

  /// ⏰ 게시 경과일 칩 (최근 게시글 강조)
  ///
  /// **표시 형식**: "N일 전", "오늘", "방금"
  /// **isUrgent**: 7일 이내 게시글은 강조 표시
  factory AppChip.dDay({
    required int daysLeft,
    bool isUrgent = false,
  }) {
    // 경과일에 따른 표시 텍스트
    String label;
    if (daysLeft == 0) {
      label = '오늘';
    } else if (daysLeft == 1) {
      label = '1일 전';
    } else if (daysLeft >= 7 && daysLeft < 30) {
      final weeks = (daysLeft / 7).floor();
      label = '$weeks주 전';
    } else if (daysLeft >= 30) {
      final months = (daysLeft / 30).floor();
      label = '$months개월 전';
    } else {
      label = '$daysLeft일 전';
    }

    return AppChip(
      icon: Icons.access_time,
      label: label,
      color: isUrgent ? AppColors.success : AppColors.textSecondary,
      backgroundColor: isUrgent
          ? AppColors.success.withValues(alpha: 0.1)
          : AppColors.surface,
    );
  }

  /// 👁️ 조회수 칩
  factory AppChip.viewCount({
    required int count,
  }) {
    return AppChip(
      icon: Icons.visibility_outlined,
      label: _formatNumber(count),
      color: AppColors.textSecondary,
      backgroundColor: AppColors.surface,
    );
  }

  /// 숫자 포맷팅 (1234 → 1.2K)
  static String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _getHorizontalPadding();
    final verticalPadding = _getVerticalPadding();
    final iconSize = _getIconSize();
    final fontSize = _getFontSize();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: color),
            AppSpacing.horizontalSpaceXS,
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 크기별 가로 패딩
  double _getHorizontalPadding() {
    switch (size) {
      case AppChipSize.small:
        return 6.w;
      case AppChipSize.medium:
        return 8.w;
      case AppChipSize.large:
        return 10.w;
    }
  }

  /// 크기별 세로 패딩
  double _getVerticalPadding() {
    switch (size) {
      case AppChipSize.small:
        return 2.h;
      case AppChipSize.medium:
        return 4.h;
      case AppChipSize.large:
        return 6.h;
    }
  }

  /// 크기별 아이콘 크기
  double _getIconSize() {
    switch (size) {
      case AppChipSize.small:
        return 12.sp;
      case AppChipSize.medium:
        return 14.sp;
      case AppChipSize.large:
        return 16.sp;
    }
  }

  /// 크기별 폰트 크기
  double _getFontSize() {
    switch (size) {
      case AppChipSize.small:
        return 10.sp;
      case AppChipSize.medium:
        return 12.sp;
      case AppChipSize.large:
        return 14.sp;
    }
  }
}

/// 칩 크기 옵션
enum AppChipSize {
  small,
  medium,
  large,
}
