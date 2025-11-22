import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_history_service.g.dart';

/// 🔍 검색 히스토리 서비스
///
/// **기능**:
/// - 최근 검색어 저장/조회/삭제
/// - 최대 10개 제한
/// - SharedPreferences 사용
@riverpod
class SearchHistoryService extends _$SearchHistoryService {
  static const String _key = 'search_history';
  static const int _maxHistory = 10;

  @override
  void build() {}

  /// 최근 검색어 목록 조회
  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// 검색어 추가
  Future<void> addSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];

    // 중복 제거
    history.remove(query);

    // 맨 앞에 추가
    history.insert(0, query);

    // 최대 개수 제한
    if (history.length > _maxHistory) {
      history.removeRange(_maxHistory, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  /// 검색어 삭제
  Future<void> removeSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_key) ?? [];
    history.remove(query);
    await prefs.setStringList(_key, history);
  }

  /// 전체 삭제
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
