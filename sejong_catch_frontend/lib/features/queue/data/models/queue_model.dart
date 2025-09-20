/// 🎪 축제/행사 큐 데이터 모델
///
/// CLAUDE.md 원칙:
/// ✅ 일반 Dart 클래스 사용 (Freezed 사용 안함)
/// ✅ copyWith 수동 구현으로 불변 상태 보장
/// ✅ Clean Architecture 데이터 계층

enum QueueType {
  food,    // 음식 부스 (치킨, 떡볶이 등)
  drink,   // 음료 부스 (주점, 카페 등)
  event,   // 공연/이벤트 (버스킹, 무대 등)
  game,    // 게임존 (VR, 콘솔 등)
  photo,   // 포토존 (인증샷, 사진 등)
  other,   // 기타
}

enum QueueStatus {
  active,   // 운영 중
  paused,   // 일시 중지
  full,     // 만원 (대기 마감)
  closed,   // 운영 종료
}

class QueueModel {
  final String id;
  final String title;              // "BBQ 치킨부스 🔥"
  final String description;        // 부스 설명
  final QueueType type;            // 큐 타입
  final String location;           // "중앙광장 A구역"
  final QueueStatus status;        // 큐 상태
  final String operatorId;         // 운영자 ID
  final String operatorName;       // "치킨왕 박사장"
  final int maxCapacity;           // 최대 수용 인원
  final int currentCount;          // 현재 대기 인원
  final int averageWaitTime;       // 평균 대기 시간 (분)
  final DateTime createdAt;        // 생성 시간
  final DateTime updatedAt;        // 수정 시간
  final DateTime startTime;        // 운영 시작 시간
  final DateTime endTime;          // 운영 종료 시간
  final String? imageUrl;          // 부스 이미지
  final String? notice;            // 실시간 공지사항

  const QueueModel({
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

  /// copyWith 메서드 (불변 상태 변경)
  QueueModel copyWith({
    String? id,
    String? title,
    String? description,
    QueueType? type,
    String? location,
    QueueStatus? status,
    String? operatorId,
    String? operatorName,
    int? maxCapacity,
    int? currentCount,
    int? averageWaitTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startTime,
    DateTime? endTime,
    String? imageUrl,
    String? notice,
  }) {
    return QueueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      location: location ?? this.location,
      status: status ?? this.status,
      operatorId: operatorId ?? this.operatorId,
      operatorName: operatorName ?? this.operatorName,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      currentCount: currentCount ?? this.currentCount,
      averageWaitTime: averageWaitTime ?? this.averageWaitTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      imageUrl: imageUrl ?? this.imageUrl,
      notice: notice,
    );
  }

  /// JSON 직렬화 (수동 구현)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'location': location,
      'status': status.name,
      'operatorId': operatorId,
      'operatorName': operatorName,
      'maxCapacity': maxCapacity,
      'currentCount': currentCount,
      'averageWaitTime': averageWaitTime,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'imageUrl': imageUrl,
      'notice': notice,
    };
  }

  /// JSON 역직렬화 (수동 구현)
  factory QueueModel.fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: QueueType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QueueType.other,
      ),
      location: json['location'] as String,
      status: QueueStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QueueStatus.closed,
      ),
      operatorId: json['operatorId'] as String,
      operatorName: json['operatorName'] as String,
      maxCapacity: json['maxCapacity'] as int,
      currentCount: json['currentCount'] as int,
      averageWaitTime: json['averageWaitTime'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      imageUrl: json['imageUrl'] as String?,
      notice: json['notice'] as String?,
    );
  }

  /// 디버깅용 문자열
  @override
  String toString() {
    return 'QueueModel(id: $id, title: $title, status: $status, currentCount: $currentCount/$maxCapacity)';
  }

  /// 동등성 비교
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QueueModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 🎪 큐 타입별 이모지 확장
extension QueueTypeExtension on QueueType {
  String get emoji {
    switch (this) {
      case QueueType.food:
        return '🍗';
      case QueueType.drink:
        return '🍻';
      case QueueType.event:
        return '🎭';
      case QueueType.game:
        return '🎮';
      case QueueType.photo:
        return '📸';
      case QueueType.other:
        return '🎪';
    }
  }

  String get displayName {
    switch (this) {
      case QueueType.food:
        return '음식';
      case QueueType.drink:
        return '음료';
      case QueueType.event:
        return '공연';
      case QueueType.game:
        return '게임';
      case QueueType.photo:
        return '포토';
      case QueueType.other:
        return '기타';
    }
  }
}

/// 🚦 큐 상태별 컬러/텍스트 확장
extension QueueStatusExtension on QueueStatus {
  String get displayName {
    switch (this) {
      case QueueStatus.active:
        return '운영중';
      case QueueStatus.paused:
        return '일시중지';
      case QueueStatus.full:
        return '만원';
      case QueueStatus.closed:
        return '종료';
    }
  }

  bool get isJoinable {
    return this == QueueStatus.active;
  }

  bool get isOperational {
    return this == QueueStatus.active || this == QueueStatus.paused;
  }
}