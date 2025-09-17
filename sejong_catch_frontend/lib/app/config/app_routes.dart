/// 🗺️ 세종 캐치 앱의 모든 라우트 경로 상수
///
/// 하드코딩 방지 및 라우트 경로 중앙 관리를 위한 상수 클래스
/// CLAUDE.md 가이드라인: 모든 경로는 여기서 정의하고 참조할 것!
class AppRoutes {
  // 🚫 인스턴스 생성 방지
  AppRoutes._();

  // 🏠 메인 앱 라우트 (BottomNavigationBar 포함)
  static const String home = '/';
  static const String feed = '/feed';
  static const String search = '/search';
  static const String queue = '/queue';
  static const String profile = '/profile';

  // 🔐 인증 관련 라우트 (독립 페이지)
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // 📱 온보딩 & 설정 라우트
  static const String onboarding = '/onboarding';
  static const String settings = '/settings';

  // 📄 상세 페이지 라우트
  static const String detail = '/detail';
  static String detailWithId(String id) => '$detail/$id';

  // 🔧 관리자 콘솔 라우트 (별도 ShellRoute)
  static const String console = '/console';
  static const String consoleRules = '/console/rules';
  static const String consoleStats = '/console/stats';

  // 📊 라우트 그룹 정의 (권한 가드용)
  static const List<String> mainAppRoutes = [
    home, feed, search, queue, profile
  ];

  static const List<String> authRequiredRoutes = [
    queue, profile, console, consoleRules, consoleStats
  ];

  static const List<String> guestOnlyRoutes = [
    auth, login, register, onboarding
  ];
}