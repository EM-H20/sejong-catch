import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../datasources/feed_api.dart';
import '../models/response/feed_item.dart';

part 'feed_repository.g.dart';

/// FeedApi Provider
@riverpod
FeedApi feedApi(FeedApiRef ref) {
  final dio = ref.watch(dioProvider);
  return FeedApi(dio);
}

/// 피드 Repository
///
/// **Mock/Real 자동 전환**:
/// - `USE_MOCK_AUTH=true` (기본값) → Mock 데이터 반환
/// - `USE_MOCK_AUTH=false` → 실제 백엔드 API 호출
@riverpod
class FeedRepository extends _$FeedRepository {
  @override
  void build() {}

  /// 피드 목록 조회
  ///
  /// **동작**:
  /// - Mock 모드: 하드코딩된 더미 데이터 반환
  /// - Real 모드: 백엔드 API `/feed` 호출
  Future<List<FeedItem>> getFeedList({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
      return _mockFeedList(category: category, page: page, limit: limit);
    } else {
      return _realFeedList(category: category, page: page, limit: limit);
    }
  }

  /// Mock 피드 목록 (개발 전용)
  Future<List<FeedItem>> _mockFeedList({
    String? category,
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
      filteredItems = allItems.where((item) => item.category == category).toList();
    }

    return filteredItems;
  }

  /// 실제 API 피드 목록 (프로덕션)
  Future<List<FeedItem>> _realFeedList({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    final api = ref.read(feedApiProvider);
    return await api.getFeedList(
      category: category == '전체' ? null : category,
      page: page,
      limit: limit,
    );
  }

  /// 피드 상세 조회
  Future<FeedItem> getFeedDetail(String id) async {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
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
  Future<FeedItem> _realFeedDetail(String id) async {
    final api = ref.read(feedApiProvider);
    return await api.getFeedDetail(id);
  }

  /// 북마크 토글
  Future<void> toggleBookmark(String id) async {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
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
