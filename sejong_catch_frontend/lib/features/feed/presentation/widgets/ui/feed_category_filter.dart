import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';

/// 🏷️ 피드 카테고리 필터 위젯
///
/// 기능:
/// - 가로 스크롤 가능한 카테고리 칩 리스트
/// - 선택된 카테고리 강조 표시
/// - 탭으로 카테고리 변경 가능
class FeedCategoryFilter extends StatelessWidget {
  /// 카테고리 목록
  final List<String> categories;

  /// 선택된 카테고리
  final String selectedCategory;

  /// 카테고리 변경 콜백
  final ValueChanged<String> onCategoryChanged;

  const FeedCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.categoryFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.categoryFilterPadding,
        itemCount: categories.length,
        separatorBuilder: (context, index) => AppSpacing.horizontalSpaceSM,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategoryChanged(category),
            child: _CategoryChip(label: category, isSelected: isSelected),
          );
        },
      ),
    );
  }
}

/// 🏷️ 카테고리 칩 (내부 위젯)
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.categoryChipPadding,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.brandCrimson : AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? AppColors.brandCrimson : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
