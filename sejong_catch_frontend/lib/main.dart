import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/config/app_router.dart';
import 'core/config/app_mode.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'features/onboarding/data/services/onboarding_service.dart';

/// 🚀 세종 캐치 앱 메인 엔트리 포인트
///
/// CLAUDE.md 핵심 아키텍처:
/// ✅ Riverpod 3.0 ProviderScope 설정
/// ✅ GoRouter 중앙 집중식 라우팅
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 크림슨 레드 디자인 시스템 적용
void main() async {
  // 플러터 바인딩 초기화 (SharedPreferences 사용을 위해 필요)
  WidgetsFlutterBinding.ensureInitialized();

  // 🎯 앱 모드 초기화 (가장 먼저!)
  AppModeManager.initialize(AppModeManager.getModeFromConfig());

  // 📊 앱 시작 로깅
  AppLogger.info('''세종 캐치 앱 시작
📱 모드: ${AppModeManager.modeString}
🌐 API: ${AppModeManager.apiBaseUrl}
🔧 개발자 도구: ${AppModeManager.showDeveloperTools ? 'ON' : 'OFF'}
👁️ 온보딩 항상 표시: ${AppModeManager.shouldShowOnboardingAlways ? 'ON' : 'OFF'}''');

  // SharedPreferences 초기화
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    // 🧠 Riverpod ProviderScope - 모든 상태 관리의 루트
    ProviderScope(
      overrides: [
        // SharedPreferences Provider 초기화
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        // OnboardingService Provider 초기화
        onboardingServiceProvider.overrideWithValue(
          OnboardingService(sharedPreferences),
        ),
      ],
      observers: [
        // 🐛 디버그 모드에서만 Riverpod 로깅 활성화
        if (AppModeManager.isDebugEnabled) _RiverpodLogger(),
      ],
      child: const SejongCatchApp(),
    ),
  );
}

/// 📱 세종 캐치 메인 앱 위젯
class SejongCatchApp extends ConsumerStatefulWidget {
  const SejongCatchApp({super.key});

  @override
  ConsumerState<SejongCatchApp> createState() => _SejongCatchAppState();
}

class _SejongCatchAppState extends ConsumerState<SejongCatchApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🎯 ProviderContainer와 연결된 라우터 생성
    // AppMode에 따른 동적 라우팅 설정
    _router ??= AppRouter.createRouter(ProviderScope.containerOf(context));
  }

  @override
  Widget build(BuildContext context) {
    // 라우터가 초기화되지 않은 경우 로딩 표시
    if (_router == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ScreenUtilInit(
      // 🎨 디자인 기준 해상도 (iPhone 14 Pro 기준)
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          // 🏷️ 앱 기본 정보
          title:
              '세종 캐치 ${AppModeManager.isProduction ? '' : '(${AppModeManager.modeString})'}',
          debugShowCheckedModeBanner: AppModeManager.showDeveloperTools,

          // 🎨 테마 설정 (크림슨 레드 디자인 시스템)
          theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme, // TODO: 다크 테마 구현 예정

          // 🧭 GoRouter 라우팅 설정 (ProviderContainer 연결됨!)
          routerConfig: _router!,

          // 📱 앱 메타데이터
          builder: (context, child) {
            return MediaQuery(
              // 📱 시스템 폰트 크기 무시 (일관된 디자인을 위해)
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
        );
      },
    );
  }
}

/// 🐛 Riverpod 상태 변경 로거 (개발 모드 전용)
final class _RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    AppLogger.state(
      provider.name ?? provider.runtimeType.toString(),
      previousValue,
      newValue,
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    AppLogger.debug(
      'Riverpod Provider Added: ${provider.name ?? provider.runtimeType} = $value',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    AppLogger.debug(
      'Riverpod Provider Disposed: ${provider.name ?? provider.runtimeType}',
    );
  }
}
