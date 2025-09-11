import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'routes.dart';

/// 라우트 가드 클래스
/// 
/// 페이지 접근 권한을 체크하고, 필요시 리다이렉트를 수행합니다.
/// 역할 기반 접근 제어(RBAC)를 구현해요.
class RouteGuards {
  // Private constructor - 인스턴스 생성 방지
  RouteGuards._();

  // ============================================================================
  // 가드 상태 관리 (Guard State Management)
  // ============================================================================
  
  /// 현재 사용자 역할 (실제로는 AuthController에서 가져와야 함)
  /// 임시로 static으로 관리, 나중에 Provider로 교체 예정
  static String _currentUserRole = AppConstants.roleGuest;
  
  /// 온보딩 완료 여부 (실제로는 SharedPreferences에서 가져와야 함)
  static bool _isOnboardingCompleted = false;
  
  /// 사용자 역할 설정 (AuthController에서 호출)
  static void setUserRole(String role) {
    _currentUserRole = role;
  }
  
  /// 온보딩 완료 상태 설정
  static void setOnboardingCompleted(bool completed) {
    _isOnboardingCompleted = completed;
  }
  
  /// 현재 사용자 역할 반환
  static String get currentUserRole => _currentUserRole;
  
  /// 현재 사용자가 인증된 상태인지 확인
  static bool get isAuthenticated => _currentUserRole != AppConstants.roleGuest;

  // ============================================================================
  // 메인 가드 함수 (Main Guard Function)
  // ============================================================================
  
  /// GoRouter에서 사용하는 메인 리다이렉트 가드
  /// 
  /// 모든 라우트 변경 시 호출되어 접근 권한을 체크하고
  /// 필요시 적절한 페이지로 리다이렉트합니다.
  static String? routeGuard(BuildContext context, GoRouterState state) {
    final currentRoute = state.matchedLocation;
    
    // 1. 온보딩 체크 (첫 실행 시)
    final onboardingRedirect = _checkOnboardingGuard(currentRoute);
    if (onboardingRedirect != null) return onboardingRedirect;
    
    // 2. 인증 체크 (로그인 필요 페이지)
    final authRedirect = _checkAuthGuard(currentRoute);
    if (authRedirect != null) return authRedirect;
    
    // 3. 역할 권한 체크 (역할별 접근 제한)
    final roleRedirect = _checkRoleGuard(currentRoute);
    if (roleRedirect != null) return roleRedirect;
    
    // 모든 가드 통과 - 접근 허용
    return null;
  }

  // ============================================================================
  // 개별 가드 함수들 (Individual Guard Functions)
  // ============================================================================
  
  /// 온보딩 가드
  /// 
  /// 첫 실행 시 온보딩을 완료하지 않았다면 온보딩 페이지로 리다이렉트
  static String? _checkOnboardingGuard(String currentRoute) {
    // 온보딩 관련 페이지는 체크하지 않음
    if (currentRoute == AppRoutes.onboarding) {
      return null;
    }
    
    // 온보딩을 완료하지 않았다면 온보딩 페이지로
    if (!_isOnboardingCompleted) {
      return AppRoutes.onboarding;
    }
    
    return null;
  }
  
  /// 인증 가드
  /// 
  /// 로그인이 필요한 페이지에 게스트가 접근하면 로그인 페이지로 리다이렉트
  static String? _checkAuthGuard(String currentRoute) {
    // 인증 관련 페이지는 체크하지 않음
    if (currentRoute == AppRoutes.auth) {
      return null;
    }
    
    // 인증이 필요한 페이지인지 확인
    if (AppRoutes.requiresAuth(currentRoute)) {
      // 게스트 사용자라면 로그인 페이지로
      if (!isAuthenticated) {
        return '${AppRoutes.auth}?redirect=${Uri.encodeComponent(currentRoute)}';
      }
    }
    
    return null;
  }
  
