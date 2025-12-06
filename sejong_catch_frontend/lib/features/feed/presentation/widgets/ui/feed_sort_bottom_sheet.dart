import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/controllers/feed_sort_controller.dart';

/// 📊 피드 정렬 선택 바텀시트
class FeedSortBottomSheet extends StatelessWidget {
  /// 현재 선택된 정렬 타입
  final FeedSortType currentSort;

  /// 정렬 타입 변경 콜백
  final ValueChanged<FeedSortType> onSortChanged;

  const FeedSortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 드래그 핸들
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // 제목
            Padding(
              padding: AppSpacing.screenPadding,
              child: Row(
                children: [
                  Icon(Icons.sort, size: 20.sp, color: AppColors.textPrimary),
                  AppSpacing.horizontalSpaceSM,
                  Text('정렬 기준 선택', style: AppTextStyles.headingSemiBold20),
                ],
              ),
            ),

            AppSpacing.verticalSpaceMD,

            // 정렬 옵션 리스트
            ...FeedSortType.values.map((type) {
              final isSelected = currentSort == type;
              return _SortOption(
                type: type,
                isSelected: isSelected,
                onTap: () {
                  onSortChanged(type);
                  Navigator.pop(context);
                },
              );
            }),

            AppSpacing.verticalSpaceLG,
          ],
        ),
      ),
    );
  }
}

/// 📊 정렬 옵션 아이템 (내부 위젯)
class _SortOption extends StatelessWidget {
  final FeedSortType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            // 라디오 버튼
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 24.sp,
              color: isSelected ? AppColors.brandCrimson : AppColors.disabled,
            ),

            AppSpacing.horizontalSpaceMD,

            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 라벨
                  Text(
                    type.label,
                    style: AppTextStyles.titleSemiBold16.copyWith(
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.textPrimary,
                    ),
                  ),

                  // 설명
                  SizedBox(height: 4.h),
                  Text(
                    type.description,
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // 체크 아이콘 (선택 시)
            if (isSelected)
              Icon(Icons.check, size: 20.sp, color: AppColors.brandCrimson),
          ],
        ),
      ),
    );
  }
}
