import 'package:freezed_annotation/freezed_annotation.dart';

part 'crawler_result.freezed.dart';
part 'crawler_result.g.dart';

/// 크롤러 API 응답 모델
///
/// **백엔드 스펙**: GET /crawler/crawl-results
/// **사용 모드**: USE_CRAWLER=true 일 때만 사용
@freezed
class CrawlerResultsResponse with _$CrawlerResultsResponse {
  const factory CrawlerResultsResponse({
    required List<CrawlerResult> data,
  }) = _CrawlerResultsResponse;

  factory CrawlerResultsResponse.fromJson(Map<String, dynamic> json) =>
      _$CrawlerResultsResponseFromJson(json);
}

/// 크롤러 개별 공지사항 모델
///
/// **카테고리 매핑**:
/// - notice1: 일반공지
/// - notice2: 입학공지
/// - notice3: 학사공지
/// - notice4: 국제교류(KR)
/// - notice5: 국제교류(EN)
/// - notice6: 취업
/// - notice7: 장학
/// - notice8: 교내모집
/// - notice9: 법무감사
/// - notice10: 입찰공고
@freezed
class CrawlerResult with _$CrawlerResult {
  const factory CrawlerResult({
    required String id,
    required String noticeKey,
    required String articleNo,
    required String title,
    required String url,
    required String category,
    required int views,
    required DateTime publishedAt,
  }) = _CrawlerResult;

  factory CrawlerResult.fromJson(Map<String, dynamic> json) =>
      _$CrawlerResultFromJson(json);
}

/// 크롤러 카테고리 매핑 유틸리티
///
/// **용도**: 백엔드 카테고리 코드 ↔ UI 표시 이름 변환
class CrawlerCategory {
  /// 카테고리 매핑 테이블
  static const Map<String, String> categoryMap = {
    'notice1': '일반공지',
    'notice2': '입학공지',
    'notice3': '학사공지',
    'notice4': '국제교류(KR)',
    'notice5': '국제교류(EN)',
    'notice6': '취업',
    'notice7': '장학',
    'notice8': '교내모집',
    'notice9': '법무감사',
    'notice10': '입찰공고',
  };

  /// 백엔드 카테고리 → UI 표시용 한글 변환
  ///
  /// **예시**: `notice1` → `일반공지`
  static String toDisplayName(String category) {
    return categoryMap[category] ?? category;
  }

  /// UI 카테고리 → 백엔드 카테고리 변환
  ///
  /// **예시**: `일반공지` → `notice1`
  static String fromDisplayName(String displayName) {
    return categoryMap.entries
            .firstWhere(
              (entry) => entry.value == displayName,
              orElse: () => const MapEntry('notice1', '일반공지'),
            )
            .key;
  }

  /// 모든 카테고리 목록 (UI 필터용)
  ///
  /// **반환**: `['일반공지', '입학공지', ...]`
  static List<String> get allCategories => categoryMap.values.toList();

  /// 모든 카테고리 코드 목록 (백엔드 요청용)
  ///
  /// **반환**: `['notice1', 'notice2', ...]`
  static List<String> get allCategoryCodes => categoryMap.keys.toList();
}
