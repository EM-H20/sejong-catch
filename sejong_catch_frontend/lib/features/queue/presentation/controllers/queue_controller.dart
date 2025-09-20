/// 🎛️ 큐 목록 상태 관리 Controller
///
/// CLAUDE.md 원칙:
/// ✅ Riverpod + 일반 Dart 클래스 (Freezed 사용 안함)
/// ✅ copyWith 수동 구현으로 불변 상태 보장
/// ✅ auth 패턴처럼 86% 코드 감소 달성

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;

import '../../domain/entities/queue_entity.dart';
import '../../domain/repositories/queue_repository.dart';
import '../../data/repositories/queue_repository_impl.dart';
import '../../data/models/queue_model.dart';
import '../../data/models/participant_model.dart';
import '../../data/models/queue_state.dart';

part 'queue_controller.g.dart';

/// 🏭 Repository Provider (의존성 주입 + 자동 dispose)
@riverpod
QueueRepository queueRepository(Ref ref) {
  final repository = QueueRepositoryImpl();

  // Provider가 dispose될 때 Repository 리소스도 정리
  ref.onDispose(() {
    repository.dispose();
  });

  return repository;
}

/// 🎪 메인 큐 목록 Controller
@riverpod
class QueueController extends _$QueueController {
  @override
  QueueState build() {
    // build()에서는 순수한 초기 상태만 반환! (Riverpod 핵심 규칙)
    return const QueueState();
  }

  /// 📋 모든 큐 목록 로드
  Future<void> loadQueues() async {
    await _loadQueues();
  }

