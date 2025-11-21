import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/search_state.dart';

part 'search_controller.g.dart';

/// 🔍 검색 컨트롤러
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod로 상태 관리
/// ✅ state.copyWith()로 불변 업데이트
/// ✅ 검색, 필터 로직 중앙화
@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() => const SearchState();

  /// 검색어 업데이트
  void updateQuery(String query) {
    state = state.copyWith(
      query: query,
      isSearching: query.isNotEmpty,
    );

    if (query.isNotEmpty) {
      // 임시 검색 로직 (향후 API 연동)
      state = state.copyWith(
        searchResults: [
          '🔥 AI 해커톤 대회 - $query 관련',
          '📌 $query 취업 박람회',
          '🎓 $query 관련 논문 공모',
        ],
      );
    } else {
      state = state.copyWith(searchResults: []);
    }
  }

  /// 검색 실행
  void performSearch(String query) {
    if (query.isEmpty) return;

    state = state.copyWith(
      query: query,
      isSearching: true,
      searchResults: [
        '$query 관련 공모전',
        '$query 취업 정보',
        '$query 연구 기회',
      ],
    );
  }

  /// 검색 초기화
  void clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
      searchResults: [],
    );
  }

  /// 키워드 선택
  void selectKeyword(String keyword) {
    state = state.copyWith(
      query: keyword,
      isSearching: true,
      searchResults: [
        '$keyword 관련 공모전 정보',
        '$keyword 취업 기회',
        '$keyword 연구 프로젝트',
      ],
    );
  }

  /// 카테고리 필터 변경
  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// 신뢰도 필터 변경
  void updateTrust(String trust) {
    state = state.copyWith(selectedTrust: trust);
  }

  /// 마감일 범위 필터 변경
  void updateDeadlineRange(RangeValues range) {
    state = state.copyWith(deadlineRange: range);
  }

  /// 필터 적용
  void applyFilter() {
    // 향후 API 연동 시 필터 파라미터로 검색 요청
    // 현재는 상태만 업데이트
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
