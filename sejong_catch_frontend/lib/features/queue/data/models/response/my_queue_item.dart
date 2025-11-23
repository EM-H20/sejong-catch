import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_queue_item.freezed.dart';
part 'my_queue_item.g.dart';

/// 내 큐 아이템 모델
///
/// 사용자가 참여한 큐의 정보를 나타냅니다.
/// 내 순번, 예상 대기 시간 등의 정보를 포함합니다.
@freezed
class MyQueueItem with _$MyQueueItem {
  const factory MyQueueItem({
    required String id,
    required String name,
    required int myNumber, // 내 순번
    required int currentNumber, // 현재 순번
    required int peopleAhead, // 앞 대기 인원
    required int estimatedWait, // 예상 대기 시간(분)
  }) = _MyQueueItem;

  factory MyQueueItem.fromJson(Map<String, dynamic> json) =>
      _$MyQueueItemFromJson(json);
}
