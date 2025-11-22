import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../feed/data/models/response/crawler_result.dart';
import '../../controllers/search_controller.dart';

/// 🎛️ 필터 바텀시트 - 카테고리 필터 전용!
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 Riverpod 연동
/// ✅ CrawlerCategory.allCategories 동기화 (Real 모드 대응)
/// ✅ AppColors, AppSpacing, AppShadows 100% 사용
/// ✅ ScreenUtil (.w, .h, .sp, .r) 필수
class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  /// 카테고리 목록 (동적 생성: '전체' + 크롤러 10개 카테고리)
  static List<String> get _categories => [
        '전체',
        ...CrawlerCategory.allCategories,
      ];

  /// 시간 범위 목록
  static const List<String> _timeRanges = [
    '전체',
    '최근 1주일',
    '최근 1개월',
    '최근 3개월',
    '최근 6개월',
  ];

  /// 조회수 범위 프리셋 목록
  static const List<String> _viewsRanges = [
    '전체',
    '1천 미만',
    '1천~5천',
    '5천~1만',
    '1만 이상',
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
                style: AppTextStyles.headingSemiBold20,
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
            style: AppTextStyles.titleSemiBold16,
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _categories.map((category) {
              final isSelected = category == state.selectedCategory;
              return GestureDetector(
                onTap: () => controller.updateCategory(category),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
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
                    style: AppTextStyles.labelMedium14.copyWith(
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

          // 시간 범위
          Text(
            '시간 범위',
            style: AppTextStyles.titleSemiBold16,
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _timeRanges.map((timeRange) {
              final isSelected = timeRange == state.selectedTimeRange;
              return GestureDetector(
                onTap: () => controller.updateTimeRange(timeRange),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
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
                    timeRange,
                    style: AppTextStyles.labelMedium14.copyWith(
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

          // 조회수 범위
          Text(
            '조회수 범위',
            style: AppTextStyles.titleSemiBold16,
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _viewsRanges.map((viewsRange) {
              final isSelected = viewsRange == state.selectedViewsRange;
              return GestureDetector(
                onTap: () => controller.updateViewsRange(viewsRange),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
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
                    viewsRange,
                    style: AppTextStyles.labelMedium14.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
