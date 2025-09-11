import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'route_guards.dart';

// Feature page imports
import '../../features/shell/pages/root_shell_page.dart';
import '../../features/feed/pages/feed_page.dart';
import '../../features/search/pages/search_page.dart';
import '../../features/queue/pages/queue_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/onboarding/pages/onboarding_flow_page.dart';
import '../../features/auth/pages/login_page.dart';

/// 세종 캐치 앱의 메인 라우터 설정
///
/// GoRouter를 사용해서 전체 앱의 네비게이션을 관리합니다.
/// 역할 기반 접근 제어, 딥링크, 상태 복원 등을 지원해요.
class AppRouter {
  // Private constructor - 인스턴스 생성 방지
  AppRouter._();

  /// GoRouter 인스턴스 (싱글톤)
  static GoRouter? _router;

  /// GoRouter 인스턴스 반환
  static GoRouter get instance {
    _router ??= _createRouter();
    return _router!;
  }

  /// 라우터 재설정 (테스트용)
  static void reset() {
    _router = null;
  }

  // ============================================================================
  // 라우터 생성 (Router Creation)
  // ============================================================================

  /// GoRouter 인스턴스 생성
  static GoRouter _createRouter() {
    return GoRouter(
      // 라우트 가드 설정 - 모든 라우트 변경 시 권한 체크
      redirect: RouteGuards.routeGuard,

      // 초기 라우트 (앱 시작 시 표시할 페이지)
      initialLocation: AppRoutes.feed,

      // 딥링크 처리를 위한 라우트 매칭 전략
      routerNeglect: false,

      // 디버그 로그 활성화 (개발 모드에서만)
      debugLogDiagnostics: true,

      // 라우트 정의
      routes: [
        // ======================================================================
        // 온보딩 & 인증 라우트
        // ======================================================================
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingFlowPage(),
        ),

        GoRoute(
          path: AppRoutes.auth,
          name: 'auth',
          builder: (context, state) {
            // 리다이렉트 URL 파라미터 처리
            final redirectUrl = state.uri.queryParameters['redirect'];
            return LoginPage(redirectUrl: redirectUrl);
          },
        ),

        // ======================================================================
        // 메인 쉘 라우트 (바텀 네비게이션)
        // ======================================================================
        ShellRoute(
          builder: (context, state, child) {
            return RootShellPage(child: child);
          },
          routes: [
            // 피드 페이지 (메인 홈)
            GoRoute(
              path: AppRoutes.feed,
              name: 'feed',
              builder: (context, state) => const FeedPage(),
            ),

            // 검색 페이지
            GoRoute(
              path: AppRoutes.search,
              name: 'search',
              builder: (context, state) => const SearchPage(),
            ),

            // 대기열 페이지 (학생 이상만 접근)
            GoRoute(
              path: AppRoutes.queue,
              name: 'queue',
              builder: (context, state) => const QueuePage(),
            ),

            // 프로필 페이지 (학생 이상만 접근)
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),

        // ======================================================================
        // 상세 & 하위 페이지 라우트
        // ======================================================================
        GoRoute(
          path: '${AppRoutes.detail}/:id',
          name: 'detail',
          builder: (context, state) {
            final itemId = state.pathParameters['id']!;
            return DetailPlaceholder(itemId: itemId);
          },
        ),

        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPlaceholder(),
        ),

        GoRoute(
          path: AppRoutes.bookmarks,
          name: 'bookmarks',
          builder: (context, state) => const BookmarksPlaceholder(),
        ),

        // ======================================================================
        // 관리자 콘솔 라우트
        // ======================================================================
        ShellRoute(
          builder: (context, state, child) {
            return ConsoleShell(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.console,
              name: 'console',
              builder: (context, state) => const ConsolePlaceholder(),
            ),

            GoRoute(
              path: AppRoutes.consoleRules,
              name: 'console-rules',
              builder: (context, state) => const ConsoleRulesPlaceholder(),
            ),

            GoRoute(
              path: AppRoutes.consoleStats,
              name: 'console-stats',
              builder: (context, state) => const ConsoleStatsPlaceholder(),
            ),

            GoRoute(
              path: AppRoutes.consoleUsers,
              name: 'console-users',
              builder: (context, state) => const ConsoleUsersPlaceholder(),
            ),
          ],
        ),

        // ======================================================================
        // 기타 유틸리티 라우트
        // ======================================================================
        GoRoute(
          path: AppRoutes.help,
          name: 'help',
          builder: (context, state) => const HelpPlaceholder(),
        ),

        GoRoute(
          path: AppRoutes.privacy,
          name: 'privacy',
          builder: (context, state) => const PrivacyPlaceholder(),
        ),

        GoRoute(
          path: AppRoutes.terms,
          name: 'terms',
          builder: (context, state) => const TermsPlaceholder(),
        ),

        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          builder: (context, state) => const AboutPlaceholder(),
        ),
      ],

