import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../controllers/search_controller.dart';

/// 🎛️ 필터 바텀시트 - Riverpod 연동 버전!
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 Riverpod 연동
/// ✅ AppColors, AppSpacing, AppShadows 100% 사용
/// ✅ ScreenUtil (.w, .h, .sp, .r) 필수
class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  // 카테고리 목록
  static const List<String> _categories = [
    '전체',
    '공모전',
    '취업',
    '논문',
    '공지사항',
  ];

  // 신뢰도 목록
  static const List<String> _trustLevels = [
    '전체',
    '공식',
    '학술',
    '언론',
    '커뮤니티',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: AppShadows.strong,
      ),
      padding: AppSpacing.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(
                '고급 필터',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          AppSpacing.verticalSpaceXXL,

          // 카테고리
          Text(
            '카테고리',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 8.h,
            children: _categories.map((category) {
              final isSelected = category == state.selectedCategory;
              return GestureDetector(
                onTap: () => controller.updateCategory(category),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandCrimson
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.divider,
                    ),
                    boxShadow: isSelected ? AppShadows.crimsonGlow : null,
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXL,

          // 구분선
          AppDivider.thin(),

          AppSpacing.verticalSpaceXL,

          // 신뢰도
          Text(
            '신뢰도',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm.h,
            children: _trustLevels.map((trust) {
              final isSelected = trust == state.selectedTrust;
              return GestureDetector(
                onTap: () => controller.updateTrust(trust),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandCrimson
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.divider,
                    ),
                    boxShadow: isSelected ? AppShadows.crimsonGlow : null,
                  ),
                  child: Text(
                    trust,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXL,

          // 구분선
          AppDivider.thin(),

          AppSpacing.verticalSpaceXL,

          // 마감일
          Text(
            '마감일 (D-${state.deadlineRange.end.toInt()}일 이내)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          RangeSlider(
            values: state.deadlineRange,
            min: 0,
            max: 90,
            divisions: 18,
            activeColor: AppColors.brandCrimson,
            inactiveColor: AppColors.divider,
            onChanged: (values) => controller.updateDeadlineRange(values),
          ),

          AppSpacing.verticalSpaceXXL,

          // 적용 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilter();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('필터가 적용되었어요! 🎯')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCrimson,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                '필터 적용',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
