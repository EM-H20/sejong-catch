/// 세종 캐치 앱의 모든 라우트 경로를 정의합니다.
/// 
/// 라우트 경로를 상수로 관리해서 오타를 방지하고
/// IDE의 자동완성 기능을 활용할 수 있어요.
class AppRoutes {
  // Private constructor - 인스턴스 생성 방지
  AppRoutes._();

  // ============================================================================
  // 온보딩 & 인증 라우트 (Onboarding & Auth Routes)
  // ============================================================================
  
  /// 온보딩 플로우 (4단계)
  /// 첫 실행 시에만 표시되는 앱 소개 과정
  static const String onboarding = '/onboarding';
  
  /// 로그인/회원가입 페이지
  /// 학생 인증이 필요한 기능 접근 시 리다이렉트
  static const String auth = '/auth';

  // ============================================================================
  // 메인 탭 라우트 (Main Tab Routes)
  // ============================================================================
  
  /// 홈/피드 페이지 (Recommended/Deadline/Latest 탭)
  /// 앱의 메인 화면, 정보 수집 결과를 보여줌
  static const String feed = '/';
  
  /// 검색 페이지 (검색 & 필터링)
  /// 키워드 검색, 고급 필터, 저장된 필터 관리
  static const String search = '/search';
  
  /// 대기열 관리 페이지 (Waiting/InProgress/Completed)
  /// 인기 있는 기회에 대한 대기열 시스템
  static const String queue = '/queue';
  
  /// 프로필 페이지 (사용자 정보 & 설정)
  /// 개인정보, 관심사, 앱 설정 관리
  static const String profile = '/profile';

  // ============================================================================
  // 상세 & 하위 페이지 라우트 (Detail & Sub Routes)
  // ============================================================================
  
  /// 정보 상세 페이지
  /// 개별 공모전/취업/논문/공지 상세 내용
  static const String detail = '/detail';
  
  /// 상세 페이지 경로 생성 헬퍼
  static String detailPath(String itemId) => '$detail/$itemId';
  
  /// 설정 페이지
  /// 테마, 알림, 계정 설정 등
  static const String settings = '/settings';
  
  /// 북마크 페이지
  /// 사용자가 저장한 정보 목록
  static const String bookmarks = '/bookmarks';

  // ============================================================================
  // 관리자 콘솔 라우트 (Admin Console Routes)
  // ============================================================================
  
  /// 관리자 콘솔 메인 (Operator 이상 접근 가능)
  /// 시스템 관리 및 모니터링 도구
  static const String console = '/console';
  
  /// 수집 규칙 관리 (Operator 전용)
  /// 자동 수집 규칙, 키워드 제외 설정
  static const String consoleRules = '/console/rules';
  
  /// 통계 대시보드 (Admin 전용)
  /// 사용자 통계, 시스템 성능 모니터링
  static const String consoleStats = '/console/stats';
  
  /// 사용자 관리 (Admin 전용)
  /// 사용자 권한, 계정 상태 관리
  static const String consoleUsers = '/console/users';

  // ============================================================================
  // 기타 유틸리티 라우트 (Utility Routes)
  // ============================================================================
  
  /// 도움말 페이지
  /// 앱 사용법, FAQ, 문의하기
  static const String help = '/help';
  
  /// 개인정보 처리방침
  static const String privacy = '/privacy';
  
  /// 서비스 이용약관
  static const String terms = '/terms';
  
  /// 앱 정보 (버전, 라이선스 등)
  static const String about = '/about';

  // ============================================================================
  // 라우트 그룹 분류 (Route Groups)
  // ============================================================================
  
  /// 인증이 필요 없는 공개 라우트
  /// 게스트 사용자도 접근 가능한 페이지들
  static const List<String> publicRoutes = [
    feed,
    search,
    detail,
    help,
    privacy,
    terms,
    about,
  ];
  
  /// 학생 인증이 필요한 라우트
  /// Student 역할 이상만 접근 가능
  static const List<String> studentRoutes = [
    queue,
    profile,
    bookmarks,
    settings,
  ];
  
  /// 운영자 권한이 필요한 라우트
  /// Operator 역할 이상만 접근 가능
  static const List<String> operatorRoutes = [
    console,
    consoleRules,
  ];
  
