import 'package:freezed_annotation/freezed_annotation.dart';

/// 서버가 DateTime을 다양한 형식으로 반환하는 문제 해결용 변환기
///
/// 지원하는 형식:
/// 1. 정상: "2025-12-06T08:54:10.813Z" (ISO 8601 문자열)
/// 2. 비정상: {"val":"CURRENT_TIMESTAMP(3)"} (SQL 표현식 객체)
/// 3. null: 현재 시간으로 대체
class FlexibleDateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const FlexibleDateTimeConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json == null) {
      return DateTime.now();
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    if (json is Map) {
      // {"val": "CURRENT_TIMESTAMP(3)"} 형태 → 현재 시간으로 대체
      return DateTime.now();
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime object) => object.toIso8601String();
}

/// Nullable DateTime 변환기
///
/// DateTime?을 처리하며, null인 경우 null 반환
class NullableFlexibleDateTimeConverter
    implements JsonConverter<DateTime?, dynamic> {
  const NullableFlexibleDateTimeConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    if (json is Map) {
      // {"val": "CURRENT_TIMESTAMP(3)"} 형태 → 현재 시간으로 대체
      return DateTime.now();
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? object) => object?.toIso8601String();
}
