import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../controllers/search_controller.dart';
import 'keyword_chip.dart';

/// 🔥 인기 키워드 섹션
///
/// CLAUDE.md 원칙:
/// ✅ DRY 원칙 - KeywordChip 재사용
/// ✅ ConsumerWidget으로 Riverpod 연동
/// ✅ AppColors, AppSpacing 100% 사용
/// ✅ EmptyState 활용 (최근 검색)
class PopularKeywords extends ConsumerWidget {
  const PopularKeywords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);

    return SingleChildScrollView(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인기 키워드 제목
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 20.sp,
                color: AppColors.brandCrimson,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                '인기 검색어',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceLG,

          // 인기 키워드 칩들
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 8.h,
            children: state.popularKeywords.asMap().entries.map((entry) {
              final index = entry.key;
              final keyword = entry.value;
              return KeywordChip(
                keyword: keyword,
                rank: index + 1,
                onTap: () => controller.selectKeyword(keyword),
              );
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXXL,

          // 구분선
          AppDivider.thin(),

          AppSpacing.verticalSpaceXL,

          // 최근 검색 헤더
          Row(
            children: [
              Icon(Icons.history, size: 20.sp, color: AppColors.textSecondary),
              AppSpacing.horizontalSpaceSM,
              Text(
                '최근 검색',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceLG,

          // 최근 검색 (빈 상태) - EmptyListWidget 활용!
          const EmptyListWidget(
            icon: Icons.search_off,
            message: '최근 검색 내역이 없어요',
          ),
        ],
      ),
    );
  }
}