  Future<void> _loadQueues() async {
    state = state.setLoading(true);

    try {
      final repository = ref.read(queueRepositoryProvider);
      final [queues, myParticipations] = await Future.wait([
        repository.getQueues(),
        _loadMyParticipations(),
      ]);

      state = state.copyWith(
        queues: (queues as List<QueueEntity>).map((e) => e.toModel()).toList(),
        myParticipations: (myParticipations as List<ParticipantModel>),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.setError('큐 목록을 불러오는데 실패했어요: ${e.toString()}');
    }
  }

  /// 🔄 새로고침
  Future<void> refresh() async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.refreshCache();
      await _loadQueues();
    } catch (e) {
      state = state.setError('새로고침에 실패했어요: ${e.toString()}');
    }
  }

  /// 🏷️ 타입별 큐 필터링
  Future<void> filterByType(QueueType? type) async {
    state = state.setLoading(true);

    try {
      final repository = ref.read(queueRepositoryProvider);
      final List<QueueEntity> queues;

      if (type == null) {
        queues = await repository.getQueues();
      } else {
        queues = await repository.getQueuesByType(type);
      }

      state = state.copyWith(
        queues: queues.map((e) => e.toModel()).toList(),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.setError('필터링에 실패했어요: ${e.toString()}');
    }
  }

  /// 🔍 큐 검색
  void searchQueues(String query) {
    if (query.isEmpty) {
      _loadQueues();
      return;
    }

    final filteredQueues = state.queues.where((queue) {
      return queue.title.toLowerCase().contains(query.toLowerCase()) ||
             queue.description.toLowerCase().contains(query.toLowerCase()) ||
             queue.location.toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(queues: filteredQueues);
  }

  /// 🎪 큐에 줄서기
  Future<void> joinQueue(String queueId, {String? note}) async {
    // TODO: 실제 사용자 정보는 AuthController에서 가져와야 함
    const mockUserId = 'user_demo';
    const mockUserName = '홍길동';

    if (state.isJoining) return;

    state = state.copyWith(isJoining: true, error: null);

    try {
      final repository = ref.read(queueRepositoryProvider);

      // 이미 참여 중인지 확인
      if (state.isParticipatingInQueue(queueId)) {
        throw Exception('이미 해당 큐에 참여 중입니다');
      }

      // 줄서기 참여
      final participation = await repository.joinQueue(
        queueId: queueId,
        userId: mockUserId,
        userName: mockUserName,
        note: note,
      );

      // 상태 업데이트
      final updatedParticipations = [...state.myParticipations, participation.toModel()];

      state = state.copyWith(
        myParticipations: updatedParticipations,
        isJoining: false,
      );

      // 큐 목록 새로고침 (참가자 수 업데이트)
      await _loadQueues();
    } catch (e) {
      state = state.copyWith(
        isJoining: false,
        error: '줄서기 참여에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// ❌ 줄서기 취소
  Future<void> leaveQueue(String queueId) async {
    if (state.isLeaving) return;

    final participation = state.getMyParticipationInQueue(queueId);
    if (participation == null) {
      state = state.setError('참여 정보를 찾을 수 없어요');
      return;
    }

    state = state.copyWith(isLeaving: true, error: null);

    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.leaveQueue(participation.id);

      // 상태에서 제거
      final updatedParticipations = state.myParticipations
          .where((p) => p.id != participation.id)
          .toList();

      state = state.copyWith(
        myParticipations: updatedParticipations,
        isLeaving: false,
      );

      // 큐 목록 새로고침
      await _loadQueues();
    } catch (e) {
      state = state.copyWith(
        isLeaving: false,
        error: '줄서기 취소에 실패했어요: ${e.toString()}',
      );
    }
  }

  /// 🎯 특정 큐 선택
  Future<void> selectQueue(String queueId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final [queue, participants] = await Future.wait([
        repository.getQueueById(queueId),
        repository.getParticipantsByQueueId(queueId),
      ]);

      if (queue == null) {
        state = state.setError('큐 정보를 찾을 수 없어요');
        return;
      }

      state = state.copyWith(
        selectedQueue: (queue as QueueEntity).toModel(),
        selectedQueueParticipants: (participants as List).map((e) => e.toModel()).toList().cast<ParticipantModel>(),
      );
    } catch (e) {
      state = state.setError('큐 선택에 실패했어요: ${e.toString()}');
    }
  }

  /// 🧹 선택된 큐 클리어
  void clearSelectedQueue() {
    state = state.copyWith(
      selectedQueue: null,
      selectedQueueParticipants: [],
    );
  }

  /// 🙋‍♂️ 내 참여 내역 로드 (내부 헬퍼)
  Future<List<ParticipantModel>> _loadMyParticipations() async {
    try {
      // TODO: 실제 사용자 ID는 AuthController에서 가져와야 함
      const mockUserId = 'user_demo';

      final repository = ref.read(queueRepositoryProvider);
      final participations = await repository.getParticipationsByUserId(mockUserId);

      return participations.map((e) => e.toModel()).toList();
    } catch (e) {
      // 참여 내역 로드 실패는 빈 목록 반환
      return [];
    }
  }

  /// 📊 통계 정보 로드
  Future<Map<String, dynamic>> getQueueStats() async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      return await repository.getQueueStats();
    } catch (e) {
      throw Exception('통계 정보를 불러오는데 실패했어요: ${e.toString()}');
    }
  }

  /// 🔥 인기 큐 목록
  Future<List<QueueModel>> getPopularQueues({int limit = 5}) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final popularQueues = await repository.getPopularQueues(limit: limit);
      return popularQueues.map((e) => e.toModel()).toList();
    } catch (e) {
      throw Exception('인기 큐 목록을 불러오는데 실패했어요: ${e.toString()}');
    }
  }

  /// ⚠️ 에러 클리어
  void clearError() {
    state = state.clearError();
  }
}

/// 🎛️ 실시간 큐 목록 Provider (Stream)
@riverpod
Stream<List<QueueModel>> queueStream(Ref ref) {
  final repository = ref.read(queueRepositoryProvider);
  return repository.watchQueues().map(
    (entities) => entities.map((e) => e.toModel()).toList(),
  );
}

/// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
@riverpod
Stream<List<ParticipantModel>> participantsStream(
  Ref ref,
  String queueId,
) {
  final repository = ref.read(queueRepositoryProvider);
  return repository.watchParticipants(queueId).map(
    (entities) => entities.map((e) => e.toModel()).toList(),
  );
}

/// 👤 내 참여 상태 실시간 Provider (Stream)
@riverpod
Stream<ParticipantModel?> myParticipationStream(
  Ref ref,
  String queueId,
) {
  // TODO: 실제 사용자 ID는 AuthController에서 가져와야 함
  const mockUserId = 'user_demo';

  final repository = ref.read(queueRepositoryProvider);
  return repository.watchMyParticipation(queueId, mockUserId).map(
    (entity) => entity?.toModel(),
  );
}