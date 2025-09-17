import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/queue/presentation/pages/queue_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// 🧭 세종 캐치 앱의 GoRouter 중앙 설정
///
/// CLAUDE.md 가이드라인:
/// - ShellRoute 기반 BottomNavigationBar 중앙 관리
/// - 각 페이지는 UI만 담당, 네비게이션 로직 분리
/// - 권한 가드 시스템 적용
class AppRouter {
  // 🚫 인스턴스 생성 방지
  AppRouter._();

  /// 🎯 GoRouter 인스턴스 (앱 전체에서 사용)
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // 개발 중 라우팅 로그 활성화
    initialLocation: AppRoutes.feed, // 앱 시작 시 피드 탭으로 이동

    routes: [
      // 🏠 메인 앱 ShellRoute - BottomNavigationBar 포함
      ShellRoute(
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        routes: [
          // 📰 피드 탭 (기본 홈)
          GoRoute(
            path: AppRoutes.feed,
            name: 'feed',
            builder: (context, state) => const FeedPage(),
          ),

          // 🔍 검색 탭
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),

          // 📋 줄서기 탭 (Student 이상 권한 필요)
          GoRoute(
            path: AppRoutes.queue,
            name: 'queue',
            builder: (context, state) => const QueuePage(),
            // TODO: redirect를 통한 권한 가드 추가 예정
          ),

          // 👤 프로필 탭 (Student 이상 권한 필요)
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
            // TODO: redirect를 통한 권한 가드 추가 예정
          ),
        ],
      ),

      // 🔐 인증 페이지 (독립 페이지, BottomNav 없음)
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),

      // 📄 상세 페이지 (독립 페이지)
      GoRoute(
        path: '${AppRoutes.detail}/:id',
        name: 'detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(id: id);
        },
      ),

      // 📱 온보딩 페이지 (독립 페이지)
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      // ⚙️ 설정 페이지 (독립 페이지)
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // 🔧 관리자 콘솔 ShellRoute (별도 네비게이션)
      // TODO: 향후 Operator/Admin 권한용 콘솔 구현 예정
    ],

    // 🛡️ 글로벌 리디렉션 (권한 가드, 온보딩 등)
    redirect: (context, state) {
      // TODO: 사용자 인증 상태 확인 로직 구현
      // TODO: 온보딩 완료 여부 확인
      // TODO: 권한별 접근 제한 구현

      // 개발 중에는 모든 라우트 허용
      return null;
    },

    // ❌ 에러 페이지 (라우트를 찾을 수 없는 경우)
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('페이지를 찾을 수 없음')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '요청하신 페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('경로: ${state.uri.path}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.feed),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
}

// 📄 임시 상세 페이지 (실제 구현 전까지 사용)
class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세 페이지 #$id'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '상세 페이지',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('ID: $id'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}

// 📱 임시 온보딩 페이지
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.waving_hand, size: 64),
            const SizedBox(height: 16),
            Text(
              '세종 캐치에 오신 걸 환영해요!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.feed),
              child: const Text('시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}

// ⚙️ 임시 설정 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(
        child: Text('설정 페이지 (추후 구현 예정)'),
      ),
    );
  }
}