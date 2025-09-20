/// 🗂️ 큐 로컬 데이터 소스 (Mock 데이터)
///
/// CLAUDE.md 원칙:
/// ✅ 기존 Mock 데이터 활용
/// ✅ Clean Architecture 데이터 계층
/// ✅ 실제 축제 시나리오 반영

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/queue_model.dart';
import '../models/participant_model.dart';

class QueueLocalDatasource {
  static QueueLocalDatasource? _instance;
  QueueLocalDatasource._();

  factory QueueLocalDatasource() {
    return _instance ??= QueueLocalDatasource._();
  }

  List<QueueModel>? _cachedQueues;
  List<ParticipantModel>? _cachedParticipants;

  /// 모든 큐 데이터 로드
  Future<List<QueueModel>> getQueues() async {
    if (_cachedQueues != null) return _cachedQueues!;

    try {
      final String response = await rootBundle.loadString('assets/mock_data/queues.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> queuesJson = data['queues'];

      _cachedQueues = queuesJson.map((json) => QueueModel.fromJson(json)).toList();
      return _cachedQueues!;
    } catch (e) {
      // Mock 데이터 로드 실패 시 기본 데이터 반환
      return _getDefaultQueues();
    }
  }

  /// 모든 참가자 데이터 로드
  Future<List<ParticipantModel>> getParticipants() async {
    if (_cachedParticipants != null) return _cachedParticipants!;

    try {
      final String response = await rootBundle.loadString('assets/mock_data/queue_participants.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> participantsJson = data['participants'];

      _cachedParticipants = participantsJson.map((json) => ParticipantModel.fromJson(json)).toList();
      return _cachedParticipants!;
    } catch (e) {
      // Mock 데이터 로드 실패 시 기본 데이터 반환
      return _getDefaultParticipants();
    }
  }

  /// 활성 큐만 필터링
  Future<List<QueueModel>> getActiveQueues() async {
    final queues = await getQueues();
    return queues.where((queue) => queue.status.isOperational).toList();
  }

  /// 특정 큐의 참가자들
  Future<List<ParticipantModel>> getParticipantsByQueueId(String queueId) async {
    final participants = await getParticipants();
    return participants
        .where((p) => p.queueId == queueId && p.isActive)
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  /// 특정 사용자의 참여 목록
  Future<List<ParticipantModel>> getParticipationsByUserId(String userId) async {
    final participants = await getParticipants();
    return participants
        .where((p) => p.userId == userId && p.isActive)
        .toList()
      ..sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
  }

  /// 큐에 참여하기 (Mock)
  Future<ParticipantModel> joinQueue({
    required String queueId,
    required String userId,
    required String userName,
    String? note,
  }) async {
    final participants = await getParticipantsByQueueId(queueId);
    final nextPosition = participants.isEmpty ? 1 : participants.last.position + 1;

    final newParticipant = ParticipantModel(
      id: 'participant_${DateTime.now().millisecondsSinceEpoch}',
      queueId: queueId,
      userId: userId,
      userName: userName,
      position: nextPosition,
      status: ParticipantStatus.waiting,
      joinedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      note: note,
    );

    // 캐시 업데이트
    _cachedParticipants?.add(newParticipant);

    return newParticipant;
  }

  /// 큐에서 나가기 (Mock)
  Future<void> leaveQueue(String participantId) async {
    if (_cachedParticipants == null) await getParticipants();

    final index = _cachedParticipants!.indexWhere((p) => p.id == participantId);
    if (index != -1) {
      _cachedParticipants![index] = _cachedParticipants![index].copyWith(
        status: ParticipantStatus.cancelled,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// 참가자 호출 (운영자용)
  Future<void> callParticipant(String participantId) async {
    if (_cachedParticipants == null) await getParticipants();

    final index = _cachedParticipants!.indexWhere((p) => p.id == participantId);
    if (index != -1) {
      _cachedParticipants![index] = _cachedParticipants![index].copyWith(
        status: ParticipantStatus.called,
        calledAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// 참가자 완료 처리 (운영자용)
  Future<void> completeParticipant(String participantId) async {
    if (_cachedParticipants == null) await getParticipants();

    final index = _cachedParticipants!.indexWhere((p) => p.id == participantId);
    if (index != -1) {
      _cachedParticipants![index] = _cachedParticipants![index].copyWith(
        status: ParticipantStatus.completed,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  /// 큐 상태 업데이트 (운영자용)
  Future<void> updateQueueStatus(String queueId, QueueStatus status) async {
    if (_cachedQueues == null) await getQueues();

    final index = _cachedQueues!.indexWhere((q) => q.id == queueId);
    if (index != -1) {
      _cachedQueues![index] = _cachedQueues![index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// 캐시 초기화
  void clearCache() {
    _cachedQueues = null;
    _cachedParticipants = null;
  }

  /// 기본 큐 데이터 (Fallback)
  List<QueueModel> _getDefaultQueues() {
    final now = DateTime.now();
    return [
      QueueModel(
        id: 'queue_chicken_demo',
        title: 'BBQ 치킨부스 🔥',
        description: '갓-갓 치킨! 바싹바싹 맛있어요. 현재 뿌링클, 황금올리브 준비되어 있습니다.',
        type: QueueType.food,
        location: '중앙광장 A구역',
        status: QueueStatus.active,
        operatorId: 'operator_demo',
        operatorName: '치킨왕 박사장',
        maxCapacity: 50,
        currentCount: 12,
        averageWaitTime: 8,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now,
        startTime: now.subtract(const Duration(hours: 1)),
        endTime: now.add(const Duration(hours: 8)),
      ),
      QueueModel(
        id: 'queue_game_demo',
        title: '게이밍존 체험 🎮',
        description: '최신 PS5, 닌텐도 스위치, VR 체험까지! 게이머들의 천국입니다.',
        type: QueueType.game,
        location: 'IT관 1층 로비',
        status: QueueStatus.active,
        operatorId: 'operator_demo2',
        operatorName: '게임동아리 박겜덕',
        maxCapacity: 12,
        currentCount: 8,
        averageWaitTime: 15,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now,
        startTime: now,
        endTime: now.add(const Duration(hours: 6)),
      ),
    ];
  }

  /// 기본 참가자 데이터 (Fallback)
  List<ParticipantModel> _getDefaultParticipants() {
    final now = DateTime.now();
    return [
      ParticipantModel(
        id: 'participant_demo_1',
        queueId: 'queue_chicken_demo',
        userId: 'user_demo',
        userName: '홍길동',
        position: 5,
        status: ParticipantStatus.waiting,
        joinedAt: now.subtract(const Duration(minutes: 15)),
        updatedAt: now.subtract(const Duration(minutes: 15)),
        note: '뿌링클 2마리 주문',
      ),
    ];
  }
}