import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/search_state.dart';

// 코드 생성을 위한 part 선언
part 'search_controller.g.dart';

/// 🔍 검색 컨트롤러 (Riverpod + Freezed 없이!)
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod 어노테이션으로 자동 생성
/// ✅ 모든 상태 관리 로직 중앙 집중
/// ✅ copyWith로 불변 상태 변경
/// ✅ 컴파일 타임 안전성 보장
@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() => const SearchState(
        popularKeywords: [
          '창업경진대회',
          '인턴십',
          '논문공모',
          '취업박람회',
          '해외연수',
          'AI 공모전',
          '창업지원',
          '학술대회',
        ],
        recentSearches: [
          'AI 공모전',
          '대학생 인턴',
          '졸업논문',
          '창업경진대회',
        ],
      );

  /// 🔍 검색어 실시간 업데이트
  void updateQuery(String query) {
    state = state.updateQuery(query);
  }

  /// 🚀 검색 실행
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    // 로딩 시작
    state = state.setLoading(true);

    try {
      // TODO: 실제 API 호출로 교체
      await _simulateApiCall();

      // 모의 검색 결과 생성
      final results = _generateMockResults(query);

      // 최근 검색 기록에 추가 (중복 제거)
      final updatedRecentSearches = [
        query,
        ...state.recentSearches.where((search) => search != query),
      ].take(10).toList(); // 최대 10개만 유지

      state = state.copyWith(
        query: query,
        results: results,
        recentSearches: updatedRecentSearches,
        isLoading: false,
        hasMore: results.length >= 10, // 10개 이상이면 더 있을 수 있음
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '검색 중 오류가 발생했어요. 다시 시도해주세요.',
      );
    }
  }

  /// 📄 더 많은 결과 로드 (무한 스크롤)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      await _simulateApiCall();

      final moreResults = _generateMockResults(
        state.query,
        page: state.currentPage + 1,
      );

      state = state.copyWith(
        results: [...state.results, ...moreResults],
        isLoading: false,
        hasMore: moreResults.isNotEmpty,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '추가 결과를 불러오는 중 오류가 발생했어요.',
      );
    }
  }

  /// 🏷️ 인기 키워드로 검색
  Future<void> searchByKeyword(String keyword) async {
    await search(keyword);
  }

  /// 📝 최근 검색 기록으로 검색
  Future<void> searchFromHistory(String query) async {
    await search(query);
  }

  /// 🗑️ 검색 기록 개별 삭제
  void removeFromHistory(String query) {
    final updatedHistory = state.recentSearches
        .where((search) => search != query)
        .toList();

    state = state.copyWith(recentSearches: updatedHistory);
  }

  /// 🗑️ 검색 기록 전체 삭제
  void clearHistory() {
    state = state.copyWith(recentSearches: []);
  }

  /// 🎛️ 필터 업데이트
  void updateFilter(SearchFilter filter) {
    state = state.copyWith(filter: filter);

    // 필터가 변경되면 자동으로 재검색
    if (state.query.isNotEmpty) {
      search(state.query);
    }
  }

  /// 🔖 북마크 토글
  void toggleBookmark(String itemId) {
    final updatedResults = state.results.map((result) {
      if (result.id == itemId) {
        return result.copyWith(isBookmarked: !result.isBookmarked);
      }
      return result;
    }).toList();

    state = state.copyWith(results: updatedResults);
  }

  /// ❌ 에러 상태 초기화
  void clearError() {
    state = state.clearError();
  }

  /// 🔄 새로고침
  Future<void> refresh() async {
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  // Private 헬퍼 메서드들

  /// API 호출 시뮬레이션 (실제로는 dio + retrofit 사용)
  Future<void> _simulateApiCall() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// 모의 검색 결과 생성 (실제로는 API에서 받아올 데이터)
  List<SearchResult> _generateMockResults(String query, {int page = 1}) {
    final baseResults = [
      SearchResult(
        id: 'comp_1_$page',
        title: '$query 관련 창업경진대회',
        subtitle: '마감: 2024-12-31 | 상금: 1,000만원',
        trustLevel: TrustLevel.official,
        category: SearchCategory.competition,
        deadline: DateTime.now().add(const Duration(days: 45)),
        description: '혁신적인 아이디어로 세상을 바꿔보세요!',
      ),
      SearchResult(
        id: 'job_1_$page',
        title: '$query 분야 인턴십 모집',
        subtitle: '세종대학교 산학협력단 | 6개월',
        trustLevel: TrustLevel.academic,
        category: SearchCategory.job,
        deadline: DateTime.now().add(const Duration(days: 30)),
        description: '실무 경험과 성장 기회를 제공합니다.',
      ),
      SearchResult(
        id: 'paper_1_$page',
        title: '$query 관련 논문 공모전',
        subtitle: '한국학술정보원 주최 | 우수상 500만원',
        trustLevel: TrustLevel.academic,
        category: SearchCategory.paper,
        deadline: DateTime.now().add(const Duration(days: 60)),
        description: '학술적 우수성을 인정받을 기회입니다.',
      ),
      SearchResult(
        id: 'notice_1_$page',
        title: '$query 관련 특강 안내',
        subtitle: '세종대학교 | 2024-11-15 14:00',
        trustLevel: TrustLevel.official,
        category: SearchCategory.notice,
        deadline: DateTime.now().add(const Duration(days: 15)),
        description: '전문가와 함께하는 특별 강연입니다.',
      ),
    ];

    // 페이지에 따라 다른 결과 반환
    if (page > 2) return []; // 3페이지부터는 결과 없음

    return baseResults.take(page == 1 ? 4 : 2).toList();
  }
}

/// 🔍 검색 제안어 Provider (자동완성용)
@riverpod
Future<List<String>> searchSuggestions(
  Ref ref,
  String query,
) async {
  if (query.length < 2) return [];

  // TODO: 실제 API 호출로 교체
  await Future.delayed(const Duration(milliseconds: 300));

  // 모의 제안어 생성
  final suggestions = [
    '$query 공모전',
    '$query 인턴십',
    '$query 채용',
    '$query 논문',
    '$query 특강',
  ].where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase())).toList();

  return suggestions.take(5).toList();
}

/// 📊 검색 통계 Provider (인기 키워드 업데이트용)
@riverpod
Future<List<String>> popularKeywords(Ref ref) async {
  // TODO: 실제 API 호출로 교체
  await Future.delayed(const Duration(milliseconds: 500));

  return [
    '창업경진대회',
    'AI 공모전',
    '인턴십',
    '논문공모',
    '취업박람회',
    '해외연수',
    '창업지원',
    '학술대회',
    '멘토링',
    '프로그래밍',
  ];
}