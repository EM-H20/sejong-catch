import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/config/app_router.dart';
import 'core/theme/app_theme.dart';

/// 🚀 세종 캐치 앱 메인 엔트리 포인트
///
/// CLAUDE.md 핵심 아키텍처:
/// ✅ Riverpod 3.0 ProviderScope 설정
/// ✅ GoRouter 중앙 집중식 라우팅
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 크림슨 레드 디자인 시스템 적용
void main() {
  // 플러터 바인딩 초기화 (ScreenUtil 사용을 위해 필요)
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // 🧠 Riverpod ProviderScope - 모든 상태 관리의 루트
    ProviderScope(
      observers: [
        // 🐛 개발 모드에서만 Riverpod 로깅 활성화
        if (kDebugMode) _RiverpodLogger(),
      ],
      child: const SejongCatchApp(),
    ),
  );
}

/// 📱 세종 캐치 메인 앱 위젯
class SejongCatchApp extends StatelessWidget {
  const SejongCatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 🎨 디자인 기준 해상도 (iPhone 14 Pro 기준)
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          // 🏷️ 앱 기본 정보
          title: '세종 캐치',
          debugShowCheckedModeBanner: false,

          // 🎨 테마 설정 (크림슨 레드 디자인 시스템)
          theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme, // TODO: 다크 테마 구현 예정

          // 🧭 GoRouter 라우팅 설정
          routerConfig: AppRouter.router,

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
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      debugPrint('''
🔄 Riverpod State Changed:
   Provider: ${context.provider.name ?? context.provider.runtimeType}
   Previous: $previousValue
   New: $newValue
''');
    }
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (kDebugMode) {
      debugPrint('''
➕ Riverpod Provider Added:
   Provider: ${context.provider.name ?? context.provider.runtimeType}
   Value: $value
''');
    }
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (kDebugMode) {
      debugPrint('''
🗑️ Riverpod Provider Disposed:
   Provider: ${context.provider.name ?? context.provider.runtimeType}
''');
    }
  }
}
