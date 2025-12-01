import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../models/queue_state.dart';
import '../../data/models/response/queue_item.dart';
import '../../data/models/response/my_queue_item.dart';

part 'queue_controller.g.dart';

/// 큐 페이지 컨트롤러
///
/// 큐 목록, 내 대기열, 큐 참여/포기 등의 상태와 비즈니스 로직을 관리합니다.
@riverpod
class QueueController extends _$QueueController {
  @override
  QueueState build() {
    // ═══════════════════════════════════════════════════════════════════════════
    // 🔀 Mock/Real 모드 분기
    // ═══════════════════════════════════════════════════════════════════════════

    // 🚧 Real 모드: API 미구현 상태 → 개발 중 표시
    if (!EnvConfig.useMockAuth) {
      return const QueueState(isUnderDevelopment: true);
    }

    // 🧪 Mock 모드: 더미 데이터로 UI 테스트
    return QueueState(
      allQueues: [
        const QueueItem(
          id: 'q1',
          name: '🍗 치킨부스',
          type: 'food',
          status: 'active',
          waiting: 12,
          currentNumber: 5,
          avgWaitTime: 15,
        ),
        const QueueItem(
          id: 'q2',
          name: '🍺 주점',
          type: 'drink',
          status: 'active',
          waiting: 8,
          currentNumber: 3,
          avgWaitTime: 10,
        ),
        const QueueItem(
          id: 'q3',
          name: '🎮 게임존',
          type: 'game',
          status: 'paused',
          waiting: 5,
          currentNumber: 2,
          avgWaitTime: 20,
        ),
        const QueueItem(
          id: 'q4',
          name: '📸 포토존',
          type: 'photo',
          status: 'full',
          waiting: 30,
          currentNumber: 15,
          avgWaitTime: 5,
        ),
      ],
      myQueues: [
        const MyQueueItem(
          id: 'mq1',
          name: '🍗 치킨부스',
          myNumber: 8,
          currentNumber: 5,
          peopleAhead: 3,
          estimatedWait: 15,
        ),
      ],
    );
  }

