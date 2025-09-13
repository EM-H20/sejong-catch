import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/widgets/navigation/app_bottom_nav.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/app_colors.dart';


/// 메인 쉘 페이지
///
/// 바텀 네비게이션이 포함된 메인 앱 구조를 담당합니다.
/// 각 탭 페이지들을 자식으로 받아서 표시하며,
/// 인덱스 기반 슬라이드 애니메이션과 함께 네비게이션 상태를 관리합니다.
class RootShellPage extends StatefulWidget {
  /// 현재 표시할 페이지 위젯
  final Widget child;

  const RootShellPage({super.key, required this.child});

  @override
  State<RootShellPage> createState() => _RootShellPageState();
}

/// RootShellPage의 상태 관리 클래스
///
/// PageView와 PageController를 사용한 안정적인 슬라이드 애니메이션을 제공합니다.
/// GlobalKey 충돌 없이 토스처럼 자연스러운 좌우 슬라이드 전환을 구현해요! ✨
class _RootShellPageState extends State<RootShellPage> {
  /// PageView 제어를 위한 컨트롤러
  late PageController _pageController;

  /// 현재 탭 인덱스
  int _currentIndex = 0;

  /// 탭 페이지들 (라우트별로 관리)
  final List<String> _tabRoutes = AppRoutes.bottomNavRoutes;

  @override
  void initState() {
    super.initState();
    // PageController 초기화 (초기 페이지는 현재 인덱스)
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // 메모리 누수 방지
    _pageController.dispose();
    super.dispose();
  }


  /// 탭 인덱스 업데이트 및 PageView 애니메이션 트리거
  ///
  /// 라우트 변경 시 탭 인덱스를 업데이트하고 PageController로 애니메이션을 실행합니다.
  void _updateTabIndex(String currentRoute) {
    final newIndex = AppRoutes.getTabIndex(currentRoute);

    if (newIndex != _currentIndex && _pageController.hasClients) {
      setState(() {
        _currentIndex = newIndex;
      });

      // PageView 애니메이션 실행 (토스 스타일!)
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn, // 토스에서 사용하는 자연스러운 커브
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // 현재 라우트 경로 가져오기
    final String currentRoute = GoRouterState.of(context).matchedLocation;

    // 탭 인덱스 업데이트 (라우트 변경 감지)
    _updateTabIndex(currentRoute);

    return Scaffold(
      // 메인 콘텐츠 영역 - PageView 기반 토스급 슬라이드 애니메이션! ✨
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 스와이프 비활성화 (바텀네비만)
        itemCount: _tabRoutes.length,
        itemBuilder: (context, index) {
          // 현재 인덱스가 맞는 경우에만 실제 페이지 표시
          if (index == _currentIndex) {
            return widget.child;
          } else {
            // 다른 인덱스는 빈 컨테이너 (메모리 절약)
            return Container(
              key: ValueKey('empty-$index'),
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          }
        },
      ),

      // 바텀 네비게이션 (조건부 표시)
      bottomNavigationBar: _shouldShowBottomNav(currentRoute)
          ? Container(
              // 바텀 네비게이션 그림자 효과
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 8.r,
                    offset: Offset(0, -2.h),
                  ),
                ],
              ),
              child: AppBottomNav(
                currentIndex: AppRoutes.getTabIndex(currentRoute),
                onTap: (index) => _onTabTapped(context, index),
                // TODO: 실제 알림 데이터와 연결
                badges: _getMockBadges(),
              ),
            )
          : null,
    );
  }

  /// 바텀 네비게이션을 표시할지 결정
  ///
  /// 메인 탭 라우트에서만 바텀 네비게이션을 표시하고,
  /// 상세 페이지나 설정 페이지에서는 숨깁니다.
  bool _shouldShowBottomNav(String route) {
    // 메인 탭 라우트에서만 바텀 네비게이션 표시
    return AppRoutes.isBottomNavRoute(route);
  }

  /// 탭 선택 시 처리
  ///
  /// GoRouter를 사용해서 해당 탭의 라우트로 이동합니다.
  /// 애니메이션과 함께 자연스러운 전환을 제공해요.
  void _onTabTapped(BuildContext context, int index) {
    final route = AppRoutes.getRouteFromIndex(index);

    // 현재 페이지와 같으면 아무것도 하지 않음
    final currentRoute = GoRouterState.of(context).matchedLocation;
    if (currentRoute == route) return;

    // 해당 탭으로 이동
    context.go(route);

    // 탭 변경 시 부드러운 햅틱 피드백
    _triggerHapticFeedback();
  }

  /// 햅틱 피드백 트리거
  ///
  /// 탭 전환 시 미세한 진동으로 사용자 경험을 향상시켜요.
  void _triggerHapticFeedback() {
    // TODO: HapticFeedback.lightImpact() 추가
    // HapticFeedback.lightImpact();
  }

  /// 임시 배지 데이터
  ///
  /// 실제 앱에서는 Provider나 서버에서 데이터를 가져와야 해요.
  Map<int, int>? _getMockBadges() {
    return {
      1: 3, // 검색 탭에 3개 알림 (예: 새로운 키워드 결과)
      2: 1, // 대기열 탭에 1개 알림 (예: 대기 순서 변경)
      // 0(피드), 3(프로필)은 배지 없음
    };
  }
}

