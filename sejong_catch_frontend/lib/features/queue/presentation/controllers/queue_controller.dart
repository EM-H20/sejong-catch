import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../models/queue_state.dart';
import '../../data/models/response/queue_item.dart';
import '../../data/repositories/queue_repository.dart';

part 'queue_controller.g.dart';

/// 큐 페이지 컨트롤러
///
/// 큐 목록, 내 대기열, 큐 참여/포기 등의 상태와 비즈니스 로직을 관리합니다.
/// Repository 패턴을 사용하여 Mock/Real 모드를 분리합니다.
@riverpod
class QueueController extends _$QueueController {
  @override
  QueueState build() {
    // 🚧 Real 모드: API 미구현 상태 → 개발 중 표시
    if (!EnvConfig.useMockAuth) {
      return const QueueState(isUnderDevelopment: true);
    }

    // 🧪 Mock 모드: 초기 데이터 로드
    _loadInitialData();
    return const QueueState(isLoading: true);
  }

  /// 초기 데이터 로드
  Future<void> _loadInitialData() async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final queues = await repository.getQueues();
      final myQueues = await repository.getMyQueues();

      state = state.copyWith(
        isLoading: false,
        allQueues: queues,
        myQueues: myQueues,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 탭 변경
  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 학생용 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 큐 참여
  Future<void> joinQueue(String queueId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final myQueue = await repository.joinQueue(queueId);

      // 내 대기열에 추가 + 전체 큐 목록 갱신
      final updatedQueues = await repository.getQueues();
      state = state.copyWith(
        isLoading: false,
        allQueues: updatedQueues,
        myQueues: [...state.myQueues, myQueue],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 큐 포기
  Future<void> cancelQueue(String queueId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.cancelQueue(queueId);

      final updatedMyQueues =
          state.myQueues.where((q) => q.id != queueId).toList();
      state = state.copyWith(isLoading: false, myQueues: updatedMyQueues);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 운영자 전용 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 큐 생성
  Future<void> createQueue({
    required String name,
    required String type,
    required int avgWaitTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final newQueue = await repository.createQueue(
        name: name,
        type: type,
        avgWaitTime: avgWaitTime,
      );

      state = state.copyWith(
        isLoading: false,
        allQueues: [...state.allQueues, newQueue],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 📣 다음 대기자 호출
  Future<bool> callNextInQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedQueue = await repository.callNext(queueId);

      _updateQueueInList(updatedQueue);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// ⏸️ 큐 일시정지
  Future<bool> pauseQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedQueue = await repository.pauseQueue(queueId);

      _updateQueueInList(updatedQueue);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// ▶️ 큐 재개
  Future<bool> resumeQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedQueue = await repository.resumeQueue(queueId);

      _updateQueueInList(updatedQueue);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 🛑 큐 마감
  Future<bool> closeQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedQueue = await repository.closeQueue(queueId);

      _updateQueueInList(updatedQueue);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 🗑️ 큐 삭제
  Future<bool> deleteQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.deleteQueue(queueId);

      final updatedQueues =
          state.allQueues.where((q) => q.id != queueId).toList();
      state = state.copyWith(allQueues: updatedQueues);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📋 공통 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 큐 목록 새로고침
  Future<void> refreshQueues() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final queues = await repository.getQueues();
      final myQueues = await repository.getMyQueues();

      state = state.copyWith(
        isLoading: false,
        allQueues: queues,
        myQueues: myQueues,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 🔄 큐 목록에서 특정 큐 업데이트 (헬퍼)
  void _updateQueueInList(QueueItem updatedQueue) {
    final updatedQueues = state.allQueues.map((q) {
      return q.id == updatedQueue.id ? updatedQueue : q;
    }).toList();

    state = state.copyWith(allQueues: updatedQueues);
  }
}
