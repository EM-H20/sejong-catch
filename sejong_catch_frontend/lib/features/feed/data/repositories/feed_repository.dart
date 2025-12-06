import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/services/cache_service.dart';
import '../datasources/feed_api.dart';
import '../models/response/feed_item.dart';
import '../models/response/crawler_result.dart';
import '../../presentation/controllers/feed_sort_controller.dart';

part 'feed_repository.g.dart';

/// FeedApi Provider
@riverpod
FeedApi feedApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return FeedApi(dio);
}

/// 피드 Repository
///
/// **2가지 모드 자동 전환**:
/// - **Mock 모드** (개발): `USE_MOCK_AUTH=true` → 하드코딩 더미 5개
/// - **Real 모드** (프로덕션): `USE_MOCK_AUTH=false` → /crawler/crawl-results (1,000개 + 10분 캐싱)
@riverpod
class FeedRepository extends _$FeedRepository {
  @override
  void build() {}

  /// 피드 목록 조회
  ///
  /// **동작**:
  /// - Mock 모드: 하드코딩된 더미 데이터 반환 (5개)
  /// - Real 모드: 크롤러 API `/crawler/crawl-results` 호출 (1,000개 전체 로딩 + 10분 캐싱 + 로컬 필터링)
  Future<List<FeedItem>> getFeedList({
    String? category,
    FeedSortType sortType = FeedSortType.latest,
    int page = 1,
    int limit = 20,
  }) async {
    if (EnvConfig.useMockAuth) {
      // Mock 모드 (개발)
      return _mockFeedList(
        category: category,
        sortType: sortType,
        page: page,
        limit: limit,
      );
    } else {
      // Real 모드 (프로덕션) → /crawler/crawl-results 사용
      return _crawlerFeedList(
        category: category,
        sortType: sortType,
        page: page,
        limit: limit,
      );
    }
  }

