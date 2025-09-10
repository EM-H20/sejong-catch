import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/core.dart';
import 'core/widgets/examples/widget_showcase.dart';

void main() {
  runApp(const SejongCatchApp());
}

class SejongCatchApp extends StatelessWidget {
  const SejongCatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Sejong Catch',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          home: const _HomePage(),
        );
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      appBar: AppBar(
        title: Text(
          'Sejong Catch',
          style: AppTextStyles.title2.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
        backgroundColor: AppColors.surface(context),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 로고 영역 (assets이 없어도 괜찮게 아이콘으로 대체)
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(Icons.school, size: 60.w, color: AppColors.primary),
            ),

            SizedBox(height: 24.h),

            Text(
              '세종캐치 UI 컴포넌트',
              style: AppTextStyles.title3.copyWith(
                color: AppColors.textPrimary(context),
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Nucleus UI 기반 60+ 위젯 컬렉션',
              style: AppTextStyles.smallRegular.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),

            SizedBox(height: 32.h),

            // 테마별 위젯 쇼케이스 버튼들
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton(
                    text: '☀️ 라이트 테마',
                    onPressed: () => _openShowcase(context, ThemeMode.light),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: AppSecondaryButton(
                    text: '🌙 다크 테마',
                    onPressed: () => _openShowcase(context, ThemeMode.dark),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            AppTextButton(
              text: '🎨 시스템 테마로 구경하기',
              onPressed: () => _openShowcase(context, ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }

  /// 특정 테마로 위젯 쇼케이스 열기
  /// 개발자가 라이트/다크 테마별로 컴포넌트를 확인할 수 있게 해주는 헬퍼 메서드
  void _openShowcase(BuildContext context, ThemeMode themeMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ThemedShowcase(themeMode: themeMode),
      ),
    );
  }
}

/// 특정 테마로 고정된 위젯 쇼케이스 래퍼
/// MaterialApp으로 테마를 강제 적용하여 개발자가 각 테마에서의 모습을 확인할 수 있게 함
class _ThemedShowcase extends StatelessWidget {
  final ThemeMode themeMode;

  const _ThemedShowcase({required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Sejong Catch - ${_getThemeName()} 테마',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeMode,
          home: const WidgetShowcase(),
        );
      },
    );
  }

  String _getThemeName() {
    switch (themeMode) {
      case ThemeMode.light:
        return '라이트';
      case ThemeMode.dark:
        return '다크';
      case ThemeMode.system:
        return '시스템';
    }
  }
}
