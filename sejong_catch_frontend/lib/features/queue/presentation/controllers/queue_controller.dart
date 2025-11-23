import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // 초기 상태: 더미 데이터 로드
    _loadDummyData();
    return const QueueState();
  }

  /// 더미 데이터 로드 (API 구현 전 임시!)
  ///
  /// TODO: API 구현 시 제거하고 실제 API 호출로 교체
  void _loadDummyData() {
    state = state.copyWith(
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

  /// 큐 목록 새로고침
  ///
  /// TODO: API 구현 시 실제 큐 목록 조회 API 호출
  Future<void> refreshQueues() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: API 호출
      // final queues = await ref.read(queueRepositoryProvider).getQueues();

      // 임시: 더미 데이터 다시 로드
      _loadDummyData();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