  /// 탭 변경
  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  /// 큐 참여
  ///
  /// TODO: API 구현 시 실제 큐 참여 API 호출
  Future<void> joinQueue(String queueId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: API 호출
      // await ref.read(queueRepositoryProvider).joinQueue(queueId);

      // 임시: 1초 대기 (네트워크 시뮬레이션)
      await Future.delayed(const Duration(seconds: 1));

      // 임시: 성공 처리 (실제로는 API 응답으로 myQueues 업데이트)
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 큐 포기
  ///
  /// TODO: API 구현 시 실제 큐 포기 API 호출
  Future<void> cancelQueue(String queueId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: API 호출
      // await ref.read(queueRepositoryProvider).cancelQueue(queueId);

      // 임시: 1초 대기
      await Future.delayed(const Duration(seconds: 1));

      // 임시: myQueues에서 제거
      final updatedMyQueues =
          state.myQueues.where((q) => q.id != queueId).toList();
      state = state.copyWith(isLoading: false, myQueues: updatedMyQueues);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 큐 생성 (운영자 전용)
  ///
  /// TODO: API 구현 시 실제 큐 생성 API 호출
  Future<void> createQueue({
    required String name,
    required String type,
    required int avgWaitTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: API 호출
      // await ref.read(queueRepositoryProvider).createQueue(...);

      // 임시: 1초 대기
      await Future.delayed(const Duration(seconds: 1));

      // 임시: allQueues에 추가 (실제로는 API 응답으로 전체 목록 갱신)
      final newQueue = QueueItem(
        id: 'q${state.allQueues.length + 1}',
        name: name,
        type: type,
        status: 'active',
        waiting: 0,
        currentNumber: 0,
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

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 운영자 전용 큐 관리 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 📣 다음 대기자 호출 (운영자 전용)
  ///
  /// **동작**:
  /// - currentNumber +1 (다음 번호 호출)
  /// - waiting -1 (대기 인원 감소)
  ///
  /// **제약조건**:
  /// - 대기 인원이 0명이면 호출 불가
  /// - 큐가 active 상태일 때만 호출 가능
  ///
  /// TODO: API 구현 시 실제 API 호출로 교체
  Future<bool> callNextInQueue(String queueId) async {
    try {
      // 해당 큐 찾기
      final queueIndex = state.allQueues.indexWhere((q) => q.id == queueId);
      if (queueIndex == -1) return false;

      final queue = state.allQueues[queueIndex];

      // 대기 인원 체크
      if (queue.waiting <= 0) return false;

      // 네트워크 시뮬레이션 (짧게)
      await Future.delayed(const Duration(milliseconds: 300));

      // 상태 업데이트: currentNumber +1, waiting -1
      final updatedQueue = queue.copyWith(
        currentNumber: queue.currentNumber + 1,
        waiting: queue.waiting - 1,
      );

      final updatedQueues = List<QueueItem>.from(state.allQueues);
      updatedQueues[queueIndex] = updatedQueue;

      state = state.copyWith(allQueues: updatedQueues);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// ⏸️ 큐 일시정지 (운영자 전용)
  ///
  /// **동작**: status를 'paused'로 변경
  ///
  /// TODO: API 구현 시 실제 API 호출로 교체
  Future<bool> pauseQueue(String queueId) async {
    return _updateQueueStatus(queueId, 'paused');
  }

  /// ▶️ 큐 재개 (운영자 전용)
  ///
  /// **동작**: status를 'active'로 변경
  ///
  /// TODO: API 구현 시 실제 API 호출로 교체
  Future<bool> resumeQueue(String queueId) async {
    return _updateQueueStatus(queueId, 'active');
  }

  /// 🛑 큐 마감 (운영자 전용)
  ///
  /// **동작**: status를 'full'로 변경
  ///
  /// TODO: API 구현 시 실제 API 호출로 교체
  Future<bool> closeQueue(String queueId) async {
    return _updateQueueStatus(queueId, 'full');
  }

  /// 🔄 큐 상태 변경 헬퍼 메서드
  Future<bool> _updateQueueStatus(String queueId, String newStatus) async {
    try {
      final queueIndex = state.allQueues.indexWhere((q) => q.id == queueId);
      if (queueIndex == -1) return false;

      // 네트워크 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 300));

      final queue = state.allQueues[queueIndex];
      final updatedQueue = queue.copyWith(status: newStatus);

      final updatedQueues = List<QueueItem>.from(state.allQueues);
      updatedQueues[queueIndex] = updatedQueue;

      state = state.copyWith(allQueues: updatedQueues);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 🗑️ 큐 삭제 (운영자 전용)
  ///
  /// **동작**: allQueues에서 해당 큐 제거
  ///
  /// TODO: API 구현 시 실제 API 호출로 교체
  Future<bool> deleteQueue(String queueId) async {
    try {
      // 네트워크 시뮬레이션
      await Future.delayed(const Duration(milliseconds: 500));

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
  ///
  /// TODO: API 구현 시 실제 큐 목록 조회 API 호출
  Future<void> refreshQueues() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: API 호출
      // final queues = await ref.read(queueRepositoryProvider).getQueues();

      // 임시: 1초 대기 (네트워크 시뮬레이션)
      await Future.delayed(const Duration(seconds: 1));

      // 임시: 더미 데이터 다시 로드
      state = state.copyWith(
        isLoading: false,
        allQueues: [
          const QueueItem(
            id: 'q1',
            name: '🍗 치킨부스',
            type: 'food',
            status: 'active',
            waiting: 12,
            currentNumber: 5,
            avgWaitTime: 15,
          ),
          const QueueItem(
            id: 'q2',
            name: '🍺 주점',
            type: 'drink',
            status: 'active',
            waiting: 8,
            currentNumber: 3,
            avgWaitTime: 10,
          ),
          const QueueItem(
            id: 'q3',
            name: '🎮 게임존',
            type: 'game',
            status: 'paused',
            waiting: 5,
            currentNumber: 2,
            avgWaitTime: 20,
          ),
          const QueueItem(
            id: 'q4',
            name: '📸 포토존',
            type: 'photo',
            status: 'full',
            waiting: 30,
            currentNumber: 15,
            avgWaitTime: 5,
          ),
        ],
        myQueues: [
          const MyQueueItem(
            id: 'mq1',
            name: '🍗 치킨부스',
            myNumber: 8,
            currentNumber: 5,
            peopleAhead: 3,
            estimatedWait: 15,
          ),
        ],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