  /// Mock 피드 목록 (개발 전용)
  Future<List<FeedItem>> _mockFeedList({
    String? category,
    FeedSortType sortType = FeedSortType.latest,
    int page = 1,
    int limit = 20,
  }) async {
    // 네트워크 지연 시뮬레이션 (500ms)
    await Future.delayed(const Duration(milliseconds: 500));

    // 더미 피드 데이터
    final allItems = [
      FeedItem(
        id: '1',
        title: '2024 캡스톤 디자인 경진대회',
        description: '우수작 선정 시 상금 300만원 + 창업 지원',
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
        title: '네이버 클라우드 신입 채용',
        description: '백엔드 개발자 채용 (~25.12.31)',
        category: '취업',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 23,
        viewCount: 567,
        priority: 'mid',
        isBookmarked: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      FeedItem(
        id: '3',
        title: '한국정보과학회 논문 공모',
        description: 'AI/빅데이터 분야 우수 논문 모집',
        category: '논문',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 15,
        viewCount: 892,
        priority: 'mid',
        isBookmarked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      FeedItem(
        id: '4',
        title: '[학교공지] 2025-1학기 수강신청 안내',
        description: '수강신청 기간: 2025.02.10 ~ 02.14',
        category: '학교공지',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 45,
        viewCount: 3421,
        priority: 'high',
        isBookmarked: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      FeedItem(
        id: '5',
        title: '세종대 대동제 부스 모집',
        description: '대동제 축제 부스 운영 팀 모집 중!',
        category: '축제',
        thumbnailUrl: 'https://via.placeholder.com/150',
        dDay: 30,
        viewCount: 1876,
        priority: 'low',
        isBookmarked: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    // 카테고리 필터링
    List<FeedItem> filteredItems = allItems;
    if (category != null && category != '전체') {
      filteredItems = allItems
          .where((item) => item.category == category)
          .toList();
    }

    // 정렬 적용
    final sortedItems = _sortFeedItems(filteredItems, sortType);

    return sortedItems;
  }

  /// 크롤러 API 피드 목록 (Real 모드 - 프로덕션)
  ///
  /// **전략**: 전체 데이터 1회 로딩 + 10분 캐싱 + 로컬 필터링
  /// **성능**: 캐시 적중 시 즉시 반환 (0 네트워크 요청)
  Future<List<FeedItem>> _crawlerFeedList({
    String? category,
    FeedSortType sortType = FeedSortType.latest,
    int page = 1,
    int limit = 20,
  }) async {
    // 1. 캐시 확인
    final cacheService = ref.read(cacheServiceProvider.notifier);
    final cachedData = await cacheService.getCrawlerCache();

    List<CrawlerResult> crawlerResults;

    if (cachedData != null) {
      // 캐시 적중 (10분 이내)
      crawlerResults = cachedData.data;
    } else {
      // 캐시 없음 또는 만료 → API 호출
      final api = ref.read(feedApiProvider);
      final response = await api.getCrawlerResults();
      crawlerResults = response.data;

      // 캐시 저장 (10분 TTL)
      await cacheService.setCrawlerCache(crawlerResults);
    }

    // 2. CrawlerResult → FeedItem 변환
    final feedItems = crawlerResults.map((crawlerItem) {
      return FeedItem(
        id: crawlerItem.id,
        title: crawlerItem.title,
        description: '', // 크롤러 데이터에는 description 없음
        category: CrawlerCategory.toDisplayName(crawlerItem.category),
        thumbnailUrl: null, // 크롤러 데이터에는 썸네일 없음
        dDay: _calculateDDay(crawlerItem.publishedAt),
        viewCount: crawlerItem.views,
        priority: 'low', // 기본값 (크롤러 데이터에는 우선순위 없음)
        isBookmarked: false,
        createdAt: crawlerItem.publishedAt,
        externalUrl: crawlerItem.url, // 세종대 공지 원문 URL
      );
    }).toList();

    // 3. 카테고리 필터링 (로컬)
    List<FeedItem> filteredItems = feedItems;
    if (category != null && category != '전체') {
      filteredItems = feedItems
          .where((item) => item.category == category)
          .toList();
    }

    // 4. 정렬 적용 (로컬)
    final sortedItems = _sortFeedItems(filteredItems, sortType);

    // 5. 페이지네이션 적용 (로컬)
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= sortedItems.length) {
      return []; // 범위 초과 시 빈 리스트
    }

    final paginatedItems = sortedItems.sublist(
      startIndex,
      endIndex > sortedItems.length ? sortedItems.length : endIndex,
    );

    return paginatedItems;
  }

  /// 피드 아이템 정렬 헬퍼
  ///
  /// **지원 정렬**:
  /// - 최신순: createdAt 내림차순 (최근 게시물 먼저)
  /// - 오래된순: createdAt 오름차순 (오래된 게시물 먼저)
  /// - 조회수 많은순: viewCount 내림차순 (인기 게시물 먼저)
  /// - 조회수 적은순: viewCount 오름차순 (조회수 적은 게시물 먼저)
  List<FeedItem> _sortFeedItems(List<FeedItem> items, FeedSortType sortType) {
    final itemsCopy = List<FeedItem>.from(items);

    switch (sortType) {
      case FeedSortType.latest:
        // 최신순: 최근 게시물 먼저 (createdAt 내림차순)
        itemsCopy.sort(
          (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
            a.createdAt ?? DateTime(0),
          ),
        );
        break;

      case FeedSortType.oldest:
        // 오래된순: 오래된 게시물 먼저 (createdAt 오름차순)
        itemsCopy.sort(
          (a, b) => (a.createdAt ?? DateTime(0)).compareTo(
            b.createdAt ?? DateTime(0),
          ),
        );
        break;

      case FeedSortType.mostViewed:
        // 조회수 많은순: 인기 게시물 먼저 (viewCount 내림차순)
        itemsCopy.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;

      case FeedSortType.leastViewed:
        // 조회수 적은순: 조회수 적은 게시물 먼저 (viewCount 오름차순)
        itemsCopy.sort((a, b) => a.viewCount.compareTo(b.viewCount));
        break;
    }

    return itemsCopy;
  }

  /// 캐시 강제 갱신
  ///
  /// **사용**: Pull-to-Refresh 시 호출
  Future<void> refreshCache() async {
    final cacheService = ref.read(cacheServiceProvider.notifier);
    await cacheService.clearCrawlerCache();
  }

  /// 게시 경과일 계산 헬퍼 (publishedAt 기준)
  ///
  /// **로직**: 게시된 날짜로부터 경과한 일수 (양수)
  /// **예시**: 2일 전 게시 → 2, 오늘 게시 → 0, 1주일 전 → 7
  int _calculateDDay(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt).inDays;
    return difference; // 양수: 게시 경과일
  }

  /// 피드 상세 조회
  Future<FeedItem> getFeedDetail(String id) async {
    if (EnvConfig.useMockAuth) {
      return _mockFeedDetail(id);
    } else {
      return _realFeedDetail(id);
    }
  }

  /// Mock 피드 상세 (개발 전용)
  Future<FeedItem> _mockFeedDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock 상세 데이터 (ID에 맞는 아이템 반환)
    return FeedItem(
      id: id,
      title: '2024 캡스톤 디자인 경진대회',
      description: '우수작 선정 시 상금 300만원 + 창업 지원\n\n상세 내용...',
      category: '공모전',
      thumbnailUrl: 'https://via.placeholder.com/150',
      dDay: 7,
      viewCount: 1234,
      priority: 'high',
      isBookmarked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    );
  }

  /// 실제 API 피드 상세 (프로덕션)
  ///
  /// **전략**: 캐시된 크롤러 데이터에서 ID로 검색 (API 호출 없음)
  /// **이유**: GET /feed/{id} API가 아직 구현 안 됨
  Future<FeedItem> _realFeedDetail(String id) async {
    // 1. 캐시된 크롤러 데이터 가져오기
    final cacheService = ref.read(cacheServiceProvider.notifier);
    final cachedData = await cacheService.getCrawlerCache();

    List<CrawlerResult> crawlerResults;

    if (cachedData != null) {
      // 캐시 적중
      crawlerResults = cachedData.data;
    } else {
      // 캐시 없음 → API 호출해서 로드
      final api = ref.read(feedApiProvider);
      final response = await api.getCrawlerResults();
      crawlerResults = response.data;

      // 캐시 저장
      await cacheService.setCrawlerCache(crawlerResults);
    }

    // 2. ID로 검색
    final crawlerItem = crawlerResults.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('피드를 찾을 수 없어요 (ID: $id)'),
    );

    // 3. FeedItem으로 변환
    return FeedItem(
      id: crawlerItem.id,
      title: crawlerItem.title,
      description: '',
      category: CrawlerCategory.toDisplayName(crawlerItem.category),
      thumbnailUrl: null,
      dDay: _calculateDDay(crawlerItem.publishedAt),
      viewCount: crawlerItem.views,
      priority: 'low',
      isBookmarked: false,
      createdAt: crawlerItem.publishedAt,
      externalUrl: crawlerItem.url,
    );
  }

  /// 북마크 토글
  Future<void> toggleBookmark(String id) async {
    if (EnvConfig.useMockAuth) {
      await _mockToggleBookmark(id);
    } else {
      await _realToggleBookmark(id);
    }
  }

  /// Mock 북마크 토글 (개발 전용)
  Future<void> _mockToggleBookmark(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock에서는 실제로 상태 변경 안 함 (UI에서 낙관적 업데이트)
  }

  /// 실제 API 북마크 토글 (프로덕션)
  Future<void> _realToggleBookmark(String id) async {
    final api = ref.read(feedApiProvider);
    await api.toggleBookmark(id);
  }
}
