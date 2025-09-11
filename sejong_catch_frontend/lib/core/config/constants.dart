import 'package:flutter/material.dart';

/// 세종 캐치 앱 전체에서 사용되는 상수들을 정의합니다.
///
/// 하드코딩을 방지하고 일관성 있는 값 사용을 위해
/// 모든 상수를 이 파일에서 중앙 관리해요.
class AppConstants {
  // Private constructor - 인스턴스 생성 방지
  AppConstants._();

  // ============================================================================
  // 앱 기본 정보 (App Basic Information)
  // ============================================================================

  /// 앱 이름
  static const String appName = '세종 캐치';

  /// 앱 영문 이름
  static const String appNameEn = 'Sejong Catch';

  /// 앱 설명
  static const String appDescription = '세종인을 위한 정보 허브';

  /// 앱 태그라인
  static const String appTagline = '공모전, 취업, 논문, 공지사항을 한 곳에서!';

  // ============================================================================
  // SharedPreferences 키 (Local Storage Keys)
  // ============================================================================

  /// 온보딩 완료 여부
  static const String keyOnboardingCompleted = 'onboarding_completed';

  /// 사용자 인증 토큰
  static const String keyAuthToken = 'auth_token';

  /// 리프레시 토큰
  static const String keyRefreshToken = 'refresh_token';

  /// 사용자 역할 (Guest/Student/Operator/Admin)
  static const String keyUserRole = 'user_role';

  /// 사용자 학과 정보
  static const String keyUserDepartment = 'user_department';

  /// 사용자 관심사 태그들
  static const String keyUserInterests = 'user_interests';

  /// 다크 모드 설정
  static const String keyDarkMode = 'dark_mode_enabled';

  /// 알림 설정
  static const String keyNotificationEnabled = 'notification_enabled';

  /// 마감 알림 시간 설정 (시간)
  static const String keyDeadlineNotificationHours =
      'deadline_notification_hours';

  /// 최근 검색어 목록
  static const String keyRecentSearches = 'recent_searches';

  /// 저장된 필터 설정들
  static const String keySavedFilters = 'saved_filters';

  /// 북마크한 아이템 ID 목록
  static const String keyBookmarkedItems = 'bookmarked_items';

  // ============================================================================
  // 사용자 역할 (User Roles)
  // ============================================================================

  /// 게스트 사용자 (로그인 안함)
  static const String roleGuest = 'guest';

  /// 일반 학생 사용자
  static const String roleStudent = 'student';

  /// 운영자 (정보 수집 규칙 관리)
  static const String roleOperator = 'operator';

  /// 관리자 (시스템 전체 관리)
  static const String roleAdmin = 'admin';

  /// 역할 계층 순서 (권한 레벨)
  static const Map<String, int> roleHierarchy = {
    roleGuest: 0,
    roleStudent: 1,
    roleOperator: 2,
    roleAdmin: 3,
  };

  // ============================================================================
  // 정보 카테고리 (Information Categories)
  // ============================================================================

  /// 공모전 카테고리
  static const String categoryContest = 'contest';

  /// 취업 정보 카테고리
  static const String categoryJob = 'job';

  /// 학술 논문 카테고리
  static const String categoryPaper = 'paper';

  /// 공지사항 카테고리
  static const String categoryNotice = 'notice';

  /// 카테고리 표시 이름 매핑
  static const Map<String, String> categoryNames = {
    categoryContest: '공모전',
    categoryJob: '취업',
    categoryPaper: '논문',
    categoryNotice: '공지',
  };

  /// 카테고리별 이모지
  static const Map<String, String> categoryEmojis = {
    categoryContest: '🏆',
    categoryJob: '💼',
    categoryPaper: '📄',
    categoryNotice: '📢',
  };

  // ============================================================================
  // 신뢰도 레벨 (Trust Levels)
  // ============================================================================

