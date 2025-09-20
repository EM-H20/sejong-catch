/// 🎪 큐 도메인 엔티티
///
/// CLAUDE.md 원칙:
/// ✅ 순수 비즈니스 로직
/// ✅ 데이터 계층과 분리된 도메인 모델
/// ✅ Clean Architecture Domain 계층

import '../../../queue/data/models/queue_model.dart';

class QueueEntity {
  final String id;
  final String title;
  final String description;
  final QueueType type;
  final String location;
  final QueueStatus status;
  final String operatorId;
  final String operatorName;
  final int maxCapacity;
  final int currentCount;
  final int averageWaitTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;
  final String? notice;

  const QueueEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    required this.status,
    required this.operatorId,
    required this.operatorName,
    required this.maxCapacity,
    required this.currentCount,
    required this.averageWaitTime,
    required this.createdAt,
    required this.updatedAt,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
    this.notice,
  });

  /// Data Model에서 Entity로 변환
  factory QueueEntity.fromModel(QueueModel model) {
    return QueueEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      type: model.type,
      location: model.location,
      status: model.status,
      operatorId: model.operatorId,
      operatorName: model.operatorName,
      maxCapacity: model.maxCapacity,
      currentCount: model.currentCount,
      averageWaitTime: model.averageWaitTime,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      startTime: model.startTime,
      endTime: model.endTime,
      imageUrl: model.imageUrl,
      notice: model.notice,
    );
  }

  /// Entity에서 Data Model로 변환
  QueueModel toModel() {
    return QueueModel(
      id: id,
      title: title,
      description: description,
      type: type,
      location: location,
      status: status,
      operatorId: operatorId,
      operatorName: operatorName,
      maxCapacity: maxCapacity,
      currentCount: currentCount,
      averageWaitTime: averageWaitTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
      startTime: startTime,
      endTime: endTime,
      imageUrl: imageUrl,
      notice: notice,
    );
  }

  /// 비즈니스 로직: 참여 가능 여부
  bool canJoin() {
    if (status != QueueStatus.active) return false;
    if (currentCount >= maxCapacity) return false;
    if (DateTime.now().isAfter(endTime)) return false;
    return true;
  }

  /// 비즈니스 로직: 운영 중 여부
  bool get isOperational {
    final now = DateTime.now();
    return status.isOperational &&
           now.isAfter(startTime) &&
           now.isBefore(endTime);
  }

  /// 비즈니스 로직: 만원 여부
  bool get isFull {
    return currentCount >= maxCapacity;
  }

  /// 비즈니스 로직: 대기율 계산 (0.0 ~ 1.0)
  double get occupancyRate {
    if (maxCapacity == 0) return 0.0;
    return currentCount / maxCapacity;
  }

  /// 비즈니스 로직: 예상 대기 시간 계산
  int calculateEstimatedWaitTime(int position) {
    if (position <= 0) return 0;
    return averageWaitTime * position;
  }

  /// 비즈니스 로직: 운영 종료까지 남은 시간 (분)
  int get minutesUntilEnd {
    final now = DateTime.now();
    if (now.isAfter(endTime)) return 0;
    return endTime.difference(now).inMinutes;
  }

  /// 비즈니스 로직: 인기도 점수 (대기자 수 + 평균 대기 시간 고려)
  double get popularityScore {
    // 대기자가 많고 평균 대기시간이 적을수록 인기있는 큐
    if (averageWaitTime == 0) return currentCount.toDouble();
    return currentCount / (averageWaitTime / 10);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QueueEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'QueueEntity(id: $id, title: $title, status: $status, occupancy: $currentCount/$maxCapacity)';
  }
}