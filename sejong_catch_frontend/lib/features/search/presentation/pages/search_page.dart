import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../feed/presentation/widgets/ui/feed_card.dart';
import '../controllers/search_controller.dart';
import '../models/search_state.dart';
import '../widgets/ui/filter_bottom_sheet.dart';
import '../widgets/ui/search_bar.dart';

/// 🔍 검색 페이지 - 정보 검색 및 필터링
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 Riverpod 연동
/// ✅ FeedCard 재사용 (DRY 원칙)
/// ✅ 최근 검색어 (SharedPreferences 캐싱)
/// ✅ Real 모드 크롤러 데이터 검색
/// ✅ AppColors, AppSpacing, AppTextStyles 100% 사용
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 검색바 (필터 버튼 포함)
            SearchBarWidget(
              onShowFilter: () => _showFilterBottomSheet(context),
            ),

            // 구분선
            AppDivider.thin(),

            // 검색 결과, 로딩, 에러, 또는 최근 검색어
            Expanded(
              child: _buildContent(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  /// 📱 메인 컨텐츠 (상태에 따라 다른 UI)
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
  ) {
    // 로딩 중
    if (state.isSearching) {
      return const LoadingWidget();
    }

    // 에러 발생
    if (state.error != null) {
      return AppErrorWidget(message: state.error!);
    }

    // 검색 결과가 있는 경우
    if (state.searchResults.isNotEmpty) {
      return _buildSearchResults(context, ref, state);
    }

    // 검색어가 있지만 결과가 없는 경우
    if (state.query.isNotEmpty && state.searchResults.isEmpty) {
      return const EmptyListWidget(
        icon: Icons.search_off,
        message: '검색 결과가 없어요\n다른 키워드로 시도해보세요',
      );
    }

    // 기본 상태: 최근 검색어 표시
    return _buildRecentSearches(context, ref, state);
  }

  /// 📊 검색 결과 (FeedCard 재사용)
  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
  ) {
    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
      itemBuilder: (context, index) {
        final feedItem = state.searchResults[index];

        // FeedItem → Map 변환 (FeedCard가 Map을 받기 때문)
        final itemMap = {
          'id': feedItem.id,
          'title': feedItem.title,
          'description': feedItem.description,
          'category': feedItem.category,
          'thumbnailUrl': feedItem.thumbnailUrl,
          'dDay': feedItem.dDay,
          'viewCount': feedItem.viewCount,
          'priority': feedItem.priority,
          'isBookmarked': feedItem.isBookmarked,
          'createdAt': feedItem.createdAt,
        };

        return FeedCard(
          item: itemMap,
          onTap: () {
            // TODO: 상세 페이지로 이동
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${feedItem.title} 상세보기 (준비 중)')),
            );
          },
        );
      },
    );
  }

  /// 🕐 최근 검색어
  Widget _buildRecentSearches(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
  ) {
    if (state.recentSearches.isEmpty) {
      return const EmptyListWidget(
        icon: Icons.history,
        message: '최근 검색 내역이 없어요\n검색어를 입력해보세요',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 검색어',
                style: AppTextStyles.headingSemiBold20,
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(searchControllerProvider.notifier)
                      .clearAllRecentSearches();
                },
                child: Text(
                  '전체 삭제',
                  style: AppTextStyles.bodyRegular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        AppSpacing.verticalSpaceSM,

        // 최근 검색어 목록
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            itemCount: state.recentSearches.length,
            separatorBuilder: (context, index) => AppDivider.thin(),
            itemBuilder: (context, index) {
              final keyword = state.recentSearches[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.history,
                  color: AppColors.textTertiary,
                  size: 20.sp,
                ),
                title: Text(
                  keyword,
                  style: AppTextStyles.bodyRegular14,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.textTertiary,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    ref
                        .read(searchControllerProvider.notifier)
                        .removeRecentSearch(keyword);
                  },
                ),
                onTap: () {
                  ref
                      .read(searchControllerProvider.notifier)
                      .selectRecentSearch(keyword);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// 🎛️ 고급 필터 바텀시트
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
