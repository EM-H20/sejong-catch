import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cards/app_card.dart';
import '../../data/models/search_state.dart';
import '../controllers/search_controller.dart';

/// 🔍 검색 결과 위젯 (무한 스크롤 포함)
///
/// CLAUDE.md 원칙:
/// ✅ 깔끔한 리스트 뷰와 무한 스크롤
/// ✅ 빈 상태, 로딩, 에러 처리
/// ✅ 매력적인 카드 레이아웃
class SearchResultsWidget extends ConsumerStatefulWidget {
  const SearchResultsWidget({super.key});

  @override
  ConsumerState<SearchResultsWidget> createState() =>
      _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends ConsumerState<SearchResultsWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 무한 스크롤 트리거 (90% 지점에서)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final searchController = ref.read(searchControllerProvider.notifier);
      searchController.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final searchController = ref.read(searchControllerProvider.notifier);

    // 빈 상태 처리
    if (searchState.query.isEmpty) {
      return _buildInitialState();
    }

    // 검색 결과가 없는 경우
    if (searchState.results.isEmpty && !searchState.isLoading) {
      return _buildEmptyState();
    }

    // 에러 상태
    if (searchState.error != null) {
      return _buildErrorState(searchState.error!, searchController);
    }

    return Column(
      children: [
        // 📊 검색 결과 헤더
        _buildResultsHeader(searchState),

        SizedBox(height: 16.h),

        // 📋 검색 결과 리스트
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await searchController.refresh();
            },
            color: AppColors.brandCrimson,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: searchState.results.length +
                  (searchState.hasMore && searchState.isLoading ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                // 로딩 인디케이터 (마지막 아이템)
                if (index >= searchState.results.length) {
                  return _buildLoadingMoreIndicator();
                }

                final result = searchState.results[index];
                return _buildResultCard(result, searchController);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 📊 검색 결과 헤더
  Widget _buildResultsHeader(SearchState searchState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 결과 개수
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              children: [
                TextSpan(
                  text: "'${searchState.query}'",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandCrimson,
                  ),
                ),
                TextSpan(text: ' 검색 결과 '),
                TextSpan(
                  text: '${searchState.results.length}개',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 정렬 옵션 (추후 확장)
          _buildSortButton(searchState),
        ],
      ),
    );
  }

  /// 📶 정렬 버튼
  Widget _buildSortButton(SearchState searchState) {
    final sortLabels = {
      SortType.relevance: '관련도순',
      SortType.deadline: '마감일순',
      SortType.latest: '최신순',
      SortType.popular: '인기순',
    };

    return PopupMenuButton<SortType>(
      initialValue: searchState.filter.sortType,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            sortLabels[searchState.filter.sortType] ?? '관련도순',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.sort,
            size: 16.r,
            color: Colors.grey[600],
          ),
        ],
      ),
      itemBuilder: (context) {
        return sortLabels.entries.map((entry) {
          return PopupMenuItem<SortType>(
            value: entry.key,
            child: Row(
              children: [
                Icon(
                  _getSortIcon(entry.key),
                  size: 16.r,
                  color: entry.key == searchState.filter.sortType
                      ? AppColors.brandCrimson
                      : Colors.grey[600],
                ),
                SizedBox(width: 8.w),
                Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: entry.key == searchState.filter.sortType
                        ? AppColors.brandCrimson
                        : Colors.black87,
                    fontWeight: entry.key == searchState.filter.sortType
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (sortType) {
        final updatedFilter = searchState.filter.copyWith(sortType: sortType);
        ref.read(searchControllerProvider.notifier).updateFilter(updatedFilter);
      },
    );
  }

  /// 정렬 아이콘 가져오기
  IconData _getSortIcon(SortType sortType) {
    switch (sortType) {
      case SortType.relevance:
        return Icons.stars;
      case SortType.deadline:
        return Icons.schedule;
      case SortType.latest:
        return Icons.new_releases;
      case SortType.popular:
        return Icons.trending_up;
    }
  }

  /// 📋 검색 결과 카드
  Widget _buildResultCard(
    SearchResult result,
    searchController,
  ) {
    return AppCard(
      title: result.title,
      subtitle: result.subtitle,
      category: _getCategoryLabel(result.category),
      deadline: result.deadline,
      trustLevel: _getTrustLevelLabel(result.trustLevel),
      isBookmarked: result.isBookmarked,
      onTap: () {
        // TODO: 상세 페이지로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.title} 상세 보기'),
            backgroundColor: AppColors.brandCrimson,
          ),
        );
      },
      onBookmarkTap: () => searchController.toggleBookmark(result.id),
    );
  }

  /// 📂 카테고리 라벨
  String _getCategoryLabel(SearchCategory category) {
    switch (category) {
      case SearchCategory.competition:
        return '공모전';
      case SearchCategory.job:
        return '취업';
      case SearchCategory.paper:
        return '논문';
      case SearchCategory.notice:
        return '공지사항';
    }
  }

  /// 🛡️ 신뢰도 라벨
  String _getTrustLevelLabel(TrustLevel trustLevel) {
    switch (trustLevel) {
      case TrustLevel.official:
        return 'official';
      case TrustLevel.academic:
        return 'academic';
      case TrustLevel.press:
        return 'press';
      case TrustLevel.community:
        return 'community';
    }
  }


  /// ⏳ 더 로딩 인디케이터
  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.brandCrimson,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '더 많은 결과를 불러오는 중...',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏠 초기 상태 (검색 전)
  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            '관심 있는 정보를 검색해보세요',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '공모전, 취업, 논문, 공지사항 등을\n한번에 찾을 수 있어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// 📭 빈 결과 상태
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            '검색 결과가 없어요',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '다른 키워드로 시도해보세요',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              // 인기 키워드로 이동
            },
            icon: Icon(Icons.local_fire_department, size: 16.r),
            label: Text('인기 키워드 보기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ❌ 에러 상태
  Widget _buildErrorState(String error, searchController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.r,
            color: AppColors.error,
          ),
          SizedBox(height: 16.h),
          Text(
            '오류가 발생했어요',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              searchController.clearError();
              searchController.refresh();
            },
            icon: Icon(Icons.refresh, size: 16.r),
            label: Text('다시 시도'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}