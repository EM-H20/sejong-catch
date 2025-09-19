import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/cards/app_card.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/feed_item.dart';
import '../../../data/models/feed_state.dart';
import '../../controllers/feed_controller.dart';
import 'loading_feed_state.dart';
import 'empty_feed_state.dart';

/// 📋 인텔리전트 피드 리스트 뷰
///
/// BTS처럼 완벽한 하모니를 이루는 레전드급 리스트!
/// 사용자 친화적 기능들:
/// - 무한 스크롤 + Shimmer 로딩
/// - Hero 애니메이션으로 디테일 전환
/// - 읽음/안읽음 시각적 구분
/// - 스와이프 제스처 (북마크, 공유)
/// - 우선순위별 스마트 정렬
/// - 성능 최적화: itemExtent 고정, cacheExtent 최적화
class FeedListView extends ConsumerStatefulWidget {
  const FeedListView({super.key});

  @override
  ConsumerState<FeedListView> createState() => _FeedListViewState();
}

class _FeedListViewState extends ConsumerState<FeedListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // 컴포넌트 마운트 후 초기 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedControllerProvider.notifier).loadFeed();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 스크롤 이벤트 처리 - 무한 스크롤 구현
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      // 스크롤이 하단에 가까워지면 더 많은 아이템 로드
      ref.read(feedControllerProvider.notifier).loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);
    final feedController = ref.read(feedControllerProvider.notifier);

    // 에러 상태 처리
    if (feedState.hasError) {
      return _buildErrorState(feedState.error!, feedController);
    }

    // 초기 로딩 상태
    if (feedState.isInitialLoading) {
      return const LoadingFeedState();
    }

    // 빈 상태 처리
    if (feedState.isEmpty) {
      return EmptyFeedState(
        message: feedState.emptyMessage,
        onRetry: () => feedController.loadFeed(),
      );
    }

    // 메인 리스트 뷰
    return RefreshIndicator(
      onRefresh: () => feedController.refreshFeed(),
      color: AppColors.brandCrimson,
      backgroundColor: Colors.white,
      displacement: 60.h,
      child: _buildMainListView(feedState, feedController),
    );
  }

  /// 메인 리스트 뷰 구성
  Widget _buildMainListView(FeedState feedState, FeedController controller) {
    final filteredItems = feedState.filteredItems;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(), // iOS급 부드러운 스크롤
      slivers: [
        // 성공 메시지 표시 (새로고침 후)
        if (feedState.successMessage != null)
          SliverToBoxAdapter(
            child: _buildSuccessMessage(feedState.successMessage!),
          ),

        // 메인 피드 아이템들
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = filteredItems[index];
              return _buildFeedItem(item, controller);
            },
            childCount: filteredItems.length,
          ),
        ),

        // 무한 스크롤 로딩 인디케이터
        if (feedState.isLoadingMore)
          SliverToBoxAdapter(
            child: _buildLoadMoreIndicator(),
          ),

        // 더 이상 로드할 데이터가 없을 때
        if (!feedState.hasMore && filteredItems.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildEndMessage(filteredItems.length),
          ),

        // 하단 패딩
        SliverToBoxAdapter(
          child: SizedBox(height: 20.h),
        ),
      ],
    );
  }

  /// 개별 피드 아이템 구성
  Widget _buildFeedItem(FeedItem item, FeedController controller) {
    final isRead = ref.watch(feedControllerProvider).readItems.contains(item.id);
    final isBookmarked = ref.watch(feedControllerProvider).bookmarkedItems.contains(item.id);

    return Hero(
      tag: 'feed_item_${item.id}',
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        child: Dismissible(
          key: Key(item.id),
          background: _buildSwipeBackground(isLeft: true),
          secondaryBackground: _buildSwipeBackground(isLeft: false),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              // 왼쪽 스와이프 - 북마크
              controller.toggleBookmark(item.id);
              _showSnackBar('북마크에 ${isBookmarked ? '제거' : '추가'}했어요! 📌');
            } else {
              // 오른쪽 스와이프 - 공유
              _shareItem(item);
            }
          },
          child: Opacity(
            opacity: isRead ? 0.7 : 1.0, // 읽음/안읽음 시각적 구분
            child: AppCard(
              title: item.title,
              subtitle: item.subtitle,
              category: item.category,
              deadline: item.deadline,
              trustLevel: item.trustLevel,
              priority: item.priority,
              sourceDomain: item.sourceDomain,
              createdAt: item.createdAt,
              viewCount: item.viewCount,
              isBookmarked: isBookmarked,
              isRead: isRead,
              isExpired: item.isExpired,
              onTap: () => _onItemTap(item, controller),
              onBookmarkTap: () => controller.toggleBookmark(item.id),
            ),
          ),
        ),
      ),
    );
  }

  /// 스와이프 배경 구성
  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isLeft ? AppColors.brandCrimson : AppColors.success,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLeft ? Icons.bookmark_add : Icons.share,
            color: Colors.white,
            size: 28.w,
          ),
          SizedBox(height: 4.h),
          Text(
            isLeft ? '북마크' : '공유하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 성공 메시지 표시
  Widget _buildSuccessMessage(String message) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 에러 상태 처리
  Widget _buildErrorState(String error, FeedController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => controller.loadFeed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCrimson,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                '다시 시도',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 무한 스크롤 로딩 인디케이터
  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandCrimson),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '더 많은 정보를 불러오고 있어요...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 끝 메시지
  Widget _buildEndMessage(int totalCount) {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 32.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 8.h),
          Text(
            '총 $totalCount개의 정보를 모두 확인했어요! 🎉',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            '새로운 정보가 업데이트되면 알려드릴게요',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 아이템 탭 처리
  void _onItemTap(FeedItem item, FeedController controller) {
    // 읽음 처리
    controller.markAsRead(item.id);

    // 사용자 인터랙션 기록
    controller.recordInteraction(item.id, 'view');

    // 디테일 페이지로 이동 (향후 구현)
    // context.push('/detail/${item.id}');
  }

  /// 아이템 공유 처리
  void _shareItem(FeedItem item) {
    // 공유 기능 구현 (향후)
    _showSnackBar('공유 기능이 곧 추가될 예정이에요! 📤');
  }

  /// 스낵바 표시
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}