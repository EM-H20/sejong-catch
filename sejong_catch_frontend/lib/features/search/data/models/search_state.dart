/// 🔍 검색 상태 모델 (Freezed 없이 일반 Dart 클래스)
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 사용 금지 - 일반 Dart 클래스로 구현
/// ✅ copyWith 메서드 수동 구현
/// ✅ 불변성 보장을 위한 final 필드
class SearchState {
  /// 현재 검색어
  final String query;

  /// 로딩 상태
  final bool isLoading;

  /// 에러 메시지
  final String? error;

  /// 검색 결과 목록
  final List<SearchResult> results;

  /// 인기 키워드 목록
  final List<String> popularKeywords;

  /// 최근 검색 기록
  final List<String> recentSearches;

  /// 선택된 필터
  final SearchFilter filter;

  /// 검색 결과가 더 있는지 여부 (무한 스크롤용)
  final bool hasMore;

  /// 현재 페이지 번호
  final int currentPage;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.error,
    this.results = const [],
    this.popularKeywords = const [],
    this.recentSearches = const [],
    this.filter = const SearchFilter(),
    this.hasMore = true,
    this.currentPage = 1,
  });

  /// copyWith 메서드 수동 구현 (Freezed 없이!)
  SearchState copyWith({
    String? query,
    bool? isLoading,
    String? error,
    List<SearchResult>? results,
    List<String>? popularKeywords,
    List<String>? recentSearches,
    SearchFilter? filter,
    bool? hasMore,
    int? currentPage,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      error: error, // null을 허용하여 에러 초기화 가능
      results: results ?? this.results,
      popularKeywords: popularKeywords ?? this.popularKeywords,
      recentSearches: recentSearches ?? this.recentSearches,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  /// 에러 상태 초기화용 편의 메서드
  SearchState clearError() {
    return copyWith(error: null);
  }

  /// 로딩 시작
  SearchState setLoading(bool loading) {
    return copyWith(isLoading: loading, error: null);
  }

  /// 검색어 업데이트
  SearchState updateQuery(String newQuery) {
    return copyWith(query: newQuery, error: null);
  }

  @override
  String toString() {
    return 'SearchState(query: $query, isLoading: $isLoading, error: $error, '
        'results: ${results.length} items, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchState &&
        other.query == query &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.results == results &&
        other.popularKeywords == popularKeywords &&
        other.recentSearches == recentSearches &&
        other.filter == filter &&
        other.hasMore == hasMore &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode {
    return query.hashCode ^
        isLoading.hashCode ^
        error.hashCode ^
        results.hashCode ^
        popularKeywords.hashCode ^
        recentSearches.hashCode ^
        filter.hashCode ^
        hasMore.hashCode ^
        currentPage.hashCode;
  }
}

/// 🎯 검색 필터 모델
class SearchFilter {
  /// 선택된 카테고리들
  final List<SearchCategory> categories;

  /// 마감일 필터
  final DeadlineFilter? deadlineFilter;

  /// 신뢰도 필터
  final TrustLevel? trustLevel;

  /// 정렬 방식
  final SortType sortType;

  const SearchFilter({
    this.categories = const [],
    this.deadlineFilter,
    this.trustLevel,
    this.sortType = SortType.relevance,
  });

  SearchFilter copyWith({
    List<SearchCategory>? categories,
    DeadlineFilter? deadlineFilter,
    TrustLevel? trustLevel,
    SortType? sortType,
  }) {
    return SearchFilter(
      categories: categories ?? this.categories,
      deadlineFilter: deadlineFilter ?? this.deadlineFilter,
      trustLevel: trustLevel ?? this.trustLevel,
      sortType: sortType ?? this.sortType,
    );
  }

  /// 필터가 활성화되어 있는지 확인
  bool get isActive {
    return categories.isNotEmpty ||
        deadlineFilter != null ||
        trustLevel != null ||
        sortType != SortType.relevance;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchFilter &&
        other.categories == categories &&
        other.deadlineFilter == deadlineFilter &&
        other.trustLevel == trustLevel &&
        other.sortType == sortType;
  }

  @override
  int get hashCode {
    return categories.hashCode ^
        deadlineFilter.hashCode ^
        trustLevel.hashCode ^
        sortType.hashCode;
  }
}

/// 📋 검색 카테고리
enum SearchCategory {
  competition, // 공모전
  job,         // 취업
  paper,       // 논문
  notice,      // 공지사항
}

/// ⏰ 마감일 필터
enum DeadlineFilter {
  week,    // 1주일 이내
  month,   // 1개월 이내
  none,    // 마감 없음
}

/// 🛡️ 신뢰도 레벨
enum TrustLevel {
  official,   // 공식
  academic,   // 학술
  press,      // 언론
  community,  // 커뮤니티
}

/// 📊 정렬 방식
enum SortType {
  relevance,  // 관련도순
  deadline,   // 마감일순
  latest,     // 최신순
  popular,    // 인기순
}

/// 🔍 검색 결과 아이템
class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final DateTime? deadline;
  final TrustLevel trustLevel;
  final SearchCategory category;
  final bool isBookmarked;
  final String? description;

  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.deadline,
    required this.trustLevel,
    required this.category,
    this.isBookmarked = false,
    this.description,
  });

  SearchResult copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    DateTime? deadline,
    TrustLevel? trustLevel,
    SearchCategory? category,
    bool? isBookmarked,
    String? description,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      deadline: deadline ?? this.deadline,
      trustLevel: trustLevel ?? this.trustLevel,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchResult &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imageUrl == imageUrl &&
        other.deadline == deadline &&
        other.trustLevel == trustLevel &&
        other.category == category &&
        other.isBookmarked == isBookmarked &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        imageUrl.hashCode ^
        deadline.hashCode ^
        trustLevel.hashCode ^
        category.hashCode ^
        isBookmarked.hashCode ^
        description.hashCode;
  }
}