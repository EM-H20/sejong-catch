import 'package:flutter/material.dart';

/// 관심사 카테고리
enum InterestCategory {
  career('진로/취업', Icons.work, Color(0xFFDC143C)),
  contest('공모전/대회', Icons.emoji_events, Color(0xFF10B981)),
  scholarship('장학금/지원', Icons.school, Color(0xFF3B82F6)),
  academic('학술/연구', Icons.science, Color(0xFF8B5CF6)),
  club('동아리/모임', Icons.group, Color(0xFFF59E0B)),
  culture('문화/행사', Icons.celebration, Color(0xFFEF4444)),
  startup('창업/사업', Icons.business_center, Color(0xFF06B6D4)),
  volunteer('봉사/사회', Icons.volunteer_activism, Color(0xFF84CC16));

  const InterestCategory(this.displayName, this.icon, this.color);

  final String displayName;
  final IconData icon;
  final Color color;
}

/// 사용자 관심사 모델
class Interest {
  final String id;
  final String name;
  final String emoji;
  final InterestCategory category;
  final String description;
  final List<String> relatedKeywords;

  const Interest({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.description,
    required this.relatedKeywords,
  });

  Interest copyWith({
    String? id,
    String? name,
    String? emoji,
    InterestCategory? category,
    String? description,
    List<String>? relatedKeywords,
  }) {
    return Interest(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      category: category ?? this.category,
      description: description ?? this.description,
      relatedKeywords: relatedKeywords ?? this.relatedKeywords,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Interest && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Interest(id: $id, name: $name)';

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'category': category.name,
      'description': description,
      'relatedKeywords': relatedKeywords,
    };
  }

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'],
      category: InterestCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      description: json['description'],
      relatedKeywords: List<String>.from(json['relatedKeywords']),
    );
  }
}