  /// 공식 출처 (정부, 대학 공식)
  static const String trustOfficial = 'official';

  /// 학술 출처 (학회, 연구기관)
  static const String trustAcademic = 'academic';

  /// 언론 출처 (뉴스, 기사)
  static const String trustPress = 'press';

  /// 커뮤니티 출처 (학생 단체, 동아리)
  static const String trustCommunity = 'community';

  /// 신뢰도 표시 이름 매핑
  static const Map<String, String> trustNames = {
    trustOfficial: '공식',
    trustAcademic: '학술',
    trustPress: '언론',
    trustCommunity: '커뮤니티',
  };

  /// 신뢰도별 뱃지 아이콘
  static const Map<String, String> trustIcons = {
    trustOfficial: '🛡️',
    trustAcademic: '🎓',
    trustPress: '📰',
    trustCommunity: '👥',
  };

  // ============================================================================
  // 우선순위 레벨 (Priority Levels)
  // ============================================================================

  /// 높은 우선순위
  static const String priorityHigh = 'high';

  /// 중간 우선순위
  static const String priorityMid = 'mid';

  /// 낮은 우선순위
  static const String priorityLow = 'low';

  /// 우선순위 표시 이름 매핑
  static const Map<String, String> priorityNames = {
    priorityHigh: '높음',
    priorityMid: '보통',
    priorityLow: '낮음',
  };

  // ============================================================================
  // 대기열 상태 (Queue Status)
  // ============================================================================

  /// 대기 중
  static const String queueStatusWaiting = 'waiting';

  /// 진행 중
  static const String queueStatusInProgress = 'in_progress';

  /// 완료됨
  static const String queueStatusCompleted = 'completed';

  /// 취소됨
  static const String queueStatusCancelled = 'cancelled';

  /// 대기열 상태 표시 이름 매핑
  static const Map<String, String> queueStatusNames = {
    queueStatusWaiting: '대기중',
    queueStatusInProgress: '진행중',
    queueStatusCompleted: '완료',
    queueStatusCancelled: '취소',
  };

  // ============================================================================
  // 필터 옵션 (Filter Options)
  // ============================================================================

  /// 학과 목록 (세종대학교 주요 학과)
  static const List<String> departments = [
    '컴퓨터공학과',
    '소프트웨어학과',
    '지능기전공학부',
    '전자정보통신공학과',
    '건축공학과',
    '경영학부',
    '경제학과',
    '국어국문학과',
    '영어영문학과',
    '일어일문학과',
    '중어중문학과',
    '사학과',
    '교육학과',
    '심리학과',
    '행정학과',
    '디자인학과',
    '음악과',
    '체육학과',
    '호텔관광외식경영학부',
    '간호학과',
    '의학과',
  ];

  /// 관심사 태그 목록 (미리 정의된 태그들)
  static const List<String> interestTags = [
    'IT/프로그래밍',
    '디자인',
    '마케팅',
    '기획',
    '연구개발',
    '창업',
    '해외',
    '대기업',
    '중소기업',
    '공기업',
    '스타트업',
    '인턴십',
    '아르바이트',
    '봉사활동',
    '학술대회',
    '논문발표',
    '특허',
    '외국어',
    '자격증',
    '포트폴리오',
  ];

  // ============================================================================
  // UI 관련 상수 (UI Constants)
  // ============================================================================

  /// 기본 패딩 크기 (논리 픽셀)
  static const double defaultPadding = 16.0;

  /// 카드 간격
  static const double cardSpacing = 12.0;

  /// 기본 테두리 둥글기
  static const double defaultBorderRadius = 8.0;

  /// 버튼 최소 높이 (접근성 가이드라인)
  static const double minButtonHeight = 44.0;

  /// 아이콘 기본 크기
  static const double defaultIconSize = 24.0;

  /// 아바타 기본 크기
  static const double defaultAvatarSize = 40.0;

