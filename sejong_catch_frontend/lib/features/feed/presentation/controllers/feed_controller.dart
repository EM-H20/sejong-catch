import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/services.dart';

import '../../data/models/feed_category.dart';
import '../../data/models/feed_item.dart';
import '../../data/models/feed_state.dart';

part 'feed_controller.g.dart';

/// 🧠 피드 컨트롤러 - Riverpod Notifier 패턴
///
/// login_page.dart의 86% 코드 감소 성공 패턴을 그대로 적용!
/// 모든 피드 관련 상태 관리와 비즈니스 로직을 담당합니다.
@riverpod
class FeedController extends _$FeedController {
  @override
  FeedState build() {
    // 초기 상태 반환 - 순수한 초기화만!
    return const FeedState();
  }

  /// 🔄 피드 초기 로드
  Future<void> loadFeed() async {
    if (state.isLoading) return; // 중복 호출 방지

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 임시 더미 데이터 - 실제 API 연결 시 Repository 패턴 적용
      await Future.delayed(const Duration(seconds: 1));

      final dummyItems = _generateDummyData();

      state = state.copyWith(
        isLoading: false,
        items: dummyItems,
        lastUpdated: DateTime.now(),
        hasMore: true,
        currentPage: 1,
        isPersonalized: true, // 사용자 맞춤 추천 활성화
      );

      // 성공 햅틱 피드백
      HapticFeedback.lightImpact();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '정보를 불러오는 중 문제가 발생했어요. 잠시 후 다시 시도해주세요 🔄',
      );

