import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/response/queue_item.dart';
import '../../data/models/response/my_queue_item.dart';

part 'queue_state.freezed.dart';

/// 큐 페이지 상태 모델
///
/// 전체 큐 목록, 내 대기열, 로딩 상태 등을 관리합니다.
@freezed
class QueueState with _$QueueState {
  const factory QueueState({
    @Default([]) List<QueueItem> allQueues, // 전체 큐 목록
    @Default([]) List<MyQueueItem> myQueues, // 내 대기열
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(0) int currentTabIndex, // 현재 탭 (0: 전체, 1: 내 대기열)
    @Default(false) bool isUnderDevelopment, // 🚧 API 미구현 (Real 모드 시 true)
  }) = _QueueState;
}
