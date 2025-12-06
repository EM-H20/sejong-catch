import 'package:freezed_annotation/freezed_annotation.dart';

import 'queue_entry.dart';

part 'enqueue_result.freezed.dart';
part 'enqueue_result.g.dart';

/// 대기열 등록 결과 (API: CatchQueueEnqueueResult)
///
/// POST /catch/queues/enqueue 응답
@freezed
class EnqueueResult with _$EnqueueResult {
  const factory EnqueueResult({
    required String mode, // IN_SERVICE | WAITING
    required int remainingSeats,
    required QueueEntry entry,
  }) = _EnqueueResult;

  factory EnqueueResult.fromJson(Map<String, dynamic> json) =>
      _$EnqueueResultFromJson(json);
}

/// 등록 모드 Enum
enum EnqueueMode {
  @JsonValue('IN_SERVICE')
  inService, // 즉시 입장
  @JsonValue('WAITING')
  waiting, // 대기열 등록
}

/// EnqueueMode 확장 메서드
extension EnqueueModeX on EnqueueMode {
  /// 한글 텍스트 반환
  String get text {
    switch (this) {
      case EnqueueMode.inService:
        return '즉시 입장';
      case EnqueueMode.waiting:
        return '대기 등록';
    }
  }

  /// String → Enum 변환
  static EnqueueMode fromString(String value) {
    switch (value.toUpperCase()) {
      case 'IN_SERVICE':
        return EnqueueMode.inService;
      case 'WAITING':
        return EnqueueMode.waiting;
      default:
        return EnqueueMode.waiting;
    }
  }
}