      // 에러 햅틱 피드백
      HapticFeedback.heavyImpact();
    }
  }

  /// 🔃 피드 새로고침 (Pull-to-refresh)
  Future<void> refreshFeed() async {
    if (state.isRefreshing) return; // 중복 호출 방지

    state = state.copyWith(isRefreshing: true, error: null);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // 새로운 데이터 시뮬레이션 (실제로는 API 호출)
      final refreshedItems = _generateDummyData();

      state = state.copyWith(
        isRefreshing: false,
        items: refreshedItems,
        lastUpdated: DateTime.now(),
        currentPage: 1,
        hasMore: true,
      );

      // 성공 햅틱 피드백
      HapticFeedback.lightImpact();
    } catch (e) {
      state = state.copyWith(
        isRefreshing: false,
        error: '새로운 정보를 불러올 수 없어요. 인터넷 연결을 확인해주세요 📶',
      );
    }
  }

  /// 📄 더 많은 아이템 로드 (무한 스크롤)
  Future<void> loadMoreItems() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // 추가 데이터 시뮬레이션
      final moreItems = _generateDummyData(page: state.currentPage + 1);

      // 데이터가 없으면 더 이상 로드할 게 없음
      final hasMoreData = moreItems.isNotEmpty;

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...moreItems],
        currentPage: state.currentPage + 1,
        hasMore: hasMoreData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: '추가 정보를 불러올 수 없어요 📋',
      );
    }
  }

  /// 🏷️ 카테고리 변경
  void changeCategory(FeedCategory category) {
    if (state.selectedCategory == category) return;

    state = state.copyWith(
      selectedCategory: category,
      error: null, // 에러 상태 클리어
    );

    // 카테고리 변경 햅틱 피드백
    HapticFeedback.selectionClick();
  }

  /// 📖 아이템 읽음 처리
  void markAsRead(String itemId) {
    final updatedReadItems = {...state.readItems, itemId};

    state = state.copyWith(readItems: updatedReadItems);

    // 읽음 처리 햅틱 피드백 (미세한 진동)
    HapticFeedback.selectionClick();
  }

  /// 📌 북마크 토글
  void toggleBookmark(String itemId) {
    final isCurrentlyBookmarked = state.bookmarkedItems.contains(itemId);
    Set<String> updatedBookmarks;

    if (isCurrentlyBookmarked) {
      updatedBookmarks = state.bookmarkedItems.where((id) => id != itemId).toSet();
    } else {
      updatedBookmarks = {...state.bookmarkedItems, itemId};
    }

    state = state.copyWith(bookmarkedItems: updatedBookmarks);

    // 북마크 햅틱 피드백
    HapticFeedback.lightImpact();
  }

  /// 🔍 검색어 설정 (향후 확장용)
  void setSearchQuery(String query) {
    state = state.copyWith(
      searchQuery: query,
      isFilterActive: query.isNotEmpty,
    );
  }

  /// ❌ 에러 상태 클리어
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 🎯 사용자 맞춤 추천 토글
  void togglePersonalization() {
    state = state.copyWith(
      isPersonalized: !state.isPersonalized,
    );

    HapticFeedback.lightImpact();
  }

  /// 📊 더미 데이터 생성 (실제 앱에서는 Repository에서 API 호출)
  List<FeedItem> _generateDummyData({int page = 1}) {
    // 페이지당 10개씩, 3페이지까지만 데이터 제공
    if (page > 3) return [];

    final baseData = [
      FeedItem(
        id: 'contest_001_$page',
        title: '2024 세종대학교 창업 아이디어 경진대회',
        subtitle: '혁신적인 창업 아이디어로 미래를 설계해보세요. 우수상 수상자에게는 창업 지원금과 멘토링을 제공합니다.',
        category: 'contest',
        deadline: DateTime.now().add(const Duration(days: 15)),
        trustLevel: 'official',
        priority: 'high',
        sourceDomain: '세종대학교 공식',
        sourceUrl: 'https://sejong.ac.kr',
        createdAt: DateTime.now().subtract(Duration(hours: page * 2)),
        viewCount: 245 + (page * 30),
        bookmarkCount: 23 + page,
        recommendationScore: 0.95,
        tags: ['창업', '경진대회', '아이디어', '지원금'],
        relatedDepartments: ['전체학과'],
        badges: ['HOT', 'OFFICIAL'],
      ),
      FeedItem(
        id: 'job_001_$page',
        title: 'SK하이닉스 2024 하계 인턴십 모집',
        subtitle: '반도체 분야 최고 기업에서 실무 경험을 쌓을 기회입니다. 우수 인턴은 정규직 전환 가능합니다.',
        category: 'job',
        deadline: DateTime.now().add(const Duration(days: 7)),
        trustLevel: 'official',
        priority: 'high',
        sourceDomain: 'SK하이닉스 채용',
        sourceUrl: 'https://careers.skhynix.com',
        createdAt: DateTime.now().subtract(Duration(hours: page * 3)),
        viewCount: 432 + (page * 50),
        bookmarkCount: 67 + page,
        recommendationScore: 0.89,
        tags: ['인턴십', '반도체', 'SK하이닉스', '정규직전환'],
        relatedDepartments: ['컴퓨터공학과', '전자정보통신공학과'],
        badges: ['URGENT', 'RECOMMENDED'],
      ),
      FeedItem(
        id: 'paper_001_$page',
        title: '2024 AI 혁신 논문 공모전',
        subtitle: '인공지능 분야의 창의적 연구 아이디어를 공모합니다. 우수 논문은 해외 학회 발표 기회 제공.',
        category: 'paper',
        deadline: DateTime.now().add(const Duration(days: 30)),
        trustLevel: 'academic',
        priority: 'mid',
        sourceDomain: '한국AI학회',
        sourceUrl: 'https://kaia.kr',
        createdAt: DateTime.now().subtract(Duration(hours: page * 4)),
        viewCount: 156 + (page * 20),
        bookmarkCount: 34 + page,
        recommendationScore: 0.76,
        tags: ['AI', '논문', '학회', '연구'],
        relatedDepartments: ['컴퓨터공학과', '데이터사이언스학과'],
        badges: ['NEW'],
      ),
    ];

    return baseData;
  }

  /// 🎯 사용자 맞춤 추천 아이템 가져오기
  List<FeedItem> getRecommendedItems() {
    if (!state.isPersonalized) return state.items;

    // 추천 알고리즘 시뮬레이션
    return state.items
        .where((item) =>
            item.recommendationScore > 0.8 ||
            item.isDeadlineUrgent ||
            item.isNew)
        .toList()
      ..sort((a, b) => b.recommendationScore.compareTo(a.recommendationScore));
  }

  /// 📈 사용자 인터랙션 분석 (향후 추천 개선용)
  void recordInteraction(String itemId, String action) {
    // 실제 앱에서는 분석 서비스로 전송
    // 예: 'view', 'bookmark', 'share', 'click' 등
    // TODO: 분석 서비스 연동 (Firebase Analytics, Mixpanel 등)
  }
}