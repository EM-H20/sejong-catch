/// 🎛️ 큐 관리 Controller (운영자용)
///
/// CLAUDE.md 원칙:
/// ✅ Riverpod + 일반 Dart 클래스 (Freezed 사용 안함)
/// ✅ copyWith 수동 구현으로 불변 상태 보장
/// ✅ 운영자 권한 전용 기능

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/queue_entity.dart';
import '../../domain/entities/participant_entity.dart';
import '../../data/models/queue_model.dart';
import '../../data/models/participant_model.dart';
import '../../data/models/queue_state.dart';
import 'queue_controller.dart';

part 'queue_manage_controller.g.dart';

/// 🎪 큐 관리 Controller (운영자 전용)
@riverpod
class QueueManageController extends _$QueueManageController {
  String? _currentQueueId;

  @override
  QueueManageState build(String queueId) {
    _currentQueueId = queueId;
    // 초기화 시 해당 큐의 정보 로드
    Future.microtask(() => _loadQueueDetails(queueId));
    return const QueueManageState();
  }

  /// 📋 특정 큐 상세 정보 로드
  Future<void> loadQueueDetails() async {
    if (_currentQueueId != null) {
      await _loadQueueDetails(_currentQueueId!);
    }
  }

  Future<void> _loadQueueDetails(String queueId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(queueRepositoryProvider);

      // 큐 정보와 참가자 목록을 병렬로 가져오기
      final results = await Future.wait([
        repository.getQueueById(queueId),
        repository.getParticipantsByQueueId(queueId),
      ]);

      final queueEntity = results[0] as QueueEntity;
      final participantEntities = results[1] as List<ParticipantEntity>;

      // Entity를 Model로 변환
      final participants = participantEntities
          .map((e) => e.toModel())
          .toList();

      state = state.copyWith(
        selectedQueue: queueEntity.toModel(),
        participants: participants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '큐 정보를 불러오는데 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 📋 내가 운영하는 큐 목록 로드
  Future<void> loadMyQueues() async {
    await _loadMyQueues();
  }

  Future<void> _loadMyQueues() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 실제 운영자 ID는 AuthController에서 가져와야 함
      const mockOperatorId = 'operator_demo';

      final repository = ref.read(queueRepositoryProvider);
      final allQueues = await repository.getQueues();

      // 내가 운영하는 큐만 필터링
      final myQueues = allQueues
          .where((queue) => queue.operatorId == mockOperatorId)
          .map((e) => e.toModel())
          .toList();

      state = state.copyWith(
        myQueues: myQueues,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '내 큐 목록을 불러오는데 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 🎪 새 큐 생성
  Future<void> createQueue({
    required String title,
    required String description,
    required QueueType type,
    required String location,
    required int maxCapacity,
    required DateTime startTime,
    required DateTime endTime,
    String? imageUrl,
    String? notice,
  }) async {
    if (state.isCreating) return;

    state = state.copyWith(isCreating: true, error: null);

    try {
      // TODO: 실제 운영자 정보는 AuthController에서 가져와야 함
      const mockOperatorId = 'operator_demo';
      const mockOperatorName = '운영자';

      final repository = ref.read(queueRepositoryProvider);
      final newQueue = await repository.createQueue(
        title: title,
        description: description,
        type: type,
        location: location,
        operatorId: mockOperatorId,
        operatorName: mockOperatorName,
        maxCapacity: maxCapacity,
        startTime: startTime,
        endTime: endTime,
        imageUrl: imageUrl,
        notice: notice,
      );

      // 내 큐 목록에 추가
      final updatedQueues = [...state.myQueues, newQueue.toModel()];

      state = state.copyWith(
        myQueues: updatedQueues,
        isCreating: false,
      );

      // 전체 큐 목록도 새로고침
      ref.invalidate(queueControllerProvider);
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: '큐 생성에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 🎯 큐 선택 및 참가자 로드
  Future<void> selectQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final [queue, participants] = await Future.wait([
        repository.getQueueById(queueId),
        repository.getParticipantsByQueueId(queueId),
      ]);

      if (queue == null) {
        state = state.copyWith(error: '큐 정보를 찾을 수 없어요');
        return;
      }

      state = state.copyWith(
        editingQueue: (queue as QueueEntity).toModel(),
        participants: (participants as List).map((e) => e.toModel()).toList().cast<ParticipantModel>(),
      );
    } catch (e) {
      state = state.copyWith(error: '큐 선택에 실패했어요: ${e.toString()}');
    }
  }


  /// 📢 공지사항 업데이트
  Future<void> updateNotice(String queueId, String notice) async {
    if (state.isUpdating) return;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.updateQueueNotice(queueId, notice);

      // 상태 업데이트
      final updatedQueues = state.myQueues.map((queue) {
        if (queue.id == queueId) {
          return queue.copyWith(notice: notice, updatedAt: DateTime.now());
        }
        return queue;
      }).toList();

      state = state.copyWith(
        myQueues: updatedQueues,
        isUpdating: false,
      );

      // 편집 중인 큐도 업데이트
      if (state.editingQueue?.id == queueId) {
        state = state.copyWith(
          editingQueue: state.editingQueue?.copyWith(
            notice: notice,
            updatedAt: DateTime.now(),
          ),
        );
      }

      ref.invalidate(queueControllerProvider);
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: '공지사항 업데이트에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 📞 참가자 호출
  Future<void> callParticipant(String participantId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.callParticipant(participantId);

      // 참가자 상태 업데이트
      await _refreshParticipants();
    } catch (e) {
      state = state.copyWith(error: '참가자 호출에 실패했어요: ${e.toString()}');
    }
  }

  /// ✅ 참가자 완료 처리
  Future<void> completeParticipant(String participantId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.completeParticipant(participantId);

      // 참가자 상태 업데이트
      await _refreshParticipants();
    } catch (e) {
      state = state.copyWith(error: '참가자 완료 처리에 실패했어요: ${e.toString()}');
    }
  }

  /// ❌ 참가자 취소 처리
  Future<void> cancelParticipant(String participantId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.cancelParticipant(participantId);

      // 참가자 상태 업데이트
      await _refreshParticipants();
    } catch (e) {
      state = state.copyWith(error: '참가자 취소에 실패했어요: ${e.toString()}');
    }
  }

  /// 📞 다음 참가자 자동 호출
  Future<void> callNextParticipant() async {
    final nextParticipant = state.nextParticipant;
    if (nextParticipant == null) {
      state = state.copyWith(error: '호출할 다음 참가자가 없어요');
      return;
    }

    await callParticipant(nextParticipant.id);
  }

  /// 🔄 참가자 목록 새로고침
  Future<void> refreshParticipants() async {
    await _refreshParticipants();
  }

  Future<void> _refreshParticipants() async {
    if (state.editingQueue == null) return;

    try {
      final repository = ref.read(queueRepositoryProvider);
      final participants = await repository.getParticipantsByQueueId(
        state.editingQueue!.id,
      );

      state = state.copyWith(
        participants: participants.map((e) => e.toModel()).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: '참가자 목록 새로고침에 실패했어요: ${e.toString()}');
    }
  }

  /// 🧹 선택된 큐 클리어
  void clearEditingQueue() {
    state = state.copyWith(
      editingQueue: null,
      participants: [],
    );
  }

  /// ⚠️ 에러 클리어
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 🔄 새로고침
  Future<void> refresh() async {
    await loadQueueDetails();
  }

  /// 🎛️ 큐 상태 변경
  Future<void> updateQueueStatus(QueueStatus newStatus) async {
    if (_currentQueueId == null) return;

    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.updateQueueStatus(_currentQueueId!, newStatus);

      // 로컬 상태 업데이트
      if (state.selectedQueue != null) {
        final updatedQueue = state.selectedQueue!.copyWith(status: newStatus);
        state = state.copyWith(selectedQueue: updatedQueue);
      }
    } catch (e) {
      state = state.copyWith(
        error: '큐 상태 변경에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 🗑️ 큐 초기화 (모든 대기자 제거)
  Future<void> clearQueue() async {
    if (_currentQueueId == null) return;

    try {
      final repository = ref.read(queueRepositoryProvider);

      // 모든 활성 참가자를 취소 처리
      final activeParticipants = state.participants
          .where((p) => p.isActive)
          .toList();

      for (final participant in activeParticipants) {
        await repository.cancelParticipant(participant.id);
      }

      // 참가자 목록 새로고침
      await loadQueueDetails();
    } catch (e) {
      state = state.copyWith(
        error: '큐 초기화에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 📊 내 큐 통계 정보
  Map<String, dynamic> get myQueueStats {
    final activeQueues = state.myQueues.where((q) => q.status.isOperational).length;
    final totalParticipants = state.myQueues.fold(0, (sum, queue) => sum + queue.currentCount);

    return {
      'totalQueues': state.myQueues.length,
      'activeQueues': activeQueues,
      'totalParticipants': totalParticipants,
    };
  }
}

/// 🔔 호출이 필요한 참가자 알림 Provider
@riverpod
class ParticipantAlertController extends _$ParticipantAlertController {
  @override
  List<ParticipantModel> build() {
    return [];
  }

  /// 호출 대기 중인 참가자 확인
  Future<void> checkForCalls() async {
    try {
      // TODO: 실제 운영자 ID는 AuthController에서 가져와야 함
      const mockOperatorId = 'operator_demo';

      final repository = ref.read(queueRepositoryProvider);
      final allQueues = await repository.getQueues();
      final myQueues = allQueues.where((queue) => queue.operatorId == mockOperatorId);

      final List<ParticipantModel> alertParticipants = [];

      for (final queue in myQueues) {
        final participants = await repository.getParticipantsByQueueId(queue.id);
        final calledParticipants = participants
            .where((p) => p.status == ParticipantStatus.called)
            .map((e) => e.toModel())
            .toList();

        alertParticipants.addAll(calledParticipants);
      }

      state = alertParticipants;
    } catch (e) {
      // 알림 확인 실패는 조용히 넘어감 (프로덕션 환경)
      // TODO: 향후 logging 프레임워크 도입 시 활용
    }
  }

  /// 알림 클리어
  void clearAlert(String participantId) {
    state = state.where((p) => p.id != participantId).toList();
  }
}