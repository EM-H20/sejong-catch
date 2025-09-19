/// 📰 피드 아이템 모델
///
/// 공모전, 취업, 논문, 공지사항 등 모든 정보를 담는 핵심 모델입니다.
/// Freezed 없이 일반 Dart 클래스로 구현하여 완벽한 불변성과 타입 안전성 보장!
class FeedItem {
  /// 고유 ID
  final String id;

  /// 제목
  final String title;

  /// 설명/부제목
  final String? subtitle;

  /// 카테고리
  final String category;

  /// 마감일
  final DateTime? deadline;

  /// 신뢰도 레벨 (official, academic, press, community)
  final String trustLevel;

  /// 우선순위 레벨 (high, mid, low)
  final String priority;

  /// 썸네일 이미지 URL
  final String? thumbnailUrl;

  /// 출처 로고 URL
  final String? sourceLogoUrl;

  /// 출처 도메인명
  final String sourceDomain;

  /// 원본 URL
  final String sourceUrl;

  /// 생성일시
  final DateTime createdAt;

  /// 수정일시
  final DateTime? updatedAt;

  /// 조회수
  final int viewCount;

  /// 북마크 수
  final int bookmarkCount;

  /// 추천 점수 (개인화 알고리즘용)
  final double recommendationScore;

  /// 태그 리스트
  final List<String> tags;

  /// 관련 학과
  final List<String> relatedDepartments;

  /// 만료 여부
  final bool isExpired;

  /// HOT, TREND, NEW 같은 상태 배지
  final List<String> badges;

  const FeedItem({
    required this.id,
    required this.title,
    this.subtitle,
    required this.category,
    this.deadline,
    required this.trustLevel,
    required this.priority,
    this.thumbnailUrl,
    this.sourceLogoUrl,
    required this.sourceDomain,
    required this.sourceUrl,
    required this.createdAt,
    this.updatedAt,
    this.viewCount = 0,
    this.bookmarkCount = 0,
    this.recommendationScore = 0.0,
    this.tags = const [],
    this.relatedDepartments = const [],
    this.isExpired = false,
    this.badges = const [],
  });

  /// copyWith 메서드 - Freezed 없이 불변성 보장!
  FeedItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    DateTime? deadline,
    String? trustLevel,
    String? priority,
    String? thumbnailUrl,
    String? sourceLogoUrl,
    String? sourceDomain,
    String? sourceUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? viewCount,
    int? bookmarkCount,
    double? recommendationScore,
    List<String>? tags,
    List<String>? relatedDepartments,
    bool? isExpired,
    List<String>? badges,
  }) {
    return FeedItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      deadline: deadline ?? this.deadline,
      trustLevel: trustLevel ?? this.trustLevel,
      priority: priority ?? this.priority,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      sourceLogoUrl: sourceLogoUrl ?? this.sourceLogoUrl,
      sourceDomain: sourceDomain ?? this.sourceDomain,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewCount: viewCount ?? this.viewCount,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      recommendationScore: recommendationScore ?? this.recommendationScore,
      tags: tags ?? this.tags,
      relatedDepartments: relatedDepartments ?? this.relatedDepartments,
      isExpired: isExpired ?? this.isExpired,
      badges: badges ?? this.badges,
    );
  }

  /// JSON으로부터 생성
  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      category: json['category'] as String,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      trustLevel: json['trustLevel'] as String? ?? 'community',
      priority: json['priority'] as String? ?? 'low',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      sourceLogoUrl: json['sourceLogoUrl'] as String?,
      sourceDomain: json['sourceDomain'] as String,
      sourceUrl: json['sourceUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      viewCount: json['viewCount'] as int? ?? 0,
      bookmarkCount: json['bookmarkCount'] as int? ?? 0,
      recommendationScore: (json['recommendationScore'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      relatedDepartments: (json['relatedDepartments'] as List<dynamic>?)?.cast<String>() ?? [],
      isExpired: json['isExpired'] as bool? ?? false,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'deadline': deadline?.toIso8601String(),
      'trustLevel': trustLevel,
      'priority': priority,
      'thumbnailUrl': thumbnailUrl,
      'sourceLogoUrl': sourceLogoUrl,
      'sourceDomain': sourceDomain,
      'sourceUrl': sourceUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'viewCount': viewCount,
      'bookmarkCount': bookmarkCount,
      'recommendationScore': recommendationScore,
      'tags': tags,
      'relatedDepartments': relatedDepartments,
      'isExpired': isExpired,
      'badges': badges,
    };
  }

  /// 마감까지 남은 일수 계산
  int? get daysUntilDeadline {
    if (deadline == null) return null;

    final now = DateTime.now();
    final difference = deadline!.difference(now);
    return difference.inDays;
  }

  /// 마감 임박 여부 (D-3 이하)
  bool get isDeadlineUrgent {
    final days = daysUntilDeadline;
    return days != null && days <= 3 && days >= 0;
  }

  /// 새로운 아이템 여부 (24시간 이내)
  bool get isNew {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours <= 24;
  }

  /// 인기 아이템 여부 (높은 조회수 + 북마크)
  bool get isPopular {
    return viewCount >= 100 || bookmarkCount >= 10;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FeedItem(id: $id, title: $title, category: $category)';
  }
}