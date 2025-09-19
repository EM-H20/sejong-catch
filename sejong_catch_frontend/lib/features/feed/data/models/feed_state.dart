import 'feed_category.dart';
import 'feed_item.dart';

/// 🧠 피드 상태 관리 모델
///
/// Freezed 없이 일반 Dart 클래스로 완벽한 불변성과 타입 안전성 보장!
/// login_page.dart의 86% 코드 감소 성공 패턴을 그대로 적용!
class FeedState {
  /// 로딩 상태 (초기 로드)
  final bool isLoading;

  /// 새로고침 상태 (Pull-to-refresh)
  final bool isRefreshing;

  /// 무한 스크롤 로딩 상태
  final bool isLoadingMore;

  /// 더 불러올 데이터가 있는지 여부
  final bool hasMore;

  /// 에러 메시지
  final String? error;

  /// 피드 아이템 리스트
  final List<FeedItem> items;

  /// 선택된 카테고리
  final FeedCategory selectedCategory;

  /// 읽은 아이템 ID 세트 (개인화!)
  final Set<String> readItems;

  /// 북마크한 아이템 ID 세트
  final Set<String> bookmarkedItems;

  /// 검색어 (향후 확장용)
  final String searchQuery;

  /// 필터 적용 여부
  final bool isFilterActive;

  /// 현재 페이지 (무한 스크롤용)
  final int currentPage;

  /// 마지막 업데이트 시간
  final DateTime? lastUpdated;

  /// 사용자 맞춤 추천 여부
  final bool isPersonalized;

  const FeedState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.items = const [],
    this.selectedCategory = FeedCategory.all,
    this.readItems = const {},
    this.bookmarkedItems = const {},
    this.searchQuery = '',
    this.isFilterActive = false,
    this.currentPage = 1,
    this.lastUpdated,
    this.isPersonalized = false,
  });

  /// copyWith 메서드 - Freezed 없이 완벽한 불변성!
  /// 컴파일 타임 안전성 + 자동 리빌드 보장!
  FeedState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    List<FeedItem>? items,
    FeedCategory? selectedCategory,
    Set<String>? readItems,
    Set<String>? bookmarkedItems,
    String? searchQuery,
    bool? isFilterActive,
    int? currentPage,
    DateTime? lastUpdated,
    bool? isPersonalized,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error, // null을 허용하여 에러 클리어 가능
      items: items ?? this.items,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      readItems: readItems ?? this.readItems,
      bookmarkedItems: bookmarkedItems ?? this.bookmarkedItems,
      searchQuery: searchQuery ?? this.searchQuery,
      isFilterActive: isFilterActive ?? this.isFilterActive,
      currentPage: currentPage ?? this.currentPage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isPersonalized: isPersonalized ?? this.isPersonalized,
    );
  }

  /// 빈 상태인지 확인
  bool get isEmpty => !isLoading && items.isEmpty && error == null;

  /// 에러 상태인지 확인
  bool get hasError => error != null;

  /// 초기 로딩 상태인지 확인
  bool get isInitialLoading => isLoading && items.isEmpty;

  /// 카테고리 필터링된 아이템들
  List<FeedItem> get filteredItems {
    if (selectedCategory == FeedCategory.all) {
      return items;
    }

    return items
        .where((item) => item.category == selectedCategory.value)
        .toList();
  }

  /// 읽지 않은 아이템들
  List<FeedItem> get unreadItems {
    return items.where((item) => !readItems.contains(item.id)).toList();
  }

  /// 북마크한 아이템들
  List<FeedItem> get bookmarkedItemsList {
    return items.where((item) => bookmarkedItems.contains(item.id)).toList();
  }

  /// 마감 임박 아이템들 (D-3 이하)
  List<FeedItem> get urgentItems {
    return items.where((item) => item.isDeadlineUrgent).toList();
  }

  /// 새로운 아이템들 (24시간 이내)
  List<FeedItem> get newItems {
    return items.where((item) => item.isNew).toList();
  }

  /// 인기 아이템들
  List<FeedItem> get popularItems {
    return items.where((item) => item.isPopular).toList();
  }

  /// 사용자에게 표시할 성공 메시지 생성
  String? get successMessage {
    if (isRefreshing) return null;

    if (lastUpdated != null) {
      final newItemsCount = newItems.length;
      final urgentItemsCount = urgentItems.length;

      if (newItemsCount > 0 && urgentItemsCount > 0) {
        return '새로운 정보 $newItemsCount개와 마감임박 정보 $urgentItemsCount개를 불러왔어요! ✨';
      } else if (newItemsCount > 0) {
        return '새로운 정보 $newItemsCount개를 불러왔어요! 🎯';
      } else if (urgentItemsCount > 0) {
        return '마감임박 정보 $urgentItemsCount개가 있어요! ⏰';
      } else {
        return '최신 정보로 업데이트했어요! 📱';
      }
    }

    return null;
  }

  /// 사용자에게 표시할 빈 상태 메시지
  String get emptyMessage {
    if (selectedCategory != FeedCategory.all) {
      return '${selectedCategory.displayName} 카테고리에 새로운 정보가 없어요.\n다른 카테고리도 확인해보세요! 🔍';
    }

    if (searchQuery.isNotEmpty) {
      return '"$searchQuery" 검색 결과가 없어요.\n다른 키워드로 검색해보세요! 💡';
    }

    return '아직 새로운 정보가 없어요.\n곧 세종대생을 위한 정보들이 올라올 거예요! 🌟';
  }

  /// 카테고리별 아이템 수 계산
  Map<FeedCategory, int> get categoryItemCounts {
    final counts = <FeedCategory, int>{};

    for (final category in FeedCategory.values) {
      if (category == FeedCategory.all) {
        counts[category] = items.length;
      } else {
        counts[category] = items
            .where((item) => item.category == category.value)
            .length;
      }
    }

    return counts;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedState &&
        other.isLoading == isLoading &&
        other.isRefreshing == isRefreshing &&
        other.isLoadingMore == isLoadingMore &&
        other.hasMore == hasMore &&
        other.error == error &&
        other.items == items &&
        other.selectedCategory == selectedCategory &&
        other.readItems == readItems &&
        other.bookmarkedItems == bookmarkedItems &&
        other.searchQuery == searchQuery &&
        other.isFilterActive == isFilterActive &&
        other.currentPage == currentPage &&
        other.lastUpdated == lastUpdated &&
        other.isPersonalized == isPersonalized;
  }

  @override
  int get hashCode {
    return Object.hash(
      isLoading,
      isRefreshing,
      isLoadingMore,
      hasMore,
      error,
      items,
      selectedCategory,
      readItems,
      bookmarkedItems,
      searchQuery,
      isFilterActive,
      currentPage,
      lastUpdated,
      isPersonalized,
    );
  }

  @override
  String toString() {
    return 'FeedState('
        'isLoading: $isLoading, '
        'items: ${items.length}, '
        'category: $selectedCategory, '
        'error: $error'
        ')';
  }
}