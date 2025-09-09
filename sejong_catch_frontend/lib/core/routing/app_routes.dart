class AppRoutes {
  // Root routes
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String root = '/';
  
  // Main tab routes
  static const String home = '/home';
  static const String search = '/search';
  static const String bookmarks = '/bookmarks';
  static const String notifications = '/notifications'; // Future implementation
  static const String profile = '/profile';
  
  // Feature routes
  static const String detail = '/detail';
  static const String settings = '/settings';
  
  // Console routes (Admin/Operator)
  static const String console = '/console';
  static const String consoleRules = '/console/rules';
  static const String consoleStats = '/console/stats';
  
  // Route parameters
  static const String detailIdParam = 'id';
  
  // Route paths with parameters
  static String detailWithId(String id) => '/detail/$id';
  
  // Bottom navigation routes
  static const List<String> bottomNavRoutes = [
    home,
    search,
    bookmarks,
    notifications,
    profile,
  ];
  
  // Protected routes requiring authentication
  static const List<String> protectedRoutes = [
    bookmarks,
    console,
    consoleRules,
    consoleStats,
  ];
  
  // Routes requiring specific roles
  static const Map<String, String> roleRequiredRoutes = {
    bookmarks: 'student',
    console: 'operator',
    consoleRules: 'operator', 
    consoleStats: 'admin',
  };
}