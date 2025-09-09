// User Roles
enum UserRole {
  guest,
  student, 
  operator,
  admin
}

// Trust Levels
enum TrustLevel {
  official,
  academic,
  press,
  community
}

// Priority Levels
enum PriorityLevel {
  high,
  medium,
  low
}

class AppConfig {
  // App Information
  static const String appName = 'Sejong Catch';
  static const String appDescription = '세종인을 위한 단 하나의 정보 허브';
  
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8000';
  static const String supabaseUrl = 'https://twbakqeemdcaljkymywk.supabase.co';
  
  // Layout Constants
  static const double gridUnit = 4.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 12.0;
  
  // Touch Targets (Accessibility)
  static const double minTouchTarget = 44.0;
  
  // Animation Durations
  static const int tabTransitionDuration = 200;
  static const int fadeTransitionDuration = 140;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int skeletonItemCount = 5;
  
  // Content Types
  static const List<String> contentTypes = [
    '공모전',
    '취업정보', 
    '논문/학술',
    '공지사항'
  ];
}