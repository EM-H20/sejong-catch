/// 🏭 큐 Repository 인터페이스
///
/// CLAUDE.md 원칙:
/// ✅ 순수 추상화 인터페이스
/// ✅ 비즈니스 로직에서 데이터 접근 분리
/// ✅ Clean Architecture Domain 계층

import '../entities/queue_entity.dart';
import '../entities/participant_entity.dart';
import '../../data/models/queue_model.dart';

abstract class QueueRepository {
  // 📋 큐 목록 관련
  Future<List<QueueEntity>> getQueues();
  Future<List<QueueEntity>> getActiveQueues();
  Future<List<QueueEntity>> getQueuesByType(QueueType type);
  Future<QueueEntity?> getQueueById(String queueId);

  // 🙋‍♂️ 참가자 관련
  Future<List<ParticipantEntity>> getParticipantsByQueueId(String queueId);
  Future<List<ParticipantEntity>> getParticipationsByUserId(String userId);
  Future<ParticipantEntity?> getParticipantById(String participantId);

  // 🎪 큐 참여 관련 (일반 사용자)
  Future<ParticipantEntity> joinQueue({
    required String queueId,
    required String userId,
    required String userName,
    String? note,
  });
  Future<void> leaveQueue(String participantId);

  // 🎛️ 큐 관리 관련 (운영자)
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
  });

  Future<void> updateQueueStatus(String queueId, QueueStatus status);
  Future<void> updateQueueNotice(String queueId, String notice);
  Future<void> updateQueueCapacity(String queueId, int maxCapacity);

  // 👥 참가자 관리 관련 (운영자)
  Future<void> callParticipant(String participantId);
  Future<void> startService(String participantId);
  Future<void> completeParticipant(String participantId);
  Future<void> cancelParticipant(String participantId);

  // 📊 통계 관련
  Future<Map<String, dynamic>> getQueueStats();
  Future<List<QueueEntity>> getPopularQueues({int limit = 10});
  Future<Map<QueueType, int>> getQueueCountByType();

  // 🔄 실시간 업데이트 관련
  Stream<List<QueueEntity>> watchQueues();
  Stream<List<ParticipantEntity>> watchParticipants(String queueId);
  Stream<ParticipantEntity?> watchMyParticipation(String queueId, String userId);

  // 🧹 캐시 관리
  Future<void> refreshCache();
  void clearCache();
}