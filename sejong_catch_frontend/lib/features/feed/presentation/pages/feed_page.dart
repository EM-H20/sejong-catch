import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/core/widgets/loading_widget.dart';
import 'package:sejong_catch_frontend/features/feed/data/models/response/feed_item.dart';
import 'package:sejong_catch_frontend/features/feed/data/repositories/feed_repository.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/controllers/selected_category_controller.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/widgets/ui/feed_category_filter.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/widgets/ui/feed_card.dart';

/// 📰 피드 페이지 - 공모전·취업·논문·공지·축제 통합 피드
///
/// **2가지 모드 자동 전환**:
/// - Mock 모드 (개발): `USE_MOCK_AUTH=true` → 더미 데이터 5개
/// - Real 모드 (프로덕션): `USE_MOCK_AUTH=false` → /crawler/crawl-results (1,000개 + 10분 캐싱)
///
/// CLAUDE.md 원칙:
/// ✅ Repository 패턴으로 데이터 분리
/// ✅ Riverpod AsyncValue로 로딩/에러 상태 처리
/// ✅ 공용 위젯 (LoadingWidget, ErrorWidget) 활용
/// ✅ AppColors, AppSpacing, AppDivider 디자인 토큰 사용
class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 카테고리 목록 (모드별 자동 전환)
    final categories = ref.watch(categoryListProvider);

    // 2. 선택된 카테고리
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              '세종 캐치',
              style: AppTextStyles.headingBold20,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 24.sp),
            color: AppColors.textSecondary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림 기능 준비 중! 🔔')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppSpacing.categoryFilterHeight),
          child: FeedCategoryFilter(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              ref.read(selectedCategoryProvider.notifier).select(category);
            },
          ),
        ),
      ),
      body: _buildFeedList(ref, selectedCategory),
    );
  }

  /// 📰 피드 리스트
  Widget _buildFeedList(
    WidgetRef ref,
    String selectedCategory,
  ) {
    return FutureBuilder<List<FeedItem>>(
      future: ref.read(feedRepositoryProvider.notifier).getFeedList(
        category: selectedCategory == '전체' ? null : selectedCategory,
        page: 1,
        limit: 100, // 첫 페이지는 많이 가져오기 (로컬 필터링용)
      ),
      builder: (context, snapshot) {
        // 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget(message: '피드를 불러오는 중...');
        }

        // 에러 발생
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
                AppSpacing.verticalSpaceLG,
                Text(
                  '데이터를 불러올 수 없어요',
                  style: AppTextStyles.headingSemiBold20,
                ),
                AppSpacing.verticalSpaceSM,
                Text(
                  snapshot.error.toString(),
                  style: AppTextStyles.bodyRegular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceLG,
                ElevatedButton(
                  onPressed: () {
                    // 새로고침
                    ref.invalidate(feedRepositoryProvider);
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        // 데이터 없음
        final feedItems = snapshot.data ?? [];
        if (feedItems.isEmpty) {
          return _buildEmptyState(selectedCategory);
        }

        // 피드 카드 리스트
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(feedRepositoryProvider.notifier).refreshCache();
            ref.invalidate(feedRepositoryProvider);
          },
          child: ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: feedItems.length,
            separatorBuilder: (context, index) => AppSpacing.verticalSpaceLG,
            itemBuilder: (context, index) {
              final item = feedItems[index];

              return FeedCard(
                item: {
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'category': item.category,
                  'thumbnailUrl': item.thumbnailUrl,
                  'dDay': item.dDay,
                  'viewCount': item.viewCount,
                  'priority': item.priority,
                },
                onTap: () {
                  ref.context.pushNamed(
                    'feed_detail',
                    pathParameters: {'id': item.id},
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// 📭 빈 상태
  Widget _buildEmptyState(String selectedCategory) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64.sp, color: AppColors.disabled),
          AppSpacing.verticalSpaceLG,
          Text(
            '$selectedCategory 정보가 없어요',
            style: AppTextStyles.headingSemiBold20,
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            '다른 카테고리를 확인해보세요',
            style: AppTextStyles.bodyRegular14,
          ),
        ],
      ),
    );
  }
}
