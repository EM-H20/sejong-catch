import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../models/response/queue_item.dart';
import '../models/response/my_queue_item.dart';

part 'queue_repository.g.dart';

/// 큐 Repository
///
/// 큐 관련 데이터 접근을 담당합니다.
/// Mock/Real 모드에 따라 더미 데이터 또는 실제 API를 호출합니다.
@riverpod
QueueRepository queueRepository(Ref ref) {
  return QueueRepository(ref);
}

class QueueRepository {
  final Ref ref;

  QueueRepository(this.ref);

  // ═══════════════════════════════════════════════════════════════════════════
  // 📋 큐 조회
  // ═══════════════════════════════════════════════════════════════════════════

  /// 전체 큐 목록 조회
  Future<List<QueueItem>> getQueues() async {
    if (EnvConfig.useMockAuth) {
      return _mockGetQueues();
    } else {
      return _realGetQueues();
    }
  }

  /// 내 대기열 조회
  Future<List<MyQueueItem>> getMyQueues() async {
    if (EnvConfig.useMockAuth) {
      return _mockGetMyQueues();
    } else {
      return _realGetMyQueues();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 학생용 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 큐 참여
  Future<MyQueueItem> joinQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockJoinQueue(queueId);
    } else {
      return _realJoinQueue(queueId);
    }
  }

  /// 큐 포기
  Future<void> cancelQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockCancelQueue(queueId);
    } else {
      return _realCancelQueue(queueId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 운영자용 기능
  // ═══════════════════════════════════════════════════════════════════════════

  /// 큐 생성
  Future<QueueItem> createQueue({
    required String name,
    required String type,
    required int avgWaitTime,
  }) async {
    if (EnvConfig.useMockAuth) {
      return _mockCreateQueue(name: name, type: type, avgWaitTime: avgWaitTime);
    } else {
      return _realCreateQueue(name: name, type: type, avgWaitTime: avgWaitTime);
    }
  }

  /// 다음 대기자 호출
  Future<QueueItem> callNext(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockCallNext(queueId);
    } else {
      return _realCallNext(queueId);
    }
  }

  /// 큐 일시정지
  Future<QueueItem> pauseQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockUpdateStatus(queueId, 'paused');
    } else {
      return _realPauseQueue(queueId);
    }
  }

  /// 큐 재개
  Future<QueueItem> resumeQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockUpdateStatus(queueId, 'active');
    } else {
      return _realResumeQueue(queueId);
    }
  }

  /// 큐 마감
  Future<QueueItem> closeQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockUpdateStatus(queueId, 'full');
    } else {
      return _realCloseQueue(queueId);
    }
  }

  /// 큐 삭제
  Future<void> deleteQueue(String queueId) async {
    if (EnvConfig.useMockAuth) {
      return _mockDeleteQueue(queueId);
    } else {
      return _realDeleteQueue(queueId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🧪 Mock 구현 (개발용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mock 큐 데이터 저장소 (세션 동안 유지)
  static final List<QueueItem> _mockQueues = [
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
  ];

  static final List<MyQueueItem> _mockMyQueues = [
    const MyQueueItem(
      id: 'mq1',
      name: '🍗 치킨부스',
      myNumber: 8,
      currentNumber: 5,
      peopleAhead: 3,
      estimatedWait: 15,
    ),
  ];

  Future<List<QueueItem>> _mockGetQueues() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockQueues);
  }

  Future<List<MyQueueItem>> _mockGetMyQueues() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockMyQueues);
  }

  Future<MyQueueItem> _mockJoinQueue(String queueId) async {
    await Future.delayed(const Duration(seconds: 1));

    final queueIndex = _mockQueues.indexWhere((q) => q.id == queueId);
    if (queueIndex == -1) throw Exception('큐를 찾을 수 없습니다');

    final queue = _mockQueues[queueIndex];
    final myNumber = queue.currentNumber + queue.waiting + 1;

    // 대기 인원 증가
    _mockQueues[queueIndex] = queue.copyWith(waiting: queue.waiting + 1);

    final myQueue = MyQueueItem(
      id: 'mq_${DateTime.now().millisecondsSinceEpoch}',
      name: queue.name,
      myNumber: myNumber,
      currentNumber: queue.currentNumber,
      peopleAhead: queue.waiting,
      estimatedWait: queue.avgWaitTime * (queue.waiting + 1),
    );

    _mockMyQueues.add(myQueue);
    return myQueue;
  }

  Future<void> _mockCancelQueue(String queueId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockMyQueues.removeWhere((q) => q.id == queueId);
  }

  Future<QueueItem> _mockCreateQueue({
    required String name,
    required String type,
    required int avgWaitTime,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final newQueue = QueueItem(
      id: 'q_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: type,
      status: 'active',
      waiting: 0,
      currentNumber: 0,
      avgWaitTime: avgWaitTime,
    );

    _mockQueues.add(newQueue);
    return newQueue;
  }

  Future<QueueItem> _mockCallNext(String queueId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final queueIndex = _mockQueues.indexWhere((q) => q.id == queueId);
    if (queueIndex == -1) throw Exception('큐를 찾을 수 없습니다');

    final queue = _mockQueues[queueIndex];
    if (queue.waiting <= 0) throw Exception('대기 인원이 없습니다');

    final updatedQueue = queue.copyWith(
      currentNumber: queue.currentNumber + 1,
      waiting: queue.waiting - 1,
    );

    _mockQueues[queueIndex] = updatedQueue;
    return updatedQueue;
  }

  Future<QueueItem> _mockUpdateStatus(String queueId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final queueIndex = _mockQueues.indexWhere((q) => q.id == queueId);
    if (queueIndex == -1) throw Exception('큐를 찾을 수 없습니다');

    final updatedQueue = _mockQueues[queueIndex].copyWith(status: status);
    _mockQueues[queueIndex] = updatedQueue;
    return updatedQueue;
  }

  Future<void> _mockDeleteQueue(String queueId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockQueues.removeWhere((q) => q.id == queueId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🌐 Real API 구현 (프로덕션용 - 미구현)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<QueueItem>> _realGetQueues() async {
    // TODO: API 구현 시 실제 API 호출
    // final api = ref.read(queueApiProvider);
    // return await api.getQueues();
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<List<MyQueueItem>> _realGetMyQueues() async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<MyQueueItem> _realJoinQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<void> _realCancelQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<QueueItem> _realCreateQueue({
    required String name,
    required String type,
    required int avgWaitTime,
  }) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<QueueItem> _realCallNext(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<QueueItem> _realPauseQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<QueueItem> _realResumeQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<QueueItem> _realCloseQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }

  Future<void> _realDeleteQueue(String queueId) async {
    throw UnimplementedError('Queue API가 아직 구현되지 않았습니다');
  }
}