  // ============================================================================
  // 날짜/시간 포맷 (Date/Time Formats)
  // ============================================================================

  /// 기본 날짜 포맷 (yyyy-MM-dd)
  static const String dateFormat = 'yyyy-MM-dd';

  /// 한국어 날짜 포맷 (yyyy년 MM월 dd일)
  static const String dateFormatKorean = 'yyyy년 MM월 dd일';

  /// 시간 포맷 (HH:mm)
  static const String timeFormat = 'HH:mm';

  /// 날짜시간 포맷 (yyyy-MM-dd HH:mm)
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  /// 상대 시간 표시용 기준 (밀리초)
  static const int hourMs = 60 * 60 * 1000;
  static const int dayMs = 24 * hourMs;
  static const int weekMs = 7 * dayMs;

  // ============================================================================
  // 에러 메시지 (Error Messages)
  // ============================================================================

  /// 네트워크 연결 오류
  static const String errorNetwork = '네트워크 연결을 확인해주세요';

  /// 서버 오류
  static const String errorServer = '서버에 오류가 발생했습니다';

  /// 인증 오류
  static const String errorAuth = '로그인이 필요합니다';

  /// 권한 오류
  static const String errorPermission = '접근 권한이 없습니다';

  /// 데이터 없음
  static const String errorNoData = '데이터가 없습니다';

  /// 검색 결과 없음
  static const String errorNoSearchResult = '검색 결과가 없습니다';

  /// 알 수 없는 오류
  static const String errorUnknown = '알 수 없는 오류가 발생했습니다';

  // ============================================================================
  // 성공 메시지 (Success Messages)
  // ============================================================================

  /// 로그인 성공
  static const String successLogin = '로그인되었습니다';

  /// 로그아웃 성공
  static const String successLogout = '로그아웃되었습니다';

  /// 북마크 추가
  static const String successBookmarkAdded = '북마크에 추가했습니다';

  /// 북마크 제거
  static const String successBookmarkRemoved = '북마크에서 제거했습니다';

  /// 대기열 추가
  static const String successQueueJoined = '대기열에 추가했습니다';

  /// 대기열 취소
  static const String successQueueLeft = '대기열에서 제거했습니다';

  /// 설정 저장
  static const String successSettingsSaved = '설정이 저장되었습니다';

  // ============================================================================
  // 헬퍼 메서드 (Helper Methods)
  // ============================================================================

  /// 역할 권한 레벨 비교 (role1이 role2보다 높거나 같은 권한인지)
  static bool hasPermission(String role1, String role2) {
    final level1 = roleHierarchy[role1] ?? 0;
    final level2 = roleHierarchy[role2] ?? 0;
    return level1 >= level2;
  }

  /// 카테고리 표시 이름 가져오기
  static String getCategoryName(String category) {
    return categoryNames[category] ?? category;
  }

  /// 신뢰도 표시 이름 가져오기
  static String getTrustName(String trust) {
    return trustNames[trust] ?? trust;
  }

  /// 우선순위 표시 이름 가져오기
  static String getPriorityName(String priority) {
    return priorityNames[priority] ?? priority;
  }

  /// 대기열 상태 표시 이름 가져오기
  static String getQueueStatusName(String status) {
    return queueStatusNames[status] ?? status;
  }

  /// 모든 상수 출력 (디버그용)
  static void printConstants() {
    debugPrint('📋 세종 캐치 상수 정보');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📱 앱: $appName ($appNameEn)');
    debugPrint('🏫 학과: ${departments.length}개');
    debugPrint('🏷️ 관심사: ${interestTags.length}개');
    debugPrint('📂 카테고리: ${categoryNames.length}개');
    debugPrint('🛡️ 신뢰도: ${trustNames.length}레벨');
    debugPrint('⚡ 우선순위: ${priorityNames.length}레벨');
    debugPrint('👤 역할: ${roleHierarchy.length}개');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
