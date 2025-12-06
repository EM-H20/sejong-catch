import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/json_converters.dart';

part 'booth.freezed.dart';
part 'booth.g.dart';

/// 부스 모델 (API: CatchBoothObject)
///
/// 축제 부스 정보를 나타냅니다.
/// 백엔드 API 스키마에 맞춰 설계되었습니다.
@freezed
class Booth with _$Booth {
  const factory Booth({
    required String id,
    required String masterId,
    required String title,
    required int seatCount,
    required int avgWaitMinutes,
    required String status, // PREPARING | OPERATING | ENDED
    @FlexibleDateTimeConverter() required DateTime createdAt,
    @FlexibleDateTimeConverter() required DateTime updatedAt,
  }) = _Booth;

  factory Booth.fromJson(Map<String, dynamic> json) => _$BoothFromJson(json);
}

/// 부스 상태 Enum
enum BoothStatus {
  @JsonValue('PREPARING')
  preparing, // 준비 중
  @JsonValue('OPERATING')
  operating, // 운영 중
  @JsonValue('ENDED')
  ended, // 종료
}

/// BoothStatus 확장 메서드
extension BoothStatusX on BoothStatus {
  /// 한글 텍스트 반환
  String get text {
    switch (this) {
      case BoothStatus.preparing:
        return '준비중';
      case BoothStatus.operating:
        return '운영중';
      case BoothStatus.ended:
        return '종료';
    }
  }

  /// API 값 반환
  String get apiValue {
    switch (this) {
      case BoothStatus.preparing:
        return 'PREPARING';
      case BoothStatus.operating:
        return 'OPERATING';
      case BoothStatus.ended:
        return 'ENDED';
    }
  }

  /// String → Enum 변환
  static BoothStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PREPARING':
        return BoothStatus.preparing;
      case 'OPERATING':
        return BoothStatus.operating;
      case 'ENDED':
        return BoothStatus.ended;
      default:
        return BoothStatus.ended;
    }
  }

  /// 상태별 색상 (UI용)
  bool get isActive => this == BoothStatus.operating;
}
