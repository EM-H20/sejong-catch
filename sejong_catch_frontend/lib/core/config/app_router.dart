import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_routes.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/feed/presentation/pages/feed_detail_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/queue/presentation/pages/queue_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../services/token_storage_service.dart';
import '../theme/app_spacing.dart';

/// 🧭 세종 캐치 앱의 GoRouter 중앙 설정
///
/// CLAUDE.md 가이드라인:
/// - ShellRoute 기반 BottomNavigationBar 중앙 관리
/// - 각 페이지는 UI만 담당, 네비게이션 로직 분리
/// - 권한 가드 시스템 적용
class AppRouter {
  // 🚫 인스턴스 생성 방지
  AppRouter._();

  // 🎯 GoRouter 인스턴스 생성 (ProviderContainer 필요)
  static GoRouter createRouter(ProviderContainer container) {
    return GoRouter(
      initialLocation: AppRoutes.feed, // 앱 시작 시 피드 시도 → redirect에서 상태별 자동 라우팅

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
            // 큐 생성은 QueuePage 내부 바텀시트로 처리됨
            GoRoute(
              path: AppRoutes.queue,
              name: 'queue',
              builder: (context, state) => const QueuePage(),
            ),

            // 👤 프로필 탭 (Student 이상 권한 필요)
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
              routes: [
                // ⚙️ 설정 페이지 (프로필 하위 페이지, BottomNav 유지)
                GoRoute(
                  path: 'settings',
                  name: 'profile_settings',
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),

        // 🔐 인증 페이지 (독립 페이지, BottomNav 없음)
        GoRoute(
          path: AppRoutes.auth,
          name: 'auth',
          builder: (context, state) => const AuthPage(),
        ),

        // 📱 온보딩 페이지 (독립 페이지, BottomNav 없음)
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingPage(),
        ),

        // 📄 피드 상세 페이지 (독립 페이지, BottomNav 없음, 전체 화면)
        GoRoute(
          path: '/feed/detail/:id',
          name: 'feed_detail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FeedDetailPage(id: id);
          },
        ),

        // 🔍 검색 결과 상세 페이지 (독립 페이지, BottomNav 없음, 전체 화면)
        GoRoute(
          path: '/search/detail/:id',
          name: 'search_detail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return FeedDetailPage(id: id);
          },
        ),

        // 🔧 관리자 콘솔 ShellRoute (별도 네비게이션)
        // TODO: 향후 Operator/Admin 권한용 콘솔 구현 예정
      ],

      // 🛡️ 글로벌 리디렉션 (권한 가드, 온보딩 등)
      redirect: (context, state) async {
        final currentPath = state.uri.path;

        // ✅ 로그인 페이지나 온보딩 페이지는 리디렉션 하지 않음 (무한 루프 방지)
        if (currentPath == AppRoutes.auth ||
            currentPath == AppRoutes.onboarding) {
          return null;
        }

        // 1️⃣ 인증 상태 확인 (토큰 존재 여부 체크)
        try {
          final tokenStorage = container.read(
            tokenStorageServiceProvider.notifier,
          );
          final accessToken = await tokenStorage.getAccessToken();

          // 토큰이 없으면 → 로그인 페이지로 (온보딩은 로그인 후)
          // (이미 125-129줄에서 auth 경로는 리디렉션 방지됨)
          if (accessToken == null || accessToken.isEmpty) {
            return AppRoutes.auth;
          }

          // ✅ 토큰 있음 → 인증된 상태, 계속 진행
          // TODO: 2️⃣ 온보딩 완료 여부 확인 (SharedPreferences)
          // TODO: 3️⃣ 권한별 접근 제한 구현 (role guard)

          return null;
        } catch (e) {
          // Storage 에러 등 예외 발생 시 → 안전하게 로그인으로 이동
          debugPrint('[AppRouter] Error during redirect: $e');
          return currentPath == AppRoutes.auth ? null : AppRoutes.auth;
        }
      },

      // ❌ 에러 페이지 (라우트를 찾을 수 없는 경우)
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('페이지를 찾을 수 없음')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              AppSpacing.verticalSpaceLG,
              Text(
                '요청하신 페이지를 찾을 수 없습니다',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              AppSpacing.verticalSpaceSM,
              Text('경로: ${state.uri.path}'),
              AppSpacing.verticalSpaceXXL,
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

  /// 🎯 기본 GoRouter 인스턴스 (ProviderContainer 없이 사용, 온보딩 가드 비활성화)
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.feed,
    routes: [
      // 🏠 메인 앱 ShellRoute - BottomNavigationBar 포함
      ShellRoute(
        builder: (context, state, child) {
          return HomeShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.feed,
            name: 'feed',
            builder: (context, state) => const FeedPage(),
          ),
          GoRoute(
            path: AppRoutes.search,
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: AppRoutes.queue,
            name: 'queue',
            builder: (context, state) => const QueuePage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // 독립 페이지들
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
    ],
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
            Text('상세 페이지', style: Theme.of(context).textTheme.headlineMedium),
            AppSpacing.verticalSpaceLG,
            Text('ID: $id'),
            AppSpacing.verticalSpaceXXL,
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

// ⚙️ 임시 설정 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('설정 페이지 (추후 구현 예정)')),
    );
  }
}