/// 바텀 네비게이션이 없는 풀스크린 쉘
///
/// 온보딩, 인증, 상세 페이지 등에서 사용할
/// 바텀 네비게이션이 없는 버전입니다.
class FullScreenShell extends StatelessWidget {
  /// 현재 표시할 페이지 위젯
  final Widget child;

  /// 뒤로가기 버튼 표시 여부
  final bool showBackButton;

  /// 커스텀 AppBar (선택사항)
  final PreferredSizeWidget? appBar;

  const FullScreenShell({
    super.key,
    required this.child,
    this.showBackButton = true,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 커스텀 AppBar가 있으면 사용, 없으면 기본 AppBar
      appBar: appBar ?? (showBackButton ? _buildDefaultAppBar(context) : null),

      // 메인 콘텐츠
      body: child,
    );
  }

  /// 기본 AppBar 구성
  PreferredSizeWidget _buildDefaultAppBar(BuildContext context) {
    return AppBar(
      // 투명 배경 (extendBodyBehindAppBar와 함께 사용)
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,

      // 뒤로가기 버튼
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20.w,
          color: AppColors.textPrimary,
        ),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            // 메인 페이지로 이동
            context.go(AppRoutes.feed);
          }
        },
      ),
    );
  }
}

/// 에러 바운더리 쉘
///
/// 예상치 못한 에러가 발생했을 때 사용자에게
/// 친화적인 에러 화면을 보여주는 쉘입니다.
class ErrorBoundaryShell extends StatelessWidget {
  /// 에러 메시지
  final String errorMessage;

  /// 재시도 콜백
  final VoidCallback? onRetry;

  const ErrorBoundaryShell({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('문제가 발생했어요'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 에러 아이콘
              Icon(Icons.error_outline, size: 64.w, color: AppColors.error),
              SizedBox(height: 24.h),

              // 에러 제목
              Text(
                '앗! 문제가 발생했어요',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // 에러 설명
              Text(
                '잠시 후 다시 시도해보시거나\n홈으로 돌아가주세요.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              // 액션 버튼들
              Column(
                children: [
                  // 재시도 버튼
                  if (onRetry != null)
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: Icon(Icons.refresh, size: 20.w),
                        label: Text('다시 시도', style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),

                  SizedBox(height: 12.h),

                  // 홈으로 가기 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.feed),
                      icon: Icon(Icons.home, size: 20.w),
                      label: Text(
                        '홈으로 돌아가기',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),

              // 개발 모드에서만 에러 상세 정보 표시
              if (_isDebugMode) ...[
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '개발자 정보:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        errorMessage,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 디버그 모드 확인
  bool get _isDebugMode {
    // assert는 디버그 모드에서만 실행됨
    bool isDebug = false;
    assert(isDebug = true);
    return isDebug;
  }
}
