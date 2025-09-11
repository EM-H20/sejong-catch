import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import 'routes.dart';
import '../../domain/controllers/app_controller.dart';
import '../../domain/controllers/auth_controller.dart';

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
  
  /// 주의: static 상태 변수들은 Provider로 대체되었습니다.
  /// 실제 상태는 AppController와 AuthController에서 관리됩니다.

  // ============================================================================
  // 메인 가드 함수 (Main Guard Function)
  // ============================================================================
  
  /// GoRouter에서 사용하는 메인 리다이렉트 가드
  /// 
  /// 모든 라우트 변경 시 호출되어 접근 권한을 체크하고
  /// 필요시 적절한 페이지로 리다이렉트합니다.
  /// Provider를 통해 실시간 상태를 확인해요.
  static String? routeGuard(BuildContext context, GoRouterState state) {
    final currentRoute = state.matchedLocation;
    
    // Provider에서 현재 상태 가져오기
    final appController = context.read<AppController>();
    final authController = context.read<AuthController>();
    
    // 앱이 아직 초기화되지 않았다면 잠시 대기
    if (!appController.isInitialized) {
      return null; // 초기화 완료까지 대기
    }
    
    // 1. 온보딩 체크 (첫 실행 시)
    final onboardingRedirect = _checkOnboardingGuard(
      currentRoute,
      appController.isOnboardingCompleted,
    );
    if (onboardingRedirect != null) return onboardingRedirect;
    
    // 2. 인증 체크 (로그인 필요 페이지)
    final authRedirect = _checkAuthGuard(
      currentRoute,
      authController.isAuthenticated,
    );
    if (authRedirect != null) return authRedirect;
    
    // 3. 역할 권한 체크 (역할별 접근 제한)
    final roleRedirect = _checkRoleGuard(
      currentRoute,
      authController.currentRole.code,  // UserRole.code로 String 값 추출
    );
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
  static String? _checkOnboardingGuard(String currentRoute, bool isOnboardingCompleted) {
    // 온보딩 관련 페이지는 체크하지 않음
    if (currentRoute == AppRoutes.onboarding) {
      return null;
    }
    
    // 온보딩을 완료하지 않았다면 온보딩 페이지로
    if (!isOnboardingCompleted) {
      return AppRoutes.onboarding;
    }
    
    return null;
  }
  
  /// 인증 가드
  /// 
  /// 로그인이 필요한 페이지에 게스트가 접근하면 로그인 페이지로 리다이렉트
  static String? _checkAuthGuard(String currentRoute, bool isAuthenticated) {
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
  static String? _checkRoleGuard(String currentRoute, String currentUserRole) {
    // 현재 사용자의 권한 레벨
    final currentLevel = AppConstants.roleHierarchy[currentUserRole] ?? 0;
    
    // 관리자 전용 페이지 체크
    if (AppRoutes.adminRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleAdmin] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission(currentUserRole);
      }
    }
    
    // 운영자 전용 페이지 체크
    if (AppRoutes.operatorRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleOperator] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission(currentUserRole);
      }
    }
    
    // 학생 전용 페이지 체크
    if (AppRoutes.studentRoutes.contains(currentRoute)) {
      final requiredLevel = AppConstants.roleHierarchy[AppConstants.roleStudent] ?? 999;
      if (currentLevel < requiredLevel) {
        return _getRedirectForInsufficientPermission(currentUserRole);
      }
    }
    
    return null;
  }
  
  /// 권한 부족 시 리다이렉트할 페이지 결정
  static String _getRedirectForInsufficientPermission(String currentUserRole) {
    switch (currentUserRole) {
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
  
  /// 주의: 다음 유틸리티 함수들은 Provider 컨텍스트가 필요합니다.
  /// 실제 사용 시에는 AuthController에서 직접 호출하거나
  /// BuildContext를 통해 접근해야 합니다.
  
  // TODO: 추후 필요에 따라 Provider 기반으로 리팩토링 예정
  // static bool canAccessRoute(String route, String currentUserRole)
  // static bool hasRoleOrHigher(String requiredRole, String currentUserRole)
  // static bool canAccessBottomNavTab(int tabIndex, String currentUserRole)

  // ============================================================================
  // 디버그 & 테스트 함수들 (Debug & Test Functions)
  // ============================================================================
  
  /// 주의: 디버그 함수들은 Provider 기반으로 리팩토링되었습니다.
  /// 실제 상태 확인은 AppController와 AuthController에서 직접 하거나
  /// Flutter DevTools를 사용하세요.
  
  // TODO: 필요 시 Provider 기반 디버그 함수 추가
  // static void printGuardStatus(BuildContext context)
  // 등등...
}