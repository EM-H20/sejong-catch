import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/cache_service.dart';
import '../../../feed/data/models/response/crawler_result.dart';
import '../../../feed/data/models/response/feed_item.dart';

part 'search_repository.g.dart';

/// 검색 Repository
///
/// **2가지 모드 자동 전환**:
/// - **Mock 모드** (개발): `USE_MOCK_AUTH=true` → 하드코딩 더미 검색 결과
/// - **Real 모드** (프로덕션): `USE_MOCK_AUTH=false` → 크롤러 캐시 데이터 검색
@riverpod
class SearchRepository extends _$SearchRepository {
  @override
  void build() {}

  /// 검색 실행
  ///
  /// **동작**:
  /// - Mock 모드: 하드코딩된 더미 검색 결과 반환
  /// - Real 모드: 캐시된 크롤러 데이터에서 검색 (title.contains() 로컬 필터링)
  Future<List<FeedItem>> search({
    required String query,
    String? category,
    String? timeRange,
    String? viewsRangePreset,
  }) async {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
      // Mock 모드 (개발)
      return _mockSearch(
        query: query,
        category: category,
        timeRange: timeRange,
        viewsRangePreset: viewsRangePreset,
      );
    } else {
      // Real 모드 (프로덕션) → 크롤러 캐시 데이터 검색
      return _realSearch(
        query: query,
        category: category,
        timeRange: timeRange,
        viewsRangePreset: viewsRangePreset,
      );
    }
  }

  /// Mock 검색 (개발 전용)
  Future<List<FeedItem>> _mockSearch({
    required String query,
    String? category,
    String? timeRange,
    String? viewsRangePreset,
  }) async {
    // 네트워크 지연 시뮬레이션 (300ms)
    await Future.delayed(const Duration(milliseconds: 300));

    // 더미 검색 결과
    final allResults = [
      FeedItem(
        id: '1',
        title: '$query 관련 공모전 대회',
        description: '우수작 선정 시 상금 300만원',
        category: '공모전',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 7,
        viewCount: 1234,
        priority: 'high',
        isBookmarked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      FeedItem(
        id: '2',
        title: '$query 분야 취업 박람회',
        description: '채용 설명회 및 현장 면접',
        category: '취업',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 14,
        viewCount: 567,
        priority: 'mid',
        isBookmarked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      FeedItem(
        id: '3',
        title: '$query 주제 논문 공모',
        description: 'AI/빅데이터 분야 우수 논문 모집',
        category: '논문',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 21,
        viewCount: 892,
        priority: 'mid',
        isBookmarked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // 카테고리 필터링
    if (category != null && category != '전체') {
      return allResults.where((item) => item.category == category).toList();
    }

    return allResults;
  }

  /// Real 검색 (프로덕션)
  ///
  /// **전략**: 캐시된 크롤러 데이터에서 title.contains() 로컬 검색
  /// **성능**: 캐시 적중 시 즉시 반환 (0 네트워크 요청)
  Future<List<FeedItem>> _realSearch({
    required String query,
    String? category,
    String? timeRange,
    String? viewsRangePreset,
  }) async {
    try {
      // 1. 캐시된 크롤러 데이터 조회
      final cacheService = ref.read(cacheServiceProvider.notifier);
      final crawlerCache = await cacheService.getCrawlerCache();

      if (crawlerCache == null || crawlerCache.data.isEmpty) {
        return [];
      }

      // 2. 검색어로 필터링 (title.contains() - 대소문자 무시)
      final lowerQuery = query.toLowerCase();
      List<CrawlerResult> filtered = crawlerCache.data.where((item) {
        return item.title.toLowerCase().contains(lowerQuery);
      }).toList();

      // 3. 카테고리 필터링
      if (category != null && category != '전체') {
        final categoryCode = CrawlerCategory.fromDisplayName(category);
        filtered = filtered
            .where((item) => item.category == categoryCode)
            .toList();
      }

      // 4. 시간 범위 필터링
      if (timeRange != null && timeRange != '전체') {
        final now = DateTime.now();
        DateTime cutoffDate;

        switch (timeRange) {
          case '최근 1주일':
            cutoffDate = now.subtract(const Duration(days: 7));
          case '최근 1개월':
            cutoffDate = now.subtract(const Duration(days: 30));
          case '최근 3개월':
            cutoffDate = now.subtract(const Duration(days: 90));
          case '최근 6개월':
            cutoffDate = now.subtract(const Duration(days: 180));
          default:
            cutoffDate = DateTime(2000);
        }

        filtered = filtered
            .where((item) => item.publishedAt.isAfter(cutoffDate))
            .toList();
      }

      // 5. 조회수 범위 필터링 (프리셋 방식)
      if (viewsRangePreset != null && viewsRangePreset != '전체') {
        int minViews = 0;
        int maxViews = 999999;

        switch (viewsRangePreset) {
          case '1천 미만':
            minViews = 0;
            maxViews = 1000;
          case '1천~5천':
            minViews = 1000;
            maxViews = 5000;
          case '5천~1만':
            minViews = 5000;
            maxViews = 10000;
          case '1만 이상':
            minViews = 10000;
            maxViews = 999999;
        }

        filtered = filtered
            .where((item) => item.views >= minViews && item.views <= maxViews)
            .toList();
      }

      // 6. CrawlerResult → FeedItem 변환
      final feedItems = filtered.map((crawlerResult) {
        // publishedAt부터 현재까지 경과일 계산
        final now = DateTime.now();
        final publishedAt = crawlerResult.publishedAt;
        final daysPassed = now.difference(publishedAt).inDays;

        return FeedItem(
          id: crawlerResult.id,
          title: crawlerResult.title,
          description: '',
          category: CrawlerCategory.toDisplayName(crawlerResult.category),
          thumbnailUrl: null,
          dDay: daysPassed,
          viewCount: crawlerResult.views,
          priority: 'mid',
          isBookmarked: false,
          createdAt: crawlerResult.publishedAt,
          externalUrl: crawlerResult.url,
        );
      }).toList();

      // 5. 최신순 정렬
      feedItems.sort((a, b) =>
          (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));

      return feedItems;
    } catch (e) {
      // 에러 발생 시 빈 배열 반환
      return [];
    }
  }
}
