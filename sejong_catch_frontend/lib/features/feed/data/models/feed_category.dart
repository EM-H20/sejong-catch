/// 📂 피드 카테고리 모델
///
/// 세종 캐치의 4가지 핵심 카테고리를 정의합니다.
/// Freezed 없이 일반 Dart 클래스로 구현하여 컴파일 타임 안전성 보장!
enum FeedCategory {
  all('전체', 'all'),
  contest('공모전', 'contest'),
  job('취업', 'job'),
  paper('논문', 'paper'),
  notice('공지사항', 'notice');

  const FeedCategory(this.displayName, this.value);

  /// 화면에 표시될 한국어 이름
  final String displayName;

  /// API 요청 시 사용할 영문 값
  final String value;

  /// 카테고리별 아이콘 반환
  String get iconName {
    switch (this) {
      case FeedCategory.contest:
        return 'emoji_events';
      case FeedCategory.job:
        return 'work';
      case FeedCategory.paper:
        return 'article';
      case FeedCategory.notice:
        return 'announcement';
      case FeedCategory.all:
        return 'dashboard';
    }
  }

  /// 카테고리별 색상 반환 (브랜드 크림슨 기반)
  String get colorHex {
    switch (this) {
      case FeedCategory.contest:
        return '#DC143C'; // 공모전 - 브랜드 크림슨
      case FeedCategory.job:
        return '#16A34A'; // 취업 - 성공 그린
      case FeedCategory.paper:
        return '#3B82F6'; // 논문 - 학술 블루
      case FeedCategory.notice:
        return '#F59E0B'; // 공지 - 경고 오렌지
      case FeedCategory.all:
        return '#6B7280'; // 전체 - 중성 그레이
    }
  }

  /// String 값으로부터 카테고리 찾기
  static FeedCategory fromString(String value) {
    return FeedCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => FeedCategory.all,
    );
  }
}