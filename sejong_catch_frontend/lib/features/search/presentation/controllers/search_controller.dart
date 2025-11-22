import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/search_history_service.dart';
import '../../data/repositories/search_repository.dart';
import '../models/search_state.dart';

part 'search_controller.g.dart';

/// 🔍 검색 컨트롤러
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod로 상태 관리
/// ✅ state.copyWith()로 불변 업데이트
/// ✅ 검색, 필터 로직 중앙화
/// ✅ async 검색 + 히스토리 연동
@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() {
    // 최근 검색어 로드
    _loadRecentSearches();
    return const SearchState();
  }

  /// 최근 검색어 로드
  Future<void> _loadRecentSearches() async {
    final historyService = ref.read(searchHistoryServiceProvider.notifier);
    final recentSearches = await historyService.getRecentSearches();
    state = state.copyWith(recentSearches: recentSearches);
  }

  /// 검색어 업데이트 (실시간 입력)
  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  /// 검색 실행 (async)
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    // 로딩 시작
    state = state.copyWith(
      query: query,
      isSearching: true,
      error: null,
    );

    try {
      // 1. Repository를 통한 검색
      final repository = ref.read(searchRepositoryProvider.notifier);
      final results = await repository.search(
        query: query,
        category: state.selectedCategory != '전체' ? state.selectedCategory : null,
      );

      // 2. 검색어 히스토리에 추가
      final historyService = ref.read(searchHistoryServiceProvider.notifier);
      await historyService.addSearch(query);

      // 3. 상태 업데이트
      final recentSearches = await historyService.getRecentSearches();
      state = state.copyWith(
        searchResults: results,
        recentSearches: recentSearches,
        isSearching: false,
        error: null,
      );
    } catch (e) {
      // 에러 처리
      state = state.copyWith(
        isSearching: false,
        error: '검색 중 오류가 발생했습니다: ${e.toString()}',
      );
    }
  }

  /// 검색 초기화
  void clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
      searchResults: [],
      error: null,
    );
  }

  /// 최근 검색어 선택
  Future<void> selectRecentSearch(String keyword) async {
    await performSearch(keyword);
  }

  /// 최근 검색어 삭제
  Future<void> removeRecentSearch(String keyword) async {
    final historyService = ref.read(searchHistoryServiceProvider.notifier);
    await historyService.removeSearch(keyword);

    final recentSearches = await historyService.getRecentSearches();
    state = state.copyWith(recentSearches: recentSearches);
  }

  /// 최근 검색어 전체 삭제
  Future<void> clearAllRecentSearches() async {
    final historyService = ref.read(searchHistoryServiceProvider.notifier);
    await historyService.clearAll();

    state = state.copyWith(recentSearches: []);
  }

  /// 카테고리 필터 변경
  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);

    // 검색어가 있으면 다시 검색
    if (state.query.isNotEmpty) {
      performSearch(state.query);
    }
  }

  /// 신뢰도 필터 변경
  void updateTrust(String trust) {
    state = state.copyWith(selectedTrust: trust);
  }

  /// 마감일 범위 필터 변경
  void updateDeadlineRange(RangeValues range) {
    state = state.copyWith(deadlineRange: range);
  }

  /// 필터 초기화
  void resetFilter() {
    state = state.copyWith(
      selectedCategory: '전체',
      selectedTrust: '전체',
      deadlineRange: const RangeValues(0, 30),
    );
  }
}
