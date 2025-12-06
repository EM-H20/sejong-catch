import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_queue_status.freezed.dart';
part 'my_queue_status.g.dart';

/// 내 대기 순번 조회 결과
///
/// POST /catch/queues/me-status 응답
@freezed
class MyQueueStatus with _$MyQueueStatus {
  const factory MyQueueStatus({
    required String boothId,
    required String visitorId,
    required int ticketNo,
    required String state, // WAITING | IN_SERVICE | COMPLETED | CANCELED
    required int teamsAhead,
    required int position,
  }) = _MyQueueStatus;

  factory MyQueueStatus.fromJson(Map<String, dynamic> json) =>
      _$MyQueueStatusFromJson(json);
}
