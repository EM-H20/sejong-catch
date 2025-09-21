import 'package:flutter/material.dart';

/// 세종대학교 학과 정보 모델
class Major {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final MajorCategory category;
  final List<String> keywords; // 검색용 키워드

  const Major({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.keywords,
  });

  Major copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    MajorCategory? category,
    List<String>? keywords,
  }) {
    return Major(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Major && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Major(id: $id, name: $name)';

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon.codePoint,
      'category': category.name,
      'keywords': keywords,
    };
  }

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      category: MajorCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      keywords: List<String>.from(json['keywords']),
    );
  }
}

/// 학과 카테고리 분류
enum MajorCategory {
  engineering('공학계열', Icons.engineering, Color(0xFF3B82F6)),
  business('경영계열', Icons.business_center, Color(0xFF10B981)),
  humanities('인문계열', Icons.menu_book, Color(0xFF8B5CF6)),
  social('사회계열', Icons.people, Color(0xFFF59E0B)),
  arts('예술계열', Icons.palette, Color(0xFFEF4444)),
  science('자연계열', Icons.science, Color(0xFF06B6D4)),
  etc('기타', Icons.more_horiz, Color(0xFF6B7280));

  const MajorCategory(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;
}

/// 세종대학교 주요 학과 목록 (실제 데이터)
class MajorData {
  static final List<Major> allMajors = [
    // 공학계열
    const Major(
      id: 'computer_engineering',
      name: '컴퓨터공학과',
      description: 'AI, 소프트웨어, 시스템 전문가',
      icon: Icons.computer,
      category: MajorCategory.engineering,
      keywords: ['컴공', 'CS', '프로그래밍', 'AI', '소프트웨어'],
    ),
    const Major(
      id: 'software_engineering',
      name: '소프트웨어학과',
      description: '소프트웨어 개발 및 설계 전문',
      icon: Icons.code,
      category: MajorCategory.engineering,
      keywords: ['소프트웨어', '개발', '코딩', '앱', '웹'],
    ),
    const Major(
      id: 'data_science',
      name: '데이터사이언스학과',
      description: '빅데이터 분석 및 AI 활용',
      icon: Icons.analytics,
      category: MajorCategory.engineering,
      keywords: ['데이터', '빅데이터', '분석', '통계', '머신러닝'],
    ),
    const Major(
      id: 'electronic_engineering',
      name: '전자정보통신공학과',
      description: '통신, 전자기기, IoT 전문',
      icon: Icons.electrical_services,
      category: MajorCategory.engineering,
      keywords: ['전자', '통신', 'IoT', '반도체', '하드웨어'],
    ),

    // 경영계열
    const Major(
      id: 'business_administration',
      name: '경영학과',
      description: '경영전략, 마케팅, 재무 관리',
      icon: Icons.business,
      category: MajorCategory.business,
      keywords: ['경영', '마케팅', '재무', '전략', '경영학'],
    ),
    const Major(
      id: 'economics',
      name: '경제학과',
      description: '경제이론 및 정책 분석',
      icon: Icons.trending_up,
      category: MajorCategory.business,
      keywords: ['경제', '정책', '금융', '투자', '분석'],
    ),

    // 인문계열
    const Major(
      id: 'korean_language',
      name: '국어국문학과',
      description: '한국어문학 연구 및 교육',
      icon: Icons.language,
      category: MajorCategory.humanities,
      keywords: ['국문', '한국어', '문학', '언어', '글쓰기'],
    ),
    const Major(
      id: 'english_language',
      name: '영어영문학과',
      description: '영어문학 및 영어교육 전문',
      icon: Icons.translate,
      category: MajorCategory.humanities,
      keywords: ['영문', '영어', '번역', '통역', '문학'],
    ),

    // 사회계열
    const Major(
      id: 'psychology',
      name: '심리학과',
      description: '인간 심리 및 행동 분석',
      icon: Icons.psychology,
      category: MajorCategory.social,
      keywords: ['심리', '상담', '행동', '인지', '분석'],
    ),
    const Major(
      id: 'law',
      name: '법학과',
      description: '법률 및 사법기관 전문가',
      icon: Icons.gavel,
      category: MajorCategory.social,
      keywords: ['법학', '변호사', '법률', '사법', '정의'],
    ),

    // 예술계열
    const Major(
      id: 'design',
      name: '디자인학과',
      description: '시각, 제품, 공간 디자인',
      icon: Icons.design_services,
      category: MajorCategory.arts,
      keywords: ['디자인', '시각디자인', '제품', '그래픽', '창작'],
    ),
    const Major(
      id: 'music',
      name: '음악학과',
      description: '성악, 기악, 작곡 전문교육',
      icon: Icons.music_note,
      category: MajorCategory.arts,
      keywords: ['음악', '성악', '기악', '작곡', '연주'],
    ),

    // 자연계열
    const Major(
      id: 'mathematics',
      name: '수학과',
      description: '순수수학 및 응용수학 연구',
      icon: Icons.calculate,
      category: MajorCategory.science,
      keywords: ['수학', '통계', '확률', '해석', '대수'],
    ),
    const Major(
      id: 'physics',
      name: '물리학과',
      description: '물리현상 탐구 및 응용',
      icon: Icons.science,
      category: MajorCategory.science,
      keywords: ['물리', '과학', '실험', '이론', '연구'],
    ),

    // 기타
    const Major(
      id: 'undecided',
      name: '미정/복수전공',
      description: '아직 정하지 못했거나 복수전공',
      icon: Icons.help_outline,
      category: MajorCategory.etc,
      keywords: ['미정', '복수전공', '고민', '선택'],
    ),
  ];

  /// 카테고리별 학과 목록 반환
  static List<Major> getMajorsByCategory(MajorCategory category) {
    return allMajors.where((major) => major.category == category).toList();
  }

  /// 검색어로 학과 필터링
  static List<Major> searchMajors(String query) {
    if (query.isEmpty) return allMajors;

    final lowercaseQuery = query.toLowerCase();
    return allMajors.where((major) {
      return major.name.toLowerCase().contains(lowercaseQuery) ||
          major.description.toLowerCase().contains(lowercaseQuery) ||
          major.keywords.any(
            (keyword) => keyword.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  /// ID로 학과 찾기
  static Major? findMajorById(String id) {
    try {
      return allMajors.firstWhere((major) => major.id == id);
    } catch (e) {
      return null;
    }
  }
}