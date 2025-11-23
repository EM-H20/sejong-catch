import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_item.freezed.dart';
part 'queue_item.g.dart';

/// 큐 아이템 모델
///
/// 축제/행사 큐 정보를 나타냅니다.
/// API 응답을 역직렬화하거나 더미 데이터를 생성할 때 사용합니다.
@freezed
class QueueItem with _$QueueItem {
  const factory QueueItem({
    required String id,
    required String name,
    required String type, // 'food', 'drink', 'game', 'photo', 'other'
    required String status, // 'active', 'paused', 'full'
    required int waiting, // 대기 인원
    required int currentNumber, // 현재 순번
    required int avgWaitTime, // 평균 대기 시간(분)
  }) = _QueueItem;

  factory QueueItem.fromJson(Map<String, dynamic> json) =>
      _$QueueItemFromJson(json);
}

/// 큐 상태 Enum (타입 안전성 보장!)
enum QueueStatus {
  active, // 운영 중
  paused, // 일시 정지
  full, // 마감
}

/// 큐 타입 Enum
enum QueueType {
  food, // 🍗 음식
  drink, // 🍺 주점
  game, // 🎮 게임
  photo, // 📸 포토
  other, // 🎪 기타
}

/// QueueStatus 확장 메서드
extension QueueStatusX on QueueStatus {
  /// 한글 텍스트 반환
  String get text {
    switch (this) {
      case QueueStatus.active:
        return '운영중';
      case QueueStatus.paused:
        return '일시정지';
      case QueueStatus.full:
        return '마감';
    }
  }

  /// String → Enum 변환
  static QueueStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return QueueStatus.active;
      case 'paused':
        return QueueStatus.paused;
      case 'full':
        return QueueStatus.full;
      default:
        return QueueStatus.full; // 기본값: 마감
    }
  }
}

/// QueueType 확장 메서드
extension QueueTypeX on QueueType {
  /// 아이콘 + 이름 반환
  String get displayName {
    switch (this) {
      case QueueType.food:
        return '🍗 음식';
      case QueueType.drink:
        return '🍺 주점';
      case QueueType.game:
        return '🎮 게임';
      case QueueType.photo:
        return '📸 포토';
      case QueueType.other:
        return '🎪 기타';
    }
  }

  /// String → Enum 변환
  static QueueType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'food':
        return QueueType.food;
      case 'drink':
        return QueueType.drink;
      case 'game':
        return QueueType.game;
      case 'photo':
        return QueueType.photo;
      case 'other':
        return QueueType.other;
      default:
        return QueueType.other; // 기본값: 기타
    }
  }
}
