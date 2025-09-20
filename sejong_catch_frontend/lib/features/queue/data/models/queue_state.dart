/// 🎛️ 큐 상태 관리 모델
///
/// CLAUDE.md 원칙:
/// ✅ 일반 Dart 클래스 사용 (Freezed 사용 안함)
/// ✅ copyWith 수동 구현으로 불변 상태 보장
/// ✅ Riverpod 상태 관리와 완벽 호환

import 'queue_model.dart';
import 'participant_model.dart';

class QueueState {
  final bool isLoading;
  final String? error;
  final List<QueueModel> queues;
  final List<ParticipantModel> myParticipations;
  final QueueModel? selectedQueue;
  final List<ParticipantModel> selectedQueueParticipants;
  final bool isJoining;
  final bool isLeaving;

  const QueueState({
    this.isLoading = false,
    this.error,
    this.queues = const [],
    this.myParticipations = const [],
    this.selectedQueue,
    this.selectedQueueParticipants = const [],
    this.isJoining = false,
    this.isLeaving = false,
  });

  /// copyWith 메서드 (불변 상태 변경)
  QueueState copyWith({
    bool? isLoading,
    String? error,
    List<QueueModel>? queues,
    List<ParticipantModel>? myParticipations,
    QueueModel? selectedQueue,
    List<ParticipantModel>? selectedQueueParticipants,
    bool? isJoining,
    bool? isLeaving,
  }) {
    return QueueState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      queues: queues ?? this.queues,
      myParticipations: myParticipations ?? this.myParticipations,
      selectedQueue: selectedQueue ?? this.selectedQueue,
      selectedQueueParticipants: selectedQueueParticipants ?? this.selectedQueueParticipants,
      isJoining: isJoining ?? this.isJoining,
      isLeaving: isLeaving ?? this.isLeaving,
    );
  }

  /// 에러 상태 클리어
  QueueState clearError() {
    return copyWith(error: null);
  }

  /// 로딩 상태 설정
  QueueState setLoading(bool loading) {
    return copyWith(isLoading: loading, error: null);
  }

  /// 에러 상태 설정
  QueueState setError(String errorMessage) {
    return copyWith(error: errorMessage, isLoading: false);
  }

  /// 활성 큐만 필터링
  List<QueueModel> get activeQueues {
    return queues.where((queue) => queue.status.isOperational).toList();
  }

  /// 타입별 큐 필터링
  List<QueueModel> getQueuesByType(QueueType type) {
    return queues.where((queue) => queue.type == type).toList();
  }

  /// 참여 중인 큐 확인
  bool isParticipatingInQueue(String queueId) {
    return myParticipations.any((p) => p.queueId == queueId && p.isActive);
  }

  /// 특정 큐에서의 내 순번 가져오기
  ParticipantModel? getMyParticipationInQueue(String queueId) {
    return myParticipations
        .where((p) => p.queueId == queueId && p.isActive)
        .firstOrNull;
  }

  /// 현재 선택된 큐에서의 내 참여 정보
  ParticipantModel? get myParticipationInSelectedQueue {
    if (selectedQueue == null) return null;
    return getMyParticipationInQueue(selectedQueue!.id);
  }

  /// 호출된 참여자가 있는지 확인
  bool get hasCalledParticipation {
    return myParticipations.any((p) => p.status == ParticipantStatus.called);
  }

  /// 호출된 참여자 목록
  List<ParticipantModel> get calledParticipations {
    return myParticipations
        .where((p) => p.status == ParticipantStatus.called)
        .toList();
  }

  /// 대기 중인 참여자 수
  int get totalWaitingCount {
    return myParticipations
        .where((p) => p.status == ParticipantStatus.waiting)
        .length;
  }

  /// 디버깅용 문자열
  @override
  String toString() {
    return 'QueueState(isLoading: $isLoading, queues: ${queues.length}, myParticipations: ${myParticipations.length}, hasError: ${error != null})';
  }
}

/// 🎪 큐 생성/관리 상태 (운영자용)
class QueueManageState {
  final bool isLoading;
  final String? error;
  final List<QueueModel> myQueues;        // 내가 운영하는 큐들
  final QueueModel? selectedQueue;        // 현재 관리 중인 큐
  final QueueModel? editingQueue;         // 편집 중인 큐
  final List<ParticipantModel> participants; // 선택된 큐의 참가자들
  final bool isCreating;
  final bool isUpdating;

  const QueueManageState({
    this.isLoading = false,
    this.error,
    this.myQueues = const [],
    this.selectedQueue,
    this.editingQueue,
    this.participants = const [],
    this.isCreating = false,
    this.isUpdating = false,
  });

  /// copyWith 메서드
  QueueManageState copyWith({
    bool? isLoading,
    String? error,
    List<QueueModel>? myQueues,
    QueueModel? selectedQueue,
    QueueModel? editingQueue,
    List<ParticipantModel>? participants,
    bool? isCreating,
    bool? isUpdating,
  }) {
    return QueueManageState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      myQueues: myQueues ?? this.myQueues,
      selectedQueue: selectedQueue ?? this.selectedQueue,
      editingQueue: editingQueue ?? this.editingQueue,
      participants: participants ?? this.participants,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  /// 활성 큐 수
  int get activeQueuesCount {
    return myQueues.where((q) => q.status.isOperational).length;
  }

  /// 총 대기자 수
  int get totalParticipantsCount {
    return myQueues.fold(0, (sum, queue) => sum + queue.currentCount);
  }

  /// 대기 중인 참가자들
  List<ParticipantModel> get waitingParticipants {
    return participants
        .where((p) => p.status == ParticipantStatus.waiting)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  /// 호출해야 할 다음 참가자
  ParticipantModel? get nextParticipant {
    final waiting = waitingParticipants;
    return waiting.isNotEmpty ? waiting.first : null;
  }

  @override
  String toString() {
    return 'QueueManageState(myQueues: ${myQueues.length}, participants: ${participants.length})';
  }
}

/// 📊 큐 통계 정보 (관리자용)
class QueueStatsInfo {
  final int totalQueues;
  final int activeQueues;
  final int totalParticipants;
  final int averageWaitTime;
  final Map<QueueType, int> queuesByType;
  final List<QueueModel> popularQueues;

  const QueueStatsInfo({
    required this.totalQueues,
    required this.activeQueues,
    required this.totalParticipants,
    required this.averageWaitTime,
    required this.queuesByType,
    required this.popularQueues,
  });

  factory QueueStatsInfo.empty() {
    return const QueueStatsInfo(
      totalQueues: 0,
      activeQueues: 0,
      totalParticipants: 0,
      averageWaitTime: 0,
      queuesByType: {},
      popularQueues: [],
    );
  }
}