  /// 관리자 권한이 필요한 라우트
  /// Admin 역할만 접근 가능
  static const List<String> adminRoutes = [
    consoleStats,
    consoleUsers,
  ];
  
  /// 메인 바텀 네비게이션 탭 라우트
  /// BottomNavigationBar에서 사용되는 메인 탭들
  static const List<String> bottomNavRoutes = [
    feed,
    search,
    queue,
    profile,
  ];

  // ============================================================================
  // 헬퍼 메서드 (Helper Methods)
  // ============================================================================
  
  /// 라우트가 인증이 필요한지 확인
  static bool requiresAuth(String route) {
    return studentRoutes.contains(route) || 
           operatorRoutes.contains(route) || 
           adminRoutes.contains(route);
  }
  
  /// 라우트가 특정 역할 권한이 필요한지 확인
  static bool requiresRole(String route, String role) {
    switch (role) {
      case 'student':
        return studentRoutes.contains(route) || 
               operatorRoutes.contains(route) || 
               adminRoutes.contains(route);
      case 'operator':
        return operatorRoutes.contains(route) || 
               adminRoutes.contains(route);
      case 'admin':
        return adminRoutes.contains(route);
      default:
        return false;
    }
  }
  
  /// 바텀 네비게이션 탭인지 확인
  static bool isBottomNavRoute(String route) {
    return bottomNavRoutes.contains(route);
  }
  
  /// 관리자 콘솔 라우트인지 확인
  static bool isConsoleRoute(String route) {
    return route.startsWith(console);
  }
  
  /// 라우트에서 상세 페이지 ID 추출
  static String? getDetailId(String route) {
    if (route.startsWith(detail) && route.length > detail.length + 1) {
      return route.substring(detail.length + 1);
    }
    return null;
  }
  
  /// 현재 라우트의 탭 인덱스 반환 (바텀 네비게이션용)
  static int getTabIndex(String route) {
    switch (route) {
      case feed:
        return 0;
      case search:
        return 1;
      case queue:
        return 2;
      case profile:
        return 3;
      default:
        return 0;
    }
  }
  
  /// 탭 인덱스에서 라우트 경로 반환
  static String getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return feed;
      case 1:
        return search;
      case 2:
        return queue;
      case 3:
        return profile;
      default:
        return feed;
    }
  }
  
  /// 라우트 표시 이름 반환 (한국어)
  static String getRouteName(String route) {
    switch (route) {
      case feed:
        return '피드';
      case search:
        return '검색';
      case queue:
        return '대기열';
      case profile:
        return '프로필';
      case detail:
        return '상세';
      case settings:
        return '설정';
      case bookmarks:
        return '북마크';
      case console:
        return '관리자 콘솔';
      case consoleRules:
        return '수집 규칙';
      case consoleStats:
        return '통계';
      case consoleUsers:
        return '사용자 관리';
      case onboarding:
        return '앱 소개';
      case auth:
        return '로그인';
      case help:
        return '도움말';
      case privacy:
        return '개인정보 처리방침';
      case terms:
        return '이용약관';
      case about:
        return '앱 정보';
      default:
        return '알 수 없음';
    }
  }
  
  /// 디버그용: 모든 라우트 정보 출력
  static void printRoutes() {
    // 개발 모드에서만 출력
    assert(() {
      final buffer = StringBuffer();
      buffer.writeln('🛣️ 세종 캐치 라우트 정보');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('📱 메인 탭: ${bottomNavRoutes.length}개');
      for (final route in bottomNavRoutes) {
        buffer.writeln('   • $route (${getRouteName(route)})');
      }
      buffer.writeln('👥 공개 라우트: ${publicRoutes.length}개');
      buffer.writeln('🎓 학생 라우트: ${studentRoutes.length}개');
      buffer.writeln('👨‍💼 운영자 라우트: ${operatorRoutes.length}개');
      buffer.writeln('👑 관리자 라우트: ${adminRoutes.length}개');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // 개발 환경에서만 출력
      // ignore: avoid_print
      print(buffer.toString());
      return true;
    }());
  }
}