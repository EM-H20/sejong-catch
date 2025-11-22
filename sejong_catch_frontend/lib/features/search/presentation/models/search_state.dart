import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../feed/data/models/response/feed_item.dart';

part 'search_state.freezed.dart';

/// 🔍 검색 페이지 상태 모델
///
/// CLAUDE.md 원칙:
/// ✅ @freezed로 불변 상태 관리
/// ✅ copyWith() 자동 생성
/// ✅ 모든 검색 관련 상태를 하나로 통합
/// ✅ Real 모드 크롤러 데이터에 맞춰 카테고리 필터만 지원
@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    /// 검색어
    @Default('') String query,

    /// 검색 중 여부
    @Default(false) bool isSearching,

    /// 검색 결과 목록 (FeedItem)
    @Default([]) List<FeedItem> searchResults,

    /// 최근 검색어
    @Default([]) List<String> recentSearches,

    /// 에러 메시지
    String? error,

    /// 선택된 카테고리 필터
    @Default('전체') String selectedCategory,

    /// 선택된 시간 범위 필터
    @Default('전체') String selectedTimeRange,

    /// 조회수 범위 필터 (프리셋 방식)
    @Default('전체') String selectedViewsRange,
  }) = _SearchState;
}
