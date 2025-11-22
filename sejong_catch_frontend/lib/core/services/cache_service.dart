import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/feed/data/models/response/crawler_result.dart';

part 'cache_service.g.dart';

/// SharedPreferences Provider
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

/// 크롤러 캐시 모델
///
/// **용도**: 크롤러 데이터 + 타임스탬프를 함께 저장
class CrawlerCache {
  final List<CrawlerResult> data;
  final DateTime timestamp;

  const CrawlerCache({
    required this.data,
    required this.timestamp,
  });

  /// JSON으로 변환 (SharedPreferences 저장용)
  Map<String, dynamic> toJson() => {
        'data': data.map((item) => item.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
      };

  /// JSON에서 복원
  factory CrawlerCache.fromJson(Map<String, dynamic> json) {
    return CrawlerCache(
      data: (json['data'] as List<dynamic>)
          .map((item) => CrawlerResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// 캐시 서비스
///
/// **기능**:
/// - 크롤러 데이터를 SharedPreferences에 저장
/// - 10분 TTL (Time To Live) 적용
/// - TTL 만료 시 자동 무효화
@riverpod
class CacheService extends _$CacheService {
  static const String _crawlerCacheKey = 'crawler_feed_cache';
  static const Duration _cacheTTL = Duration(minutes: 10);

  @override
  void build() {}

  /// 크롤러 캐시 조회
  ///
  /// **반환**:
  /// - 캐시가 있고 유효한 경우: CrawlerCache 반환
  /// - 캐시가 없거나 TTL 만료된 경우: null 반환
  Future<CrawlerCache?> getCrawlerCache() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final jsonString = prefs.getString(_crawlerCacheKey);

      if (jsonString == null) {
        return null; // 캐시 없음
      }

      final cache = CrawlerCache.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );

      // TTL 체크
      final now = DateTime.now();
      final cacheAge = now.difference(cache.timestamp);

      if (cacheAge > _cacheTTL) {
        // TTL 만료 → 캐시 삭제
        await clearCrawlerCache();
        return null;
      }

      return cache;
    } catch (e) {
      // JSON 파싱 에러 등 → 캐시 무효화
      await clearCrawlerCache();
      return null;
    }
  }

  /// 크롤러 캐시 저장
  ///
  /// **동작**: 현재 시각을 타임스탬프로 저장 → 10분 TTL 자동 적용
  Future<void> setCrawlerCache(List<CrawlerResult> data) async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final cache = CrawlerCache(
        data: data,
        timestamp: DateTime.now(),
      );

      await prefs.setString(
        _crawlerCacheKey,
        jsonEncode(cache.toJson()),
      );
    } catch (e) {
      // 저장 실패 시 무시 (다음 요청 시 API 호출)
      return;
    }
  }

  /// 크롤러 캐시 삭제
  Future<void> clearCrawlerCache() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.remove(_crawlerCacheKey);
    } catch (e) {
      // 삭제 실패 시 무시
      return;
    }
  }

  /// 캐시 유효성 확인 (TTL 체크)
  ///
  /// **반환**: true = 유효, false = 만료
  Future<bool> isCacheValid() async {
    final cache = await getCrawlerCache();
    return cache != null;
  }

  /// 캐시 남은 시간 (초 단위)
  ///
  /// **반환**: 캐시가 없거나 만료된 경우 0, 있으면 남은 초
  Future<int> getCacheRemainingSeconds() async {
    final cache = await getCrawlerCache();
    if (cache == null) return 0;

    final now = DateTime.now();
    final cacheAge = now.difference(cache.timestamp);
    final remaining = _cacheTTL - cacheAge;

    return remaining.inSeconds > 0 ? remaining.inSeconds : 0;
  }
}
