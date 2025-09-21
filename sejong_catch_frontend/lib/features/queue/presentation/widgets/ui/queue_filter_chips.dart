/// 🏷️ 큐 필터 칩 컴포넌트
///
/// 큐 타입별 필터링을 위한 칩 위젯
/// Features:
/// ✅ 타입별 필터 칩 (전체/음식/음료/이벤트/게임/포토존)
/// ✅ 선택 상태 표시
/// ✅ 타입별 색상 & 아이콘
/// ✅ 가로 스크롤 지원
/// ✅ ScreenUtil 반응형 적용
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/queue_model.dart';

class QueueFilterChips extends ConsumerWidget {
  final QueueType? selectedType;
  final ValueChanged<QueueType?> onTypeSelected;

  const QueueFilterChips({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 전체 필터
          _buildFilterChip(
            label: '전체',
            icon: Icons.apps,
            color: AppColors.brandCrimson,
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),

          SizedBox(width: 8.w),

          // 타입별 필터들
          ...QueueType.values.map(
            (type) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _buildFilterChip(
                label: _getTypeLabel(type),
                icon: _getTypeIcon(type),
                color: _getTypeColor(type),
                isSelected: selectedType == type,
                onTap: () => onTypeSelected(type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🏷️ 개별 필터 칩
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: isSelected ? Colors.white : color),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏷️ 타입별 라벨
  String _getTypeLabel(QueueType type) {
    switch (type) {
      case QueueType.food:
        return '음식';
      case QueueType.drink:
        return '음료';
      case QueueType.event:
        return '이벤트';
      case QueueType.game:
        return '게임';
      case QueueType.photo:
        return '포토존';
      case QueueType.other:
        return '기타';
    }
  }

  /// 🎯 타입별 아이콘
  IconData _getTypeIcon(QueueType type) {
    switch (type) {
      case QueueType.food:
        return Icons.restaurant;
      case QueueType.drink:
        return Icons.local_drink;
      case QueueType.event:
        return Icons.event;
      case QueueType.game:
        return Icons.sports_esports;
      case QueueType.photo:
        return Icons.photo_camera;
      case QueueType.other:
        return Icons.more_horiz;
    }
  }

  /// 🎨 타입별 색상
  Color _getTypeColor(QueueType type) {
    switch (type) {
      case QueueType.food:
        return Colors.orange;
      case QueueType.drink:
        return Colors.blue;
      case QueueType.event:
        return AppColors.brandCrimson;
      case QueueType.game:
        return Colors.green;
      case QueueType.photo:
        return Colors.purple;
      case QueueType.other:
        return Colors.grey;
    }
  }
}