      // 에러 페이지 처리
      errorBuilder: (context, state) => ErrorPlaceholder(
        error: state.error.toString(),
        location: state.matchedLocation,
      ),
    );
  }

  // ============================================================================
  // 네비게이션 헬퍼 메서드들 (Navigation Helpers)
  // ============================================================================

  /// 현재 컨텍스트에서 라우트로 이동
  static void go(BuildContext context, String route) {
    context.go(route);
  }

  /// 현재 컨텍스트에서 라우트를 푸시 (뒤로가기 가능)
  static void push(BuildContext context, String route) {
    context.push(route);
  }

  /// 현재 컨텍스트에서 뒤로가기
  static void pop(BuildContext context) {
    context.pop();
  }

  /// 상세 페이지로 이동
  static void goToDetail(BuildContext context, String itemId) {
    context.go(AppRoutes.detailPath(itemId));
  }

  /// 검색 페이지로 이동 (초기 검색어 포함)
  static void goToSearch(BuildContext context, {String? query}) {
    final route = query != null
        ? '${AppRoutes.search}?q=${Uri.encodeComponent(query)}'
        : AppRoutes.search;
    context.go(route);
  }

  /// 인증 페이지로 이동 (리다이렉트 URL 포함)
  static void goToAuth(BuildContext context, {String? redirectUrl}) {
    final route = redirectUrl != null
        ? '${AppRoutes.auth}?redirect=${Uri.encodeComponent(redirectUrl)}'
        : AppRoutes.auth;
    context.go(route);
  }

  /// 바텀 네비게이션 탭으로 이동
  static void goToTab(BuildContext context, int tabIndex) {
    final route = AppRoutes.getRouteFromIndex(tabIndex);
    context.go(route);
  }
}

// ============================================================================
// 임시 플레이스홀더 위젯들 (Temporary Placeholder Widgets)
// ============================================================================
// 실제 페이지 구현 전까지 사용할 임시 위젯들입니다.
// features/ 디렉토리의 실제 페이지들로 교체될 예정이에요.

/// 온보딩 페이지 플레이스홀더
class OnboardingPlaceholder extends StatelessWidget {
  const OnboardingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('온보딩')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64),
            SizedBox(height: 16),
            Text('세종 캐치에 오신 것을 환영합니다!'),
            SizedBox(height: 8),
            Text('온보딩 플로우가 여기에 구현될 예정입니다.'),
          ],
        ),
      ),
    );
  }
}

/// 인증 페이지 플레이스홀더
class AuthPlaceholder extends StatelessWidget {
  final String? redirectUrl;

  const AuthPlaceholder({super.key, this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 64),
            const SizedBox(height: 16),
            const Text('로그인 페이지'),
            if (redirectUrl != null) ...[
              const SizedBox(height: 8),
              Text('로그인 후 이동: $redirectUrl'),
            ],
          ],
        ),
      ),
    );
  }
}

// MainShell 클래스는 RootShellPage로 대체되어 제거됨

/// 관리자 콘솔 쉘
class ConsoleShell extends StatelessWidget {
  final Widget child;

  const ConsoleShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 콘솔'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: child,
    );
  }
}

// 메인 4개 페이지는 features/ 폴더의 실제 페이지로 대체됨

class DetailPlaceholder extends StatelessWidget {
  final String itemId;
  const DetailPlaceholder({super.key, required this.itemId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상세: $itemId')),
      body: Center(child: Text('아이템 ID: $itemId')),
    );
  }
}

class SettingsPlaceholder extends StatelessWidget {
  const SettingsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('설정 페이지')));
  }
}

class BookmarksPlaceholder extends StatelessWidget {
  const BookmarksPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('북마크 페이지')));
  }
}

class ConsolePlaceholder extends StatelessWidget {
  const ConsolePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('관리자 콘솔 메인'));
  }
}

class ConsoleRulesPlaceholder extends StatelessWidget {
  const ConsoleRulesPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('수집 규칙 관리'));
  }
}

class ConsoleStatsPlaceholder extends StatelessWidget {
  const ConsoleStatsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('통계 대시보드'));
  }
}

class ConsoleUsersPlaceholder extends StatelessWidget {
  const ConsoleUsersPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('사용자 관리'));
  }
}

class HelpPlaceholder extends StatelessWidget {
  const HelpPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('도움말 페이지')));
  }
}

class PrivacyPlaceholder extends StatelessWidget {
  const PrivacyPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('개인정보 처리방침')));
  }
}

class TermsPlaceholder extends StatelessWidget {
  const TermsPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('이용약관')));
  }
}

class AboutPlaceholder extends StatelessWidget {
  const AboutPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('앱 정보')));
  }
}

class ErrorPlaceholder extends StatelessWidget {
  final String error;
  final String location;

  const ErrorPlaceholder({
    super.key,
    required this.error,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('페이지 오류')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('페이지를 찾을 수 없습니다'),
            const SizedBox(height: 8),
            Text('경로: $location'),
            const SizedBox(height: 8),
            Text('오류: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.feed),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
