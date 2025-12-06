import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/json_converters.dart';

part 'queue_entry.freezed.dart';
part 'queue_entry.g.dart';

/// 대기열 엔트리 모델 (API: CatchQueueEntry)
///
/// 사용자의 대기열 항목 정보를 나타냅니다.
@freezed
class QueueEntry with _$QueueEntry {
  const factory QueueEntry({
    required String id,
    required String boothId,
    String? visitorId, // nullable: 서버에서 null일 수 있음
    required int ticketNo,
    @Default('WAITING') String state, // WAITING | IN_SERVICE | COMPLETED | CANCELED
    @FlexibleDateTimeConverter() required DateTime joinedAt,
  }) = _QueueEntry;

  factory QueueEntry.fromJson(Map<String, dynamic> json) =>
      _$QueueEntryFromJson(json);
}

/// 대기열 상태 Enum
enum QueueEntryState {
  @JsonValue('WAITING')
  waiting, // 대기 중
  @JsonValue('IN_SERVICE')
  inService, // 이용 중
  @JsonValue('COMPLETED')
  completed, // 완료
  @JsonValue('CANCELED')
  canceled, // 취소
}

/// QueueEntryState 확장 메서드
extension QueueEntryStateX on QueueEntryState {
  /// 한글 텍스트 반환
  String get text {
    switch (this) {
      case QueueEntryState.waiting:
        return '대기중';
      case QueueEntryState.inService:
        return '이용중';
      case QueueEntryState.completed:
        return '완료';
      case QueueEntryState.canceled:
        return '취소';
    }
  }

  /// API 값 반환
  String get apiValue {
    switch (this) {
      case QueueEntryState.waiting:
        return 'WAITING';
      case QueueEntryState.inService:
        return 'IN_SERVICE';
      case QueueEntryState.completed:
        return 'COMPLETED';
      case QueueEntryState.canceled:
        return 'CANCELED';
    }
  }

  /// String → Enum 변환
  static QueueEntryState fromString(String value) {
    switch (value.toUpperCase()) {
      case 'WAITING':
        return QueueEntryState.waiting;
      case 'IN_SERVICE':
        return QueueEntryState.inService;
      case 'COMPLETED':
        return QueueEntryState.completed;
      case 'CANCELED':
        return QueueEntryState.canceled;
      default:
        return QueueEntryState.canceled;
    }
  }

  /// 활성 상태 여부
  bool get isActive =>
      this == QueueEntryState.waiting || this == QueueEntryState.inService;
}
