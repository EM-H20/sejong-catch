/// 알림 설정 모델 (세종 캐치 맞춤형)
class NotificationSettings {
  // 정보 타입별 알림 설정
  final bool contestAlerts;         // 공모전 마감 알림
  final bool jobAlerts;            // 취업 정보 알림
  final bool scholarshipAlerts;    // 장학금 정보 알림
  final bool academicAlerts;       // 학술/연구 정보 알림
  final bool festivalAlerts;       // 축제/행사 알림
  final bool queueAlerts;          // 줄서기 순번 알림

  // 알림 타이밍 설정
  final DeadlineNotificationTiming deadlineNotification; // 마감 알림 시점
  final bool immediateAlerts;      // 즉시 알림 (새 정보 등록 시)
  final bool dailyDigest;          // 일일 요약 알림

  // 알림 방식 설정
  final bool pushNotifications;    // 푸시 알림
  final bool vibration;           // 진동
  final bool sound;               // 알림음
  final NotificationSound soundType; // 알림음 종류

  // 시간대 설정
  final int quietHoursStart;       // 방해금지 시작 시간 (24시간 형식)
  final int quietHoursEnd;         // 방해금지 종료 시간
  final bool weekendAlerts;        // 주말 알림 허용

  const NotificationSettings({
    this.contestAlerts = true,
    this.jobAlerts = true,
    this.scholarshipAlerts = true,
    this.academicAlerts = false,
    this.festivalAlerts = true,
    this.queueAlerts = true,
    this.deadlineNotification = DeadlineNotificationTiming.threeDays,
    this.immediateAlerts = false,
    this.dailyDigest = true,
    this.pushNotifications = true,
    this.vibration = true,
    this.sound = true,
    this.soundType = NotificationSound.gentle,
    this.quietHoursStart = 22, // 오후 10시
    this.quietHoursEnd = 8,    // 오전 8시
    this.weekendAlerts = false,
  });

