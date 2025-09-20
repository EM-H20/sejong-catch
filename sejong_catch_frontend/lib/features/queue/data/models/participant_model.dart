/// 🙋‍♂️ 큐 참가자 데이터 모델
///
/// CLAUDE.md 원칙:
/// ✅ 일반 Dart 클래스 사용 (Freezed 사용 안함)
/// ✅ copyWith 수동 구현으로 불변 상태 보장
/// ✅ Clean Architecture 데이터 계층

enum ParticipantStatus {
  waiting,    // 대기 중
  called,     // 호출됨
  serving,    // 서비스 중
  completed,  // 완료
  cancelled,  // 취소됨
}

class ParticipantModel {
  final String id;
  final String queueId;            // 소속 큐 ID
  final String userId;             // 사용자 ID
  final String userName;           // 사용자 이름
  final int position;              // 순번 (1, 2, 3...)
  final ParticipantStatus status;  // 참가자 상태
  final DateTime joinedAt;         // 줄서기 시간
  final DateTime updatedAt;        // 상태 업데이트 시간
  final DateTime? calledAt;        // 호출된 시간
  final DateTime? completedAt;     // 완료된 시간
  final String? userPhone;         // 사용자 연락처 (선택)
  final String? note;              // 특이사항/주문내용

  const ParticipantModel({
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

  /// copyWith 메서드 (불변 상태 변경)
  ParticipantModel copyWith({
    String? id,
    String? queueId,
    String? userId,
    String? userName,
    int? position,
    ParticipantStatus? status,
    DateTime? joinedAt,
    DateTime? updatedAt,
    DateTime? calledAt,
    DateTime? completedAt,
    String? userPhone,
    String? note,
  }) {
    return ParticipantModel(
      id: id ?? this.id,
      queueId: queueId ?? this.queueId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      position: position ?? this.position,
      status: status ?? this.status,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      calledAt: calledAt ?? this.calledAt,
      completedAt: completedAt ?? this.completedAt,
      userPhone: userPhone ?? this.userPhone,
      note: note,
    );
  }

  /// JSON 직렬화 (수동 구현)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'queueId': queueId,
      'userId': userId,
      'userName': userName,
      'position': position,
      'status': status.name,
      'joinedAt': joinedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'calledAt': calledAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'userPhone': userPhone,
      'note': note,
    };
  }

  /// JSON 역직렬화 (수동 구현)
  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as String,
      queueId: json['queueId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      position: json['position'] as int,
      status: ParticipantStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ParticipantStatus.waiting,
      ),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      calledAt: json['calledAt'] != null
          ? DateTime.parse(json['calledAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      userPhone: json['userPhone'] as String?,
      note: json['note'] as String?,
    );
  }

  /// 대기 시간 계산 (분 단위)
  int get waitingTimeMinutes {
    final now = DateTime.now();
    return now.difference(joinedAt).inMinutes;
  }

  /// 호출 후 경과 시간 (분 단위)
  int? get calledTimeMinutes {
    if (calledAt == null) return null;
    final now = DateTime.now();
    return now.difference(calledAt!).inMinutes;
  }

  /// 서비스 소요 시간 (분 단위)
  int? get serviceDurationMinutes {
    if (calledAt == null || completedAt == null) return null;
    return completedAt!.difference(calledAt!).inMinutes;
  }

  /// 활성 상태 여부 (대기 중이거나 호출됨)
  bool get isActive {
    return status == ParticipantStatus.waiting ||
           status == ParticipantStatus.called ||
           status == ParticipantStatus.serving;
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

  /// 비즈니스 로직: 호출 시간 초과 여부 (5분 이상)
  bool get isCallExpired {
    if (status != ParticipantStatus.called || calledAt == null) return false;
    final elapsed = DateTime.now().difference(calledAt!).inMinutes;
    return elapsed > 5; // 5분 초과시 호출 만료
  }

  /// 디버깅용 문자열
  @override
  String toString() {
    return 'ParticipantModel(id: $id, userName: $userName, position: $position, status: $status)';
  }

  /// 동등성 비교
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParticipantModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// 🚦 참가자 상태별 표시 확장
extension ParticipantStatusExtension on ParticipantStatus {
  String get displayName {
    switch (this) {
      case ParticipantStatus.waiting:
        return '대기중';
      case ParticipantStatus.called:
        return '호출됨';
      case ParticipantStatus.serving:
        return '서비스중';
      case ParticipantStatus.completed:
        return '완료';
      case ParticipantStatus.cancelled:
        return '취소됨';
    }
  }

  String get emoji {
    switch (this) {
      case ParticipantStatus.waiting:
        return '⏳';
      case ParticipantStatus.called:
        return '🔔';
      case ParticipantStatus.serving:
        return '⚡';
      case ParticipantStatus.completed:
        return '✅';
      case ParticipantStatus.cancelled:
        return '❌';
    }
  }

  bool get needsAttention {
    return this == ParticipantStatus.called;
  }

  bool get isInProgress {
    return this == ParticipantStatus.waiting ||
           this == ParticipantStatus.called ||
           this == ParticipantStatus.serving;
  }
}