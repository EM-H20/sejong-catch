import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'route_guards.dart';
import '../widgets/navigation/app_bottom_nav.dart';

// Temporary placeholder widgets until features are implemented
class OnboardingFlowPage extends StatelessWidget {
  const OnboardingFlowPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('온보딩')),
      body: const Center(
        child: Text('온보딩 플로우 페이지\n(구현 예정)'),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('인증 페이지\n(구현 예정)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}

class RootShell extends StatelessWidget {
  final Widget child;
  
  const RootShell({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '북마크',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
  
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.search)) return 1;
    if (location.startsWith(AppRoutes.bookmarks)) return 2;
    if (location.startsWith(AppRoutes.notifications)) return 3;
    if (location.startsWith(AppRoutes.profile)) return 4;
    return 0;
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.search);
        break;
      case 2:
        context.go(AppRoutes.bookmarks);
        break;
      case 3:
        context.go(AppRoutes.notifications);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

// Temporary feature pages
class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈 피드')),
      body: const Center(child: Text('홈 피드 페이지\n(구현 예정)')),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('검색')),
      body: const Center(child: Text('검색 페이지\n(구현 예정)')),
    );
  }
}

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('북마크')),
      body: const Center(child: Text('북마크 페이지\n(구현 예정)')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림')),
      body: const Center(child: Text('알림 페이지\n(향후 구현 예정)')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: const Center(child: Text('프로필 페이지\n(구현 예정)')),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String id;
  
  const DetailPage({super.key, required this.id});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세보기')),
      body: Center(child: Text('상세보기 페이지\nID: $id\n(구현 예정)')),
    );
  }
}

class ConsolePage extends StatelessWidget {
  const ConsolePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관리 콘솔')),
      body: const Center(child: Text('관리 콘솔\n(구현 예정)')),
    );
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    
    redirect: (context, state) async {
      final guards = RouteGuardUtils.getGuardsForRoute(state.uri.path);
      if (guards.isNotEmpty) {
        return await RouteGuardUtils.checkGuards(context, state, guards);
      }
      return null;
    },
    
    routes: [
      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlowPage(),
      ),
      
      // Auth route
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      
      // Shell route for bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // Home route
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeFeedPage(),
          ),
          
          // Search route
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          
          // Bookmarks route
          GoRoute(
            path: AppRoutes.bookmarks,
            name: 'bookmarks',
            builder: (context, state) => const BookmarksPage(),
          ),
          
          // Notifications route
          GoRoute(
            path: AppRoutes.notifications,
            name: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          
          // Profile route
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      
      // Detail route (outside shell)
      GoRoute(
        path: '${AppRoutes.detail}/:${AppRoutes.detailIdParam}',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters[AppRoutes.detailIdParam] ?? '';
          return DetailPage(id: id);
        },
      ),
      
      // Console routes (outside shell)
      GoRoute(
        path: AppRoutes.console,
        name: 'console',
        builder: (context, state) => const ConsolePage(),
        routes: [
          // Rules management
          GoRoute(
            path: 'rules',
            name: 'console-rules',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('규칙 관리')),
              body: const Center(child: Text('규칙 관리 페이지\n(구현 예정)')),
            ),
          ),
          
          // Stats dashboard
          GoRoute(
            path: 'stats',
            name: 'console-stats',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('통계 대시보드')),
              body: const Center(child: Text('통계 대시보드\n(구현 예정)')),
            ),
          ),
        ],
      ),
      
      // Settings route
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('설정')),
          body: const Center(child: Text('설정 페이지\n(구현 예정)')),
        ),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('페이지를 찾을 수 없습니다')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('경로를 찾을 수 없습니다: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
}