  NotificationSettings copyWith({
    bool? contestAlerts,
    bool? jobAlerts,
    bool? scholarshipAlerts,
    bool? academicAlerts,
    bool? festivalAlerts,
    bool? queueAlerts,
    DeadlineNotificationTiming? deadlineNotification,
    bool? immediateAlerts,
    bool? dailyDigest,
    bool? pushNotifications,
    bool? vibration,
    bool? sound,
    NotificationSound? soundType,
    int? quietHoursStart,
    int? quietHoursEnd,
    bool? weekendAlerts,
  }) {
    return NotificationSettings(
      contestAlerts: contestAlerts ?? this.contestAlerts,
      jobAlerts: jobAlerts ?? this.jobAlerts,
      scholarshipAlerts: scholarshipAlerts ?? this.scholarshipAlerts,
      academicAlerts: academicAlerts ?? this.academicAlerts,
      festivalAlerts: festivalAlerts ?? this.festivalAlerts,
      queueAlerts: queueAlerts ?? this.queueAlerts,
      deadlineNotification: deadlineNotification ?? this.deadlineNotification,
      immediateAlerts: immediateAlerts ?? this.immediateAlerts,
      dailyDigest: dailyDigest ?? this.dailyDigest,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      vibration: vibration ?? this.vibration,
      sound: sound ?? this.sound,
      soundType: soundType ?? this.soundType,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      weekendAlerts: weekendAlerts ?? this.weekendAlerts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettings &&
          runtimeType == other.runtimeType &&
          contestAlerts == other.contestAlerts &&
          jobAlerts == other.jobAlerts &&
          scholarshipAlerts == other.scholarshipAlerts &&
          academicAlerts == other.academicAlerts &&
          festivalAlerts == other.festivalAlerts &&
          queueAlerts == other.queueAlerts &&
          deadlineNotification == other.deadlineNotification &&
          immediateAlerts == other.immediateAlerts &&
          dailyDigest == other.dailyDigest &&
          pushNotifications == other.pushNotifications &&
          vibration == other.vibration &&
          sound == other.sound &&
          soundType == other.soundType &&
          quietHoursStart == other.quietHoursStart &&
          quietHoursEnd == other.quietHoursEnd &&
          weekendAlerts == other.weekendAlerts;

  @override
  int get hashCode =>
      contestAlerts.hashCode ^
      jobAlerts.hashCode ^
      scholarshipAlerts.hashCode ^
      academicAlerts.hashCode ^
      festivalAlerts.hashCode ^
      queueAlerts.hashCode ^
      deadlineNotification.hashCode ^
      immediateAlerts.hashCode ^
      dailyDigest.hashCode ^
      pushNotifications.hashCode ^
      vibration.hashCode ^
      sound.hashCode ^
      soundType.hashCode ^
      quietHoursStart.hashCode ^
      quietHoursEnd.hashCode ^
      weekendAlerts.hashCode;

  @override
  String toString() =>
      'NotificationSettings(contestAlerts: $contestAlerts, jobAlerts: $jobAlerts, ...)';

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'contestAlerts': contestAlerts,
      'jobAlerts': jobAlerts,
      'scholarshipAlerts': scholarshipAlerts,
      'academicAlerts': academicAlerts,
      'festivalAlerts': festivalAlerts,
      'queueAlerts': queueAlerts,
      'deadlineNotification': deadlineNotification.name,
      'immediateAlerts': immediateAlerts,
      'dailyDigest': dailyDigest,
      'pushNotifications': pushNotifications,
      'vibration': vibration,
      'sound': sound,
      'soundType': soundType.name,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'weekendAlerts': weekendAlerts,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      contestAlerts: json['contestAlerts'] ?? true,
      jobAlerts: json['jobAlerts'] ?? true,
      scholarshipAlerts: json['scholarshipAlerts'] ?? true,
      academicAlerts: json['academicAlerts'] ?? false,
      festivalAlerts: json['festivalAlerts'] ?? true,
      queueAlerts: json['queueAlerts'] ?? true,
      deadlineNotification: DeadlineNotificationTiming.values.firstWhere(
        (e) => e.name == json['deadlineNotification'],
        orElse: () => DeadlineNotificationTiming.threeDays,
      ),
      immediateAlerts: json['immediateAlerts'] ?? false,
      dailyDigest: json['dailyDigest'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      vibration: json['vibration'] ?? true,
      sound: json['sound'] ?? true,
      soundType: NotificationSound.values.firstWhere(
        (e) => e.name == json['soundType'],
        orElse: () => NotificationSound.gentle,
      ),
      quietHoursStart: json['quietHoursStart'] ?? 22,
      quietHoursEnd: json['quietHoursEnd'] ?? 8,
      weekendAlerts: json['weekendAlerts'] ?? false,
    );
  }

  // 개발자 친화적 헬퍼 메서드들
  bool get hasAnyAlerts =>
      contestAlerts ||
      jobAlerts ||
      scholarshipAlerts ||
      academicAlerts ||
      festivalAlerts ||
      queueAlerts;

  bool get isInQuietHours {
    final now = DateTime.now();
    final currentHour = now.hour;

    if (quietHoursStart < quietHoursEnd) {
      // 일반적인 경우: 22시~8시
      return false;
    } else {
      // 자정을 넘나드는 경우: 22시~다음날 8시
      return currentHour >= quietHoursStart || currentHour < quietHoursEnd;
    }
  }

  bool get shouldShowWeekendAlerts =>
      weekendAlerts || ![DateTime.saturday, DateTime.sunday].contains(DateTime.now().weekday);

  /// 추천 설정 (신입생용)
  static const NotificationSettings recommended = NotificationSettings(
    contestAlerts: true,
    jobAlerts: true,
    scholarshipAlerts: true,
    academicAlerts: false, // 초기에는 부담스러울 수 있음
    festivalAlerts: true,
    queueAlerts: true,
    deadlineNotification: DeadlineNotificationTiming.threeDays,
    immediateAlerts: false, // 너무 많은 알림 방지
    dailyDigest: true,
    weekendAlerts: false, // 휴식 시간 보장
  );

  /// 최소 설정 (알림 부담을 덜고 싶은 사용자용)
  static const NotificationSettings minimal = NotificationSettings(
    contestAlerts: false,
    jobAlerts: true, // 취업 정보만은 놓치지 않도록
    scholarshipAlerts: true, // 장학금도 중요
    academicAlerts: false,
    festivalAlerts: false,
    queueAlerts: true, // 줄서기는 실시간성이 중요
    deadlineNotification: DeadlineNotificationTiming.oneWeek,
    immediateAlerts: false,
    dailyDigest: false,
    weekendAlerts: false,
  );
}

/// 마감 알림 시점
enum DeadlineNotificationTiming {
  oneDay('1일 전', 1),
  threeDays('3일 전', 3),
  oneWeek('1주일 전', 7),
  twoWeeks('2주일 전', 14),
  never('알림 안함', 0);

  const DeadlineNotificationTiming(this.displayName, this.days);

  final String displayName;
  final int days;
}

/// 알림음 종류
enum NotificationSound {
  gentle('부드러운 소리', 'notification_gentle.mp3'),
  cheerful('경쾌한 소리', 'notification_cheerful.mp3'),
  urgent('긴급 소리', 'notification_urgent.mp3'),
  silent('무음', null);

  const NotificationSound(this.displayName, this.fileName);

  final String displayName;
  final String? fileName;
}

/// 알림 권한 상태
enum NotificationPermissionStatus {
  granted('허용됨'),
  denied('거부됨'),
  restricted('제한됨'),
  unknown('알 수 없음');

  const NotificationPermissionStatus(this.displayName);

  final String displayName;
}