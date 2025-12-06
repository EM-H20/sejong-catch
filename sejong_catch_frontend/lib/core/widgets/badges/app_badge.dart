import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';

/// 🏷️ 범용 배지 위젯
///
/// 사용처:
/// - 카테고리 배지 (공모전, 취업, 논문 등)
/// - 우선순위 배지 (높음, 중간, 낮음)
/// - 상태 배지 (진행중, 완료, 대기 등)
///
/// 특징:
/// - 3가지 스타일 (filled, outlined, soft)
/// - 아이콘 선택 가능
/// - ScreenUtil 적용 (중복 사용 방지)
class AppBadge extends StatelessWidget {
  /// 표시할 텍스트
  final String label;

  /// 배지 색상 (filled: 배경, outlined: 테두리, soft: 배경 + 테두리)
  final Color color;

  /// 아이콘 (선택사항)
  final IconData? icon;

  /// 배지 스타일
  final AppBadgeStyle style;

  /// 크기
  final AppBadgeSize size;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.style = AppBadgeStyle.filled,
    this.size = AppBadgeSize.medium,
  });

  /// 🎯 Filled 스타일 (배경색 + 흰색 텍스트)
  factory AppBadge.filled({
    required String label,
    required Color color,
    IconData? icon,
    AppBadgeSize size = AppBadgeSize.medium,
  }) {
    return AppBadge(
      label: label,
      color: color,
      icon: icon,
      style: AppBadgeStyle.filled,
      size: size,
    );
  }

  /// ⚪ Outlined 스타일 (투명 배경 + 테두리 + 색상 텍스트)
  factory AppBadge.outlined({
    required String label,
    required Color color,
    IconData? icon,
    AppBadgeSize size = AppBadgeSize.medium,
  }) {
    return AppBadge(
      label: label,
      color: color,
      icon: icon,
      style: AppBadgeStyle.outlined,
      size: size,
    );
  }

  /// 🌫️ Soft 스타일 (연한 배경 + 연한 테두리 + 색상 텍스트)
  factory AppBadge.soft({
    required String label,
    required Color color,
    IconData? icon,
    AppBadgeSize size = AppBadgeSize.medium,
  }) {
    return AppBadge(
      label: label,
      color: color,
      icon: icon,
      style: AppBadgeStyle.soft,
      size: size,
    );
  }

  /// 🏷️ 카테고리 배지 (카테고리별 색상 자동 적용)
  factory AppBadge.category({
    required String category,
    AppBadgeSize size = AppBadgeSize.small,
  }) {
    Color badgeColor;
    switch (category) {
      case '공모전':
        badgeColor = AppColors.brandCrimson;
        break;
      case '취업':
        badgeColor = AppColors.trustAcademic; // 파란색
        break;
      case '논문':
        badgeColor = const Color(0xFF7C3AED); // 보라색
        break;
      case '학교공지':
        badgeColor = AppColors.success;
        break;
      case '축제':
        badgeColor = AppColors.warning;
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return AppBadge.filled(label: category, color: badgeColor, size: size);
  }

  /// 🏆 우선순위 배지
  factory AppBadge.priority({
    required String priority,
    AppBadgeSize size = AppBadgeSize.small,
  }) {
    String label;
    Color color;

    switch (priority) {
      case 'high':
        label = '높음';
        color = AppColors.priorityHigh;
        break;
      case 'mid':
        label = '중간';
        color = AppColors.priorityMid;
        break;
      default:
        label = '낮음';
        color = AppColors.textSecondary;
    }

    return AppBadge.soft(
      label: label,
      color: color,
      icon: Icons.flag,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = _getHorizontalPadding();
    final verticalPadding = _getVerticalPadding();
    final iconSize = _getIconSize();
    final fontSize = _getFontSize();
    final borderRadius = _getBorderRadius();

    // 스타일별 색상 계산
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();
    final borderColor = _getBorderColor();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: textColor),
            AppSpacing.horizontalSpaceXS,
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 스타일별 배경색
  Color _getBackgroundColor() {
    switch (style) {
      case AppBadgeStyle.filled:
        return color;
      case AppBadgeStyle.outlined:
        return Colors.transparent;
      case AppBadgeStyle.soft:
        return color.withValues(alpha: 0.1);
    }
  }

  /// 스타일별 텍스트 색상
  Color _getTextColor() {
    switch (style) {
      case AppBadgeStyle.filled:
        return AppColors.white;
      case AppBadgeStyle.outlined:
      case AppBadgeStyle.soft:
        return color;
    }
  }

  /// 스타일별 테두리 색상
  Color? _getBorderColor() {
    switch (style) {
      case AppBadgeStyle.filled:
        return null;
      case AppBadgeStyle.outlined:
        return color;
      case AppBadgeStyle.soft:
        return color.withValues(alpha: 0.3);
    }
  }

  /// 크기별 가로 패딩
  double _getHorizontalPadding() {
    switch (size) {
      case AppBadgeSize.small:
        return 8.w;
      case AppBadgeSize.medium:
        return 10.w;
      case AppBadgeSize.large:
        return 12.w;
    }
  }

  /// 크기별 세로 패딩
  double _getVerticalPadding() {
    switch (size) {
      case AppBadgeSize.small:
        return 4.h;
      case AppBadgeSize.medium:
        return 6.h;
      case AppBadgeSize.large:
        return 8.h;
    }
  }

  /// 크기별 아이콘 크기
  double _getIconSize() {
    switch (size) {
      case AppBadgeSize.small:
        return 12.sp;
      case AppBadgeSize.medium:
        return 14.sp;
      case AppBadgeSize.large:
        return 16.sp;
    }
  }

  /// 크기별 폰트 크기
  double _getFontSize() {
    switch (size) {
      case AppBadgeSize.small:
        return 11.sp;
      case AppBadgeSize.medium:
        return 13.sp;
      case AppBadgeSize.large:
        return 15.sp;
    }
  }

  /// 크기별 모서리 둥글기
  double _getBorderRadius() {
    switch (size) {
      case AppBadgeSize.small:
        return 6.r;
      case AppBadgeSize.medium:
        return 8.r;
      case AppBadgeSize.large:
        return 10.r;
    }
  }
}

/// 배지 스타일
enum AppBadgeStyle {
  /// 배경색 + 흰색 텍스트
  filled,

  /// 투명 배경 + 테두리 + 색상 텍스트
  outlined,

  /// 연한 배경 + 연한 테두리 + 색상 텍스트
  soft,
}

/// 배지 크기
enum AppBadgeSize { small, medium, large }
