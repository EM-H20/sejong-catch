import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/app_router.dart';
import 'core/theme/app_theme.dart';

/// 🚀 세종 캐치 앱 메인 엔트리 포인트
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 환경변수 로드 (.env 파일)
  await dotenv.load(fileName: '.env');

  runApp(ProviderScope(child: const SejongCatchApp()));
}

/// 📱 세종 캐치 메인 앱 위젯
class SejongCatchApp extends ConsumerWidget {
  const SejongCatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      // 🎨 디자인 기준 해상도 (iPhone 14 Pro 기준)
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: '세종 캐치',
          debugShowCheckedModeBanner: false,

          // 🎨 테마 설정 (크림슨 레드 디자인 시스템)
          theme: AppTheme.lightTheme,

          // 🧭 GoRouter 라우팅 설정
          routerConfig: AppRouter.createRouter(
            ProviderScope.containerOf(context),
          ),

          // 📱 시스템 폰트 크기 무시 (일관된 디자인)
          builder: (context, child) {
            return MediaQuery(
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
