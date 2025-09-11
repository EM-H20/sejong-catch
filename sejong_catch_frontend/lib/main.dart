import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

// Controller imports
import 'domain/controllers/app_controller.dart';
import 'domain/controllers/auth_controller.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';

/// 세종 캐치 앱의 진입점
/// 
/// 앱의 핵심 설정만을 담당합니다:
/// - ScreenUtil로 반응형 디자인 초기화
/// - MultiProvider로 상태관리 설정
/// - GoRouter로 라우팅 관리
/// - 테마 설정
void main() async {
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();
  
  // 앱 실행
  runApp(const SejongCatchApp());
}

/// 세종 캐치 메인 앱 위젯
/// 
/// MultiProvider로 상태관리를 설정하고,
/// ScreenUtil로 반응형 디자인을 초기화하며,
/// 라우터와 테마 설정을 관리하는 최상위 위젯입니다.
class SejongCatchApp extends StatelessWidget {
  const SejongCatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 앱 전체 상태 관리 (첫 실행, 온보딩 완료, 사용자 설정)
        ChangeNotifierProvider(
          create: (_) => AppController()..initialize(),
        ),
        
        // 인증 상태 관리 (로그인/로그아웃, 사용자 정보)
        ChangeNotifierProvider(
          create: (_) => AuthController()..initialize(),
        ),
        
        // 온보딩 진행 상태 관리 (4단계 플로우, 설정 수집)
        ChangeNotifierProvider(
          create: (_) => OnboardingController(),
        ),
      ],
      child: ScreenUtilInit(
        // 디자인 기준: iPhone 12 Pro (375x812)
        // 모든 UI 요소가 이 비율에 맞춰 반응형으로 동작해요
        designSize: const Size(375, 812),
        minTextAdapt: true,        // 최소 텍스트 크기 보장
        splitScreenMode: true,     // 분할 화면 지원
        builder: (context, child) {
          return MaterialApp.router(
            // 앱 기본 정보
            title: '세종 캐치',
            debugShowCheckedModeBanner: false,
            
            // 테마 설정 (크림슨 브랜드 테마 적용)
            theme: AppTheme.theme(),
            
            // 라우터 설정 (app_router.dart에서 관리)
            routerConfig: AppRouter.instance,
            
            // 로케일 설정
            locale: const Locale('ko', 'KR'),
            supportedLocales: const [
              Locale('ko', 'KR'),  // 한국어
              Locale('en', 'US'),  // 영어 (나중에 다국어 지원용)
            ],
            
            // Localization delegates 설정
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}