/// 관심사 데이터 관리 클래스
class InterestData {
  static final List<Interest> allInterests = [
    // 진로/취업 관련
    const Interest(
      id: 'job_fair',
      name: '취업박람회',
      emoji: '💼',
      category: InterestCategory.career,
      description: '기업 채용 설명회 및 면접 기회',
      relatedKeywords: ['채용', '면접', '구직', '인턴', '신입'],
    ),
    const Interest(
      id: 'internship',
      name: '인턴십',
      emoji: '👔',
      category: InterestCategory.career,
      description: '실무 경험 및 취업 준비',
      relatedKeywords: ['인턴', '실습', '경험', '현장'],
    ),
    const Interest(
      id: 'certification',
      name: '자격증',
      emoji: '📜',
      category: InterestCategory.career,
      description: '전문 자격증 취득 정보',
      relatedKeywords: ['자격증', '시험', '라이센스', '전문'],
    ),
    const Interest(
      id: 'resume_portfolio',
      name: '이력서/포트폴리오',
      emoji: '📋',
      category: InterestCategory.career,
      description: '이력서 작성 및 포트폴리오 구성',
      relatedKeywords: ['이력서', '포트폴리오', '자소서', 'CV'],
    ),

    // 공모전/대회 관련
    const Interest(
      id: 'programming_contest',
      name: '프로그래밍 대회',
      emoji: '💻',
      category: InterestCategory.contest,
      description: 'AI, 개발, 해커톤 등 프로그래밍 경진대회',
      relatedKeywords: ['프로그래밍', '코딩', '해커톤', 'AI', '개발'],
    ),
    const Interest(
      id: 'design_contest',
      name: '디자인 공모전',
      emoji: '🎨',
      category: InterestCategory.contest,
      description: '시각, 제품, UX/UI 디자인 공모전',
      relatedKeywords: ['디자인', '시각', 'UI', 'UX', '그래픽'],
    ),
    const Interest(
      id: 'business_contest',
      name: '비즈니스 공모전',
      emoji: '📈',
      category: InterestCategory.contest,
      description: '사업계획서, 마케팅, 경영전략 공모전',
      relatedKeywords: ['사업계획', '마케팅', '전략', '경영'],
    ),
    const Interest(
      id: 'writing_contest',
      name: '글쓰기 공모전',
      emoji: '✍️',
      category: InterestCategory.contest,
      description: '수필, 시, 소설 등 문학 창작 공모전',
      relatedKeywords: ['글쓰기', '문학', '창작', '수필', '시'],
    ),

    // 장학금/지원 관련
    const Interest(
      id: 'scholarship',
      name: '성적우수 장학금',
      emoji: '🏆',
      category: InterestCategory.scholarship,
      description: '학업 성취도 기반 장학 혜택',
      relatedKeywords: ['장학금', '성적', '학업', '우수'],
    ),
    const Interest(
      id: 'need_based_aid',
      name: '생활지원 장학금',
      emoji: '🤝',
      category: InterestCategory.scholarship,
      description: '경제적 어려움 지원 장학금',
      relatedKeywords: ['생활지원', '경제', '도움', '지원'],
    ),
    const Interest(
      id: 'research_grant',
      name: '연구지원금',
      emoji: '💰',
      category: InterestCategory.scholarship,
      description: '학부생 연구 활동 지원금',
      relatedKeywords: ['연구', '지원금', '프로젝트', '학부생'],
    ),

    // 학술/연구 관련
    const Interest(
      id: 'undergraduate_research',
      name: '학부생 연구',
      emoji: '🔬',
      category: InterestCategory.academic,
      description: '교수님과 함께하는 연구 프로젝트',
      relatedKeywords: ['연구', '교수', '프로젝트', '논문'],
    ),
    const Interest(
      id: 'conference',
      name: '학술대회',
      emoji: '📚',
      category: InterestCategory.academic,
      description: '학회 발표 및 논문 게재 기회',
      relatedKeywords: ['학회', '발표', '논문', '컨퍼런스'],
    ),
    const Interest(
      id: 'exchange_program',
      name: '교환학생',
      emoji: '🌍',
      category: InterestCategory.academic,
      description: '해외 대학 교환 프로그램',
      relatedKeywords: ['교환학생', '해외', '유학', '국제'],
    ),

    // 동아리/모임 관련
    const Interest(
      id: 'tech_club',
      name: 'IT/개발 동아리',
      emoji: '⚡',
      category: InterestCategory.club,
      description: '프로그래밍 및 기술 관련 동아리',
      relatedKeywords: ['IT', '개발', '프로그래밍', '기술'],
    ),
    const Interest(
      id: 'business_club',
      name: '경영/창업 동아리',
      emoji: '🚀',
      category: InterestCategory.club,
      description: '비즈니스 및 창업 관련 모임',
      relatedKeywords: ['경영', '창업', '비즈니스', '기업'],
    ),
    const Interest(
      id: 'art_club',
      name: '예술/문화 동아리',
      emoji: '🎭',
      category: InterestCategory.club,
      description: '음악, 미술, 연극 등 문화 활동',
      relatedKeywords: ['예술', '문화', '음악', '미술', '연극'],
    ),
    const Interest(
      id: 'sports_club',
      name: '스포츠/운동 동아리',
      emoji: '⚽',
      category: InterestCategory.club,
      description: '각종 운동 및 스포츠 활동',
      relatedKeywords: ['스포츠', '운동', '축구', '농구', '테니스'],
    ),

    // 문화/행사 관련
    const Interest(
      id: 'festival',
      name: '대학 축제',
      emoji: '🎪',
      category: InterestCategory.culture,
      description: '학교 축제 및 문화 행사',
      relatedKeywords: ['축제', '문화', '행사', '공연'],
    ),
    const Interest(
      id: 'concert_lecture',
      name: '강연/세미나',
      emoji: '🎤',
      category: InterestCategory.culture,
      description: '저명인사 초청 강연 및 세미나',
      relatedKeywords: ['강연', '세미나', '특강', '초청'],
    ),
    const Interest(
      id: 'exhibition',
      name: '전시/갤러리',
      emoji: '🖼️',
      category: InterestCategory.culture,
      description: '학생 작품 전시 및 문화 공간',
      relatedKeywords: ['전시', '갤러리', '작품', '문화'],
    ),

    // 창업/사업 관련
    const Interest(
      id: 'startup_support',
      name: '창업 지원',
      emoji: '🌟',
      category: InterestCategory.startup,
      description: '학생 창업 지원 프로그램',
      relatedKeywords: ['창업', '스타트업', '지원', '사업'],
    ),
    const Interest(
      id: 'entrepreneurship',
      name: '기업가정신',
      emoji: '💡',
      category: InterestCategory.startup,
      description: '기업가정신 교육 및 멘토링',
      relatedKeywords: ['기업가', '멘토링', '교육', '리더십'],
    ),

    // 봉사/사회 관련
    const Interest(
      id: 'volunteer',
      name: '봉사활동',
      emoji: '❤️',
      category: InterestCategory.volunteer,
      description: '지역사회 봉사 및 나눔 활동',
      relatedKeywords: ['봉사', '나눔', '지역사회', '도움'],
    ),
    const Interest(
      id: 'social_activity',
      name: '사회공헌',
      emoji: '🌱',
      category: InterestCategory.volunteer,
      description: '환경, 인권 등 사회 문제 해결',
      relatedKeywords: ['사회공헌', '환경', '인권', '문제해결'],
    ),
  ];

  /// 카테고리별 관심사 목록 반환
  static List<Interest> getInterestsByCategory(InterestCategory category) {
    return allInterests.where((interest) => interest.category == category).toList();
  }

  /// 검색어로 관심사 필터링
  static List<Interest> searchInterests(String query) {
    if (query.isEmpty) return allInterests;

    final lowercaseQuery = query.toLowerCase();
    return allInterests.where((interest) {
      return interest.name.toLowerCase().contains(lowercaseQuery) ||
          interest.description.toLowerCase().contains(lowercaseQuery) ||
          interest.relatedKeywords.any(
            (keyword) => keyword.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  /// ID로 관심사 찾기
  static Interest? findInterestById(String id) {
    try {
      return allInterests.firstWhere((interest) => interest.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 추천 관심사 (신입생용)
  static List<Interest> getRecommendedInterests() {
    return [
      allInterests.firstWhere((i) => i.id == 'job_fair'),
      allInterests.firstWhere((i) => i.id == 'scholarship'),
      allInterests.firstWhere((i) => i.id == 'programming_contest'),
      allInterests.firstWhere((i) => i.id == 'festival'),
      allInterests.firstWhere((i) => i.id == 'tech_club'),
    ];
  }
}