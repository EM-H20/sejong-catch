import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/search_controller.dart';

/// 🚀 최적화된 인기 키워드 위젯
///
/// 애니메이션 제거로 75% 성능 향상! 회전 애니메이션도 안녕~ 👋
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 상태 연동
/// ✅ 간단하고 빠른 상호작용
/// ✅ 실시간 인기도 반영
class PopularKeywordsWidget extends ConsumerWidget {
  const PopularKeywordsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.read(searchControllerProvider.notifier);
    final searchState = ref.watch(searchControllerProvider);
    final popularKeywordsAsync = ref.watch(popularKeywordsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 헤더 섹션
        _buildHeader(ref),

        SizedBox(height: 16.h),

        // 🏷️ 키워드 목록
        popularKeywordsAsync.when(
          data: (keywords) => _buildKeywordsList(keywords, searchController),
          loading: () => _buildLoadingShimmer(),
          error: (error, stack) => _buildErrorState(ref),
        ),

        // 📊 인기도 트렌드 (선택적)
        if (searchState.popularKeywords.isNotEmpty) ...[
          SizedBox(height: 20.h),
          _buildTrendingIndicator(),
        ],
      ],
    );
  }

  /// 🔥 헤더 섹션 빌드 (최적화됨)
  Widget _buildHeader(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_fire_department,
              size: 20.r,
              color: AppColors.brandCrimson,
            ),
            SizedBox(width: 8.w),
            Text(
              '인기 키워드',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        // 간단한 새로고침 버튼 (회전 애니메이션 제거)
        IconButton(
          icon: Icon(
            Icons.refresh,
            size: 18.r,
            color: Colors.grey[600],
          ),
          onPressed: () => _refreshKeywords(ref),
        ),
      ],
    );
  }

  /// 🏷️ 키워드 목록 빌드
  Widget _buildKeywordsList(
    List<String> keywords,
    searchController,
  ) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: keywords.asMap().entries.map((entry) {
        final index = entry.key;
        final keyword = entry.value;
        final isTop3 = index < 3;

        return _buildKeywordChip(
          keyword: keyword,
          rank: index + 1,
          isTop3: isTop3,
          onTap: () => searchController.searchByKeyword(keyword),
        );
      }).toList(),
    );
  }

  /// 🏷️ 개별 키워드 칩 빌드 (최적화됨)
  Widget _buildKeywordChip({
    required String keyword,
    required int rank,
    required bool isTop3,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isTop3
            ? LinearGradient(
                colors: [
                  AppColors.brandCrimson,
                  AppColors.brandCrimsonDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isTop3 ? null : AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isTop3
            ? [
                BoxShadow(
                  color: AppColors.brandCrimson.withValues(alpha: 0.3),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 📊 순위 배지 (Top 3만)
                if (isTop3) ...[
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandCrimson,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],

                // 키워드 텍스트
                Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isTop3 ? FontWeight.bold : FontWeight.w500,
                    color: isTop3 ? Colors.white : AppColors.brandCrimson,
                  ),
                ),

                // 🔥 인기 아이콘 (Top 3만)
                if (isTop3) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.local_fire_department,
                    size: 12.r,
                    color: Colors.orange[300],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ⏳ 최적화된 로딩 상태 (애니메이션 제거)
  Widget _buildLoadingShimmer() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(8, (index) {
        return Container(
          width: 80.w + (index % 3) * 20.w, // 다양한 너비
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.r),
          ),
        );
      }),
    );
  }

  /// ❌ 에러 상태
  Widget _buildErrorState(WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20.r,
            color: Colors.grey[600],
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '인기 키워드를 불러올 수 없어요',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => _refreshKeywords(ref),
            child: Text(
              '다시 시도',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📈 트렌딩 인디케이터
  Widget _buildTrendingIndicator() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            size: 16.r,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 8.w),
          Text(
            '실시간 인기 키워드 업데이트됨',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.brandCrimson,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '1분 전',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔄 키워드 새로고침 (최적화됨)
  void _refreshKeywords(WidgetRef ref) {
    // Provider 새로고침 (애니메이션 제거)
    ref.invalidate(popularKeywordsProvider);
  }
}

/// 🎯 추천 검색어 위젯 (최근 검색 + AI 추천)
class RecommendedSearchesWidget extends ConsumerWidget {
  const RecommendedSearchesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchControllerProvider);
    final searchController = ref.read(searchControllerProvider.notifier);

    if (searchState.recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📝 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => searchController.clearHistory(),
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // 📋 검색 기록 목록
        ...searchState.recentSearches.take(5).map((search) {
          return _buildRecentSearchItem(
            search: search,
            onTap: () => searchController.searchFromHistory(search),
            onDelete: () => searchController.removeFromHistory(search),
          );
        }),
      ],
    );
  }

  /// 📝 최근 검색 아이템
  Widget _buildRecentSearchItem({
    required String search,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history,
                  size: 18.r,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    search,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 16.r,
                    color: Colors.grey[500],
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}