/// 🏭 큐 Repository 구현체
///
/// CLAUDE.md 원칙:
/// ✅ Domain Repository 인터페이스 구현
/// ✅ Datasource를 통한 데이터 접근
/// ✅ Clean Architecture Data 계층

import 'dart:async';
import '../../domain/repositories/queue_repository.dart';
import '../../domain/entities/queue_entity.dart';
import '../../domain/entities/participant_entity.dart';
import '../models/queue_model.dart';
import '../datasources/queue_local_datasource.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueLocalDatasource _localDatasource;

  // Stream Controllers for real-time updates
  final _queuesController = StreamController<List<QueueEntity>>.broadcast();
  final Map<String, StreamController<List<ParticipantEntity>>> _participantsControllers = {};

  QueueRepositoryImpl({
    QueueLocalDatasource? localDatasource,
  }) : _localDatasource = localDatasource ?? QueueLocalDatasource();

  @override
  Future<List<QueueEntity>> getQueues() async {
    try {
      final models = await _localDatasource.getQueues();
      final entities = models.map((model) => QueueEntity.fromModel(model)).toList();

      // 실시간 업데이트 발행
      _queuesController.add(entities);

      return entities;
    } catch (e) {
      throw Exception('큐 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<QueueEntity>> getActiveQueues() async {
    try {
      final models = await _localDatasource.getActiveQueues();
      return models.map((model) => QueueEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('활성 큐 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<QueueEntity>> getQueuesByType(QueueType type) async {
    try {
      final allQueues = await getQueues();
      return allQueues.where((queue) => queue.type == type).toList();
    } catch (e) {
      throw Exception('타입별 큐 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<QueueEntity?> getQueueById(String queueId) async {
    try {
      final allQueues = await getQueues();
      return allQueues.where((queue) => queue.id == queueId).firstOrNull;
    } catch (e) {
      throw Exception('큐 정보를 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<ParticipantEntity>> getParticipantsByQueueId(String queueId) async {
    try {
      final models = await _localDatasource.getParticipantsByQueueId(queueId);
      final entities = models.map((model) => ParticipantEntity.fromModel(model)).toList();

      // 실시간 업데이트 발행
      _getParticipantsController(queueId).add(entities);

      return entities;
    } catch (e) {
      throw Exception('참가자 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<ParticipantEntity>> getParticipationsByUserId(String userId) async {
    try {
      final models = await _localDatasource.getParticipationsByUserId(userId);
      return models.map((model) => ParticipantEntity.fromModel(model)).toList();
    } catch (e) {
      throw Exception('참여 내역을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<ParticipantEntity?> getParticipantById(String participantId) async {
    try {
      final allParticipants = await _localDatasource.getParticipants();
      final model = allParticipants.where((p) => p.id == participantId).firstOrNull;
      return model != null ? ParticipantEntity.fromModel(model) : null;
    } catch (e) {
      throw Exception('참가자 정보를 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<ParticipantEntity> joinQueue({
    required String queueId,
    required String userId,
    required String userName,
    String? note,
  }) async {
    try {
      // 이미 참여 중인지 확인
      final myParticipations = await getParticipationsByUserId(userId);
      final alreadyJoined = myParticipations.any((p) => p.queueId == queueId && p.isActive);

      if (alreadyJoined) {
        throw Exception('이미 해당 큐에 참여 중입니다');
      }

      // 큐 정보 확인
      final queue = await getQueueById(queueId);
      if (queue == null) {
        throw Exception('존재하지 않는 큐입니다');
      }

      if (!queue.canJoin()) {
        throw Exception('현재 줄서기에 참여할 수 없습니다');
      }

      final model = await _localDatasource.joinQueue(
        queueId: queueId,
        userId: userId,
        userName: userName,
        note: note,
      );

      // 관련 스트림 업데이트
      await _refreshStreams(queueId);

      return ParticipantEntity.fromModel(model);
    } catch (e) {
      throw Exception('줄서기 참여에 실패했습니다: $e');
    }
  }

  @override
  Future<void> leaveQueue(String participantId) async {
    try {
      final participant = await getParticipantById(participantId);
      if (participant == null) {
        throw Exception('참가자 정보를 찾을 수 없습니다');
      }

      if (!participant.canBeCancelled()) {
        throw Exception('현재 상태에서는 취소할 수 없습니다');
      }

      await _localDatasource.leaveQueue(participantId);

      // 관련 스트림 업데이트
      await _refreshStreams(participant.queueId);
    } catch (e) {
      throw Exception('줄서기 취소에 실패했습니다: $e');
    }
  }

  @override
  Future<QueueEntity> createQueue({
    required String title,
    required String description,
    required QueueType type,
    required String location,
    required String operatorId,
    required String operatorName,
    required int maxCapacity,
    required DateTime startTime,
    required DateTime endTime,
    String? imageUrl,
    String? notice,
  }) async {
    // TODO: 실제 구현에서는 API 호출
    throw UnimplementedError('큐 생성은 아직 구현되지 않았습니다');
  }

  @override
  Future<void> updateQueueStatus(String queueId, QueueStatus status) async {
    try {
      await _localDatasource.updateQueueStatus(queueId, status);
      await _refreshStreams(queueId);
    } catch (e) {
      throw Exception('큐 상태 업데이트에 실패했습니다: $e');
    }
  }

  @override
  Future<void> updateQueueNotice(String queueId, String notice) async {
    // TODO: 실제 구현에서는 API 호출
    throw UnimplementedError('공지사항 업데이트는 아직 구현되지 않았습니다');
  }

  @override
  Future<void> updateQueueCapacity(String queueId, int maxCapacity) async {
    // TODO: 실제 구현에서는 API 호출
    throw UnimplementedError('정원 업데이트는 아직 구현되지 않았습니다');
  }

  @override
  Future<void> callParticipant(String participantId) async {
    try {
      await _localDatasource.callParticipant(participantId);

      final participant = await getParticipantById(participantId);
      if (participant != null) {
        await _refreshStreams(participant.queueId);
      }
    } catch (e) {
      throw Exception('참가자 호출에 실패했습니다: $e');
    }
  }

  @override
  Future<void> startService(String participantId) async {
    // TODO: 실제 구현에서는 API 호출
    throw UnimplementedError('서비스 시작은 아직 구현되지 않았습니다');
  }

  @override
  Future<void> completeParticipant(String participantId) async {
    try {
      await _localDatasource.completeParticipant(participantId);

      final participant = await getParticipantById(participantId);
      if (participant != null) {
        await _refreshStreams(participant.queueId);
      }
    } catch (e) {
      throw Exception('참가자 완료 처리에 실패했습니다: $e');
    }
  }

  @override
  Future<void> cancelParticipant(String participantId) async {
    try {
      await leaveQueue(participantId);
    } catch (e) {
      throw Exception('참가자 취소에 실패했습니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getQueueStats() async {
    try {
      final queues = await getQueues();
      final totalQueues = queues.length;
      final activeQueues = queues.where((q) => q.status.isOperational).length;
      final totalParticipants = queues.fold(0, (sum, queue) => sum + queue.currentCount);
      final averageWaitTime = queues.isEmpty
          ? 0
          : queues.fold(0, (sum, queue) => sum + queue.averageWaitTime) ~/ queues.length;

      return {
        'totalQueues': totalQueues,
        'activeQueues': activeQueues,
        'totalParticipants': totalParticipants,
        'averageWaitTime': averageWaitTime,
      };
    } catch (e) {
      throw Exception('통계 정보를 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<List<QueueEntity>> getPopularQueues({int limit = 10}) async {
    try {
      final queues = await getQueues();
      final sortedQueues = queues.toList()
        ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));

      return sortedQueues.take(limit).toList();
    } catch (e) {
      throw Exception('인기 큐 목록을 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Future<Map<QueueType, int>> getQueueCountByType() async {
    try {
      final queues = await getQueues();
      final countByType = <QueueType, int>{};

      for (final type in QueueType.values) {
        countByType[type] = queues.where((q) => q.type == type).length;
      }

      return countByType;
    } catch (e) {
      throw Exception('타입별 큐 개수를 불러오는데 실패했습니다: $e');
    }
  }

  @override
  Stream<List<QueueEntity>> watchQueues() {
    // 초기 데이터 로드
    getQueues();
    return _queuesController.stream;
  }

  @override
  Stream<List<ParticipantEntity>> watchParticipants(String queueId) {
    // 초기 데이터 로드
    getParticipantsByQueueId(queueId);
    return _getParticipantsController(queueId).stream;
  }

  @override
  Stream<ParticipantEntity?> watchMyParticipation(String queueId, String userId) {
    return watchParticipants(queueId).map((participants) {
      return participants.where((p) => p.userId == userId && p.isActive).firstOrNull;
    });
  }

  @override
  Future<void> refreshCache() async {
    try {
      _localDatasource.clearCache();

      // 모든 스트림 업데이트
      final queues = await getQueues();
      _queuesController.add(queues);

      for (final queueId in _participantsControllers.keys) {
        await _refreshStreams(queueId);
      }
    } catch (e) {
      throw Exception('캐시 새로고침에 실패했습니다: $e');
    }
  }

  @override
  void clearCache() {
    _localDatasource.clearCache();
  }

  /// 내부 헬퍼 메서드들
  StreamController<List<ParticipantEntity>> _getParticipantsController(String queueId) {
    if (!_participantsControllers.containsKey(queueId)) {
      _participantsControllers[queueId] = StreamController<List<ParticipantEntity>>.broadcast();
    }
    return _participantsControllers[queueId]!;
  }

  Future<void> _refreshStreams(String queueId) async {
    try {
      // 큐 목록 업데이트
      final queues = await getQueues();
      _queuesController.add(queues);

      // 참가자 목록 업데이트
      final participants = await getParticipantsByQueueId(queueId);
      _getParticipantsController(queueId).add(participants);
    } catch (e) {
      // 스트림 업데이트 실패는 조용히 넘어감 (프로덕션 환경)
      // TODO: 향후 logging 프레임워크 도입 시 활용
    }
  }

  /// 리소스 정리
  void dispose() {
    _queuesController.close();
    for (final controller in _participantsControllers.values) {
      controller.close();
    }
    _participantsControllers.clear();
  }
}