  /// 역할 권한 가드
  /// 
  /// 사용자의 역할이 페이지 접근 권한에 맞지 않으면 적절한 페이지로 리다이렉트
  static String? _checkRoleGuard(String currentRoute) {
    // 현재 사용자의 권한 레벨
    final currentLevel = AppConstants.roleHierarchy[_currentUserRole] ?? 0;
    
    // 관리자 전용 페이지 체크
    if (AppRoutes.adminRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleAdmin] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission();
      }
    }
    
    // 운영자 전용 페이지 체크
    if (AppRoutes.operatorRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleOperator] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission();
      }
    }
    
    // 학생 전용 페이지 체크
    if (AppRoutes.studentRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleStudent] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission();
      }
    }
    
    return null;
  }
  
  /// 권한 부족 시 리다이렉트할 페이지 결정
  static String _getRedirectForInsufficientPermission() {
    switch (_currentUserRole) {
      case AppConstants.roleGuest:
        // 게스트는 로그인 페이지로
        return AppRoutes.auth;
      case AppConstants.roleStudent:
        // 학생은 메인 피드로
        return AppRoutes.feed;
      case AppConstants.roleOperator:
        // 운영자는 콘솔 메인으로
        return AppRoutes.console;
      default:
        // 기본적으로 메인 페이지로
        return AppRoutes.feed;
    }
  }

  // ============================================================================
  // 권한 체크 유틸리티 함수들 (Permission Check Utilities)
  // ============================================================================
  
  /// 특정 라우트에 접근 가능한지 확인
  static bool canAccessRoute(String route) {
    // 공개 라우트는 누구나 접근 가능
    if (AppRoutes.publicRoutes.contains(route)) {
      return true;
    }
    
    // 현재 사용자의 권한 레벨
    final currentLevel = AppConstants.roleHierarchy[_currentUserRole] ?? 0;
    
    // 관리자 전용 페이지
    if (AppRoutes.adminRoutes.contains(route)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleAdmin] ?? 999;
      return currentLevel >= requiredLevel;
    }
    
    // 운영자 전용 페이지
    if (AppRoutes.operatorRoutes.contains(route)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleOperator] ?? 999;
      return currentLevel >= requiredLevel;
    }
    
    // 학생 전용 페이지
    if (AppRoutes.studentRoutes.contains(route)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleStudent] ?? 999;
      return currentLevel >= requiredLevel;
    }
    
    return true;
  }
  
  /// 현재 사용자가 특정 역할 이상의 권한을 가지고 있는지 확인
  static bool hasRoleOrHigher(String requiredRole) {
    final currentLevel = AppConstants.roleHierarchy[_currentUserRole] ?? 0;
    final requiredLevel = AppConstants.roleHierarchy[requiredRole] ?? 999;
    return currentLevel >= requiredLevel;
  }
  
  /// 현재 사용자가 관리자인지 확인
  static bool get isAdmin => _currentUserRole == AppConstants.roleAdmin;
  
  /// 현재 사용자가 운영자 이상인지 확인
  static bool get isOperatorOrHigher => hasRoleOrHigher(AppConstants.roleOperator);
  
  /// 현재 사용자가 학생 이상인지 확인
  static bool get isStudentOrHigher => hasRoleOrHigher(AppConstants.roleStudent);

  // ============================================================================
  // 바텀 네비게이션 가드 (Bottom Navigation Guards)
  // ============================================================================
  
  /// 바텀 네비게이션 탭 접근 가능 여부 확인
  static bool canAccessBottomNavTab(int tabIndex) {
    final route = AppRoutes.getRouteFromIndex(tabIndex);
    return canAccessRoute(route);
  }
  
  /// 바텀 네비게이션에서 표시할 탭들 필터링
  static List<int> getAvailableBottomNavTabs() {
    final availableTabs = <int>[];
    
    for (int i = 0; i < AppRoutes.bottomNavRoutes.length; i++) {
      if (canAccessBottomNavTab(i)) {
        availableTabs.add(i);
      }
    }
    
    return availableTabs;
  }

  // ============================================================================
  // 디버그 & 테스트 함수들 (Debug & Test Functions)
  // ============================================================================
  
  /// 현재 가드 상태 출력 (디버그용)
  static void printGuardStatus() {
    // 개발 모드에서만 출력
    assert(() {
      final buffer = StringBuffer();
      buffer.writeln('🛡️ 라우트 가드 상태');
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      buffer.writeln('👤 현재 역할: $_currentUserRole');
      buffer.writeln('🔐 인증 상태: ${isAuthenticated ? '인증됨' : '게스트'}');
      buffer.writeln('📱 온보딩: ${_isOnboardingCompleted ? '완료' : '미완료'}');
      buffer.writeln('👑 관리자 권한: ${isAdmin ? '있음' : '없음'}');
      buffer.writeln('👨‍💼 운영자 권한: ${isOperatorOrHigher ? '있음' : '없음'}');
      buffer.writeln('🎓 학생 권한: ${isStudentOrHigher ? '있음' : '없음'}');
      
      // 접근 가능한 탭 표시
      final availableTabs = getAvailableBottomNavTabs();
      buffer.writeln('📱 접근 가능 탭: ${availableTabs.length}개');
      for (final tabIndex in availableTabs) {
        final route = AppRoutes.getRouteFromIndex(tabIndex);
        buffer.writeln('   • $tabIndex: ${AppRoutes.getRouteName(route)}');
      }
      
      buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // ignore: avoid_print
      print(buffer.toString());
      return true;
    }());
  }
  
  /// 테스트용: 역할 변경 시뮬레이션
  static void simulateRoleChange(String newRole) {
    final oldRole = _currentUserRole;
    setUserRole(newRole);
    
    // 개발 모드에서만 출력
    assert(() {
      // ignore: avoid_print
      print('🔄 역할 변경: $oldRole → $newRole');
      return true;
    }());
  }
  
  /// 테스트용: 온보딩 상태 토글
  static void toggleOnboarding() {
    _isOnboardingCompleted = !_isOnboardingCompleted;
    
    // 개발 모드에서만 출력
    assert(() {
      // ignore: avoid_print
      print('📱 온보딩 상태: ${_isOnboardingCompleted ? '완료' : '미완료'}');
      return true;
    }());
  }
}