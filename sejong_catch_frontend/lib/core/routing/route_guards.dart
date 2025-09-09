import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/app_config.dart';
import 'app_routes.dart';

/// Base class for route guards
abstract class RouteGuard {
  Future<bool> canActivate(BuildContext context, GoRouterState state);
  String get redirectRoute;
}

/// Guards for authentication status
class AuthGuard implements RouteGuard {
  @override
  String get redirectRoute => AppRoutes.auth;
  
  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    // TODO: Implement actual auth check
    // For now, assume user is authenticated
    // In real implementation, check AuthState provider
    return await _checkAuthStatus();
  }
  
  Future<bool> _checkAuthStatus() async {
    // Simulate auth check
    // Replace with actual auth logic using AuthState provider
    await Future.delayed(const Duration(milliseconds: 100));
    return true; // For development, always return true
  }
}

/// Guards for role-based access control
class RoleGuard implements RouteGuard {
  final UserRole requiredRole;
  
  const RoleGuard({required this.requiredRole});
  
  @override
  String get redirectRoute => AppRoutes.home;
  
  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    final currentRole = await _getCurrentUserRole();
    return _hasPermission(currentRole, requiredRole);
  }
  
  Future<UserRole> _getCurrentUserRole() async {
    // TODO: Get role from AuthState provider
    // For development, return student role
    await Future.delayed(const Duration(milliseconds: 50));
    return UserRole.student;
  }
  
  bool _hasPermission(UserRole currentRole, UserRole requiredRole) {
    // Define role hierarchy
    const roleHierarchy = {
      UserRole.guest: 0,
      UserRole.student: 1,
      UserRole.operator: 2,
      UserRole.admin: 3,
    };
    
    final currentLevel = roleHierarchy[currentRole] ?? 0;
    final requiredLevel = roleHierarchy[requiredRole] ?? 0;
    
    return currentLevel >= requiredLevel;
  }
}

/// Guards for first-time user experience
class FirstRunGuard implements RouteGuard {
  @override
  String get redirectRoute => AppRoutes.onboarding;
  
  @override
  Future<bool> canActivate(BuildContext context, GoRouterState state) async {
    return await _isOnboardingCompleted();
  }
  
  Future<bool> _isOnboardingCompleted() async {
    // TODO: Check SharedPreferences for onboarding completion
    // For development, assume onboarding is completed
    await Future.delayed(const Duration(milliseconds: 50));
    return true; // Change to false to test onboarding flow
  }
}

/// Student role guard (shorthand)
class StudentGuard extends RoleGuard {
  const StudentGuard() : super(requiredRole: UserRole.student);
}

/// Operator role guard (shorthand)
class OperatorGuard extends RoleGuard {
  const OperatorGuard() : super(requiredRole: UserRole.operator);
}

/// Admin role guard (shorthand)
class AdminGuard extends RoleGuard {
  const AdminGuard() : super(requiredRole: UserRole.admin);
}

/// Route guard utilities
class RouteGuardUtils {
  /// Check multiple guards for a route
  static Future<String?> checkGuards(
    BuildContext context,
    GoRouterState state,
    List<RouteGuard> guards,
  ) async {
    for (final guard in guards) {
      final canActivate = await guard.canActivate(context, state);
      if (!canActivate) {
        return guard.redirectRoute;
      }
    }
    return null;
  }
  
  /// Get guards for a specific route
  static List<RouteGuard> getGuardsForRoute(String route) {
    // Define guards for protected routes
    switch (route) {
      case AppRoutes.bookmarks:
        return [AuthGuard(), const StudentGuard()];
      case AppRoutes.console:
      case AppRoutes.consoleRules:
        return [AuthGuard(), const OperatorGuard()];
      case AppRoutes.consoleStats:
        return [AuthGuard(), const AdminGuard()];
      case AppRoutes.root:
      case AppRoutes.home:
      case AppRoutes.search:
      case AppRoutes.profile:
        return [FirstRunGuard()];
      default:
        return [];
    }
  }
}