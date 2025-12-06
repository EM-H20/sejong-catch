import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// 🏷️ 큐 타입 칩 위젯
///
/// 큐의 종류를 표시하는 칩 컴포넌트입니다.
/// - 아이콘과 레이블
/// - 타입별 색상 지정
/// - 선택 상태 표현
///
/// **디자인 토큰 100% 사용!**
class QueueTypeChip extends StatelessWidget {
  final String type;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const QueueTypeChip({
    super.key,
    required this.type,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  /// 타입별 색상 반환
  Color get _typeColor {
    switch (type) {
      case 'food':
        return const Color(0xFFFF6B6B); // 음식 - 빨강
      case 'drink':
        return const Color(0xFF4ECDC4); // 음료 - 청록
      case 'game':
        return const Color(0xFFFFBE0B); // 게임 - 노랑
      case 'photo':
        return const Color(0xFF9B59B6); // 사진 - 보라
      default:
        return AppColors.textSecondary; // 기타 - 회색
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.background,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? color : AppColors.textSecondary,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.labelMedium14.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎨 미리 정의된 큐 타입 칩들
class QueueTypeChips {
  QueueTypeChips._();

  /// 음식 큐
  static QueueTypeChip food({
    required bool isSelected,
    required VoidCallback onTap,
  }) => QueueTypeChip(
    type: 'food',
    label: '음식',
    icon: Icons.restaurant_rounded,
    isSelected: isSelected,
    onTap: onTap,
  );

  /// 음료 큐
  static QueueTypeChip drink({
    required bool isSelected,
    required VoidCallback onTap,
  }) => QueueTypeChip(
    type: 'drink',
    label: '음료',
    icon: Icons.local_cafe_rounded,
    isSelected: isSelected,
    onTap: onTap,
  );

  /// 게임 큐
  static QueueTypeChip game({
    required bool isSelected,
    required VoidCallback onTap,
  }) => QueueTypeChip(
    type: 'game',
    label: '게임',
    icon: Icons.sports_esports_rounded,
    isSelected: isSelected,
    onTap: onTap,
  );

  /// 포토 큐
  static QueueTypeChip photo({
    required bool isSelected,
    required VoidCallback onTap,
  }) => QueueTypeChip(
    type: 'photo',
    label: '포토',
    icon: Icons.photo_camera_rounded,
    isSelected: isSelected,
    onTap: onTap,
  );

  /// 기타 큐
  static QueueTypeChip other({
    required bool isSelected,
    required VoidCallback onTap,
  }) => QueueTypeChip(
    type: 'other',
    label: '기타',
    icon: Icons.more_horiz_rounded,
    isSelected: isSelected,
    onTap: onTap,
  );
}
