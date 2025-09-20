/// 🙋‍♂️ 참가자 도메인 엔티티
///
/// CLAUDE.md 원칙:
/// ✅ 순수 비즈니스 로직
/// ✅ 데이터 계층과 분리된 도메인 모델
/// ✅ Clean Architecture Domain 계층

import '../../../queue/data/models/participant_model.dart';

class ParticipantEntity {
  final String id;
  final String queueId;
  final String userId;
  final String userName;
  final int position;
  final ParticipantStatus status;
  final DateTime joinedAt;
  final DateTime updatedAt;
  final DateTime? calledAt;
  final DateTime? completedAt;
  final String? userPhone;
  final String? note;

  const ParticipantEntity({
    required this.id,
    required this.queueId,
    required this.userId,
    required this.userName,
    required this.position,
    required this.status,
    required this.joinedAt,
    required this.updatedAt,
    this.calledAt,
    this.completedAt,
    this.userPhone,
    this.note,
  });

  /// Data Model에서 Entity로 변환
  factory ParticipantEntity.fromModel(ParticipantModel model) {
    return ParticipantEntity(
      id: model.id,
      queueId: model.queueId,
      userId: model.userId,
      userName: model.userName,
      position: model.position,
      status: model.status,
      joinedAt: model.joinedAt,
      updatedAt: model.updatedAt,
      calledAt: model.calledAt,
      completedAt: model.completedAt,
      userPhone: model.userPhone,
      note: model.note,
    );
  }

  /// Entity에서 Data Model로 변환
  ParticipantModel toModel() {
    return ParticipantModel(
      id: id,
      queueId: queueId,
      userId: userId,
      userName: userName,
      position: position,
      status: status,
      joinedAt: joinedAt,
      updatedAt: updatedAt,
      calledAt: calledAt,
      completedAt: completedAt,
      userPhone: userPhone,
      note: note,
    );
  }

  /// 비즈니스 로직: 호출 대상 여부
  bool canBeCalled() {
    return status == ParticipantStatus.waiting;
  }

  /// 비즈니스 로직: 서비스 시작 가능 여부
  bool canStartService() {
    return status == ParticipantStatus.called;
  }

  /// 비즈니스 로직: 완료 처리 가능 여부
  bool canBeCompleted() {
    return status == ParticipantStatus.serving;
  }

  /// 비즈니스 로직: 취소 가능 여부
  bool canBeCancelled() {
    return status == ParticipantStatus.waiting ||
           status == ParticipantStatus.called;
  }

  /// 비즈니스 로직: 대기 시간 계산 (분 단위)
  int get waitingTimeMinutes {
    final now = DateTime.now();
    return now.difference(joinedAt).inMinutes;
  }

  /// 비즈니스 로직: 호출 후 경과 시간 (분 단위)
  int? get calledTimeMinutes {
    if (calledAt == null) return null;
    final now = DateTime.now();
    return now.difference(calledAt!).inMinutes;
  }

  /// 비즈니스 로직: 서비스 소요 시간 (분 단위)
  int? get serviceDurationMinutes {
    if (calledAt == null || completedAt == null) return null;
    return completedAt!.difference(calledAt!).inMinutes;
  }

  /// 비즈니스 로직: 호출 시간 초과 여부 (5분 이상)
  bool get isCallExpired {
    if (status != ParticipantStatus.called || calledAt == null) return false;
    final elapsed = DateTime.now().difference(calledAt!).inMinutes;
    return elapsed > 5; // 5분 초과시 호출 만료
  }

  /// 비즈니스 로직: 우선순위 점수 (낮을수록 높은 우선순위)
  int get priorityScore {
    switch (status) {
      case ParticipantStatus.called:
        return 1; // 최고 우선순위
      case ParticipantStatus.waiting:
        return position; // 순번이 우선순위
      case ParticipantStatus.serving:
        return 1000;
      case ParticipantStatus.completed:
      case ParticipantStatus.cancelled:
        return 9999; // 최저 우선순위
    }
  }

  /// 비즈니스 로직: 예상 호출 시간 계산
  DateTime? calculateEstimatedCallTime(int averageServiceTime) {
    if (status != ParticipantStatus.waiting) return null;
    if (position <= 1) return DateTime.now();

    final estimatedWaitMinutes = (position - 1) * averageServiceTime;
    return joinedAt.add(Duration(minutes: estimatedWaitMinutes));
  }

  /// 비즈니스 로직: 활성 상태 여부
  bool get isActive {
    return status == ParticipantStatus.waiting ||
           status == ParticipantStatus.called ||
           status == ParticipantStatus.serving;
  }

  /// 비즈니스 로직: 완료된 상태 여부
  bool get isFinished {
    return status == ParticipantStatus.completed ||
           status == ParticipantStatus.cancelled;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParticipantEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ParticipantEntity(id: $id, userName: $userName, position: $position, status: $status)';
  }
}