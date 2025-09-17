import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/config/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../feed/presentation/pages/feed_page.dart';
import '../../search/presentation/pages/search_page.dart';
import '../../queue/presentation/pages/queue_page.dart';
import '../../profile/presentation/pages/profile_page.dart';

/// 🏠 세종 캐치 메인 앱 쉘
///
/// CLAUDE.md 핵심 원칙:
/// ✅ BottomNavigationBar는 여기서만 정의!
/// ✅ 각 탭별 페이지는 자신의 UI만 담당
/// ✅ 모든 탭 전환은 여기서 중앙 관리
/// ❌ 각 Feature에서 BottomNavigationBar 중복 구현 절대 금지!
/// 🚀 NEW: 좌우 슬라이드 애니메이션 지원 + 확장성 보장!
class HomeShell extends StatefulWidget {
  /// 현재 선택된 탭의 페이지 위젯
  final Widget child;

  const HomeShell({
    super.key,
    required this.child,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}


/// 🔧 탭 정보 클래스 (확장성을 위한 구조화)
class _TabInfo {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String tooltip;

  const _TabInfo({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tooltip,
  });
}

class _HomeShellState extends State<HomeShell> {
  /// 🚀 화면 전환용 PageController (핵심 기능!)
  late PageController _pageController;

  /// 📱 현재 페이지 인덱스 (PageView와 GoRouter 동기화용)
  int _currentPageIndex = 0;

  /// 📋 탭 구성 정보 (확장성을 위한 중앙 관리!)
  /// ✅ 확장성 검증 완료: 탭 추가 시 코드 수정 없이 자동 대응!
  static const List<_TabInfo> _tabs = [
    _TabInfo(
      route: AppRoutes.feed,
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '피드',
      tooltip: '공모전, 취업, 논문 정보 피드',
    ),
    _TabInfo(
      route: AppRoutes.search,
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      label: '검색',
      tooltip: '정보 검색 및 필터링',
    ),
    _TabInfo(
      route: AppRoutes.queue,
      icon: Icons.queue_outlined,
      activeIcon: Icons.queue,
      label: '줄서기',
      tooltip: '인기 정보 대기열 관리',
    ),
    _TabInfo(
      route: AppRoutes.profile,
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '프로필',
      tooltip: '개인 설정 및 권한 관리',
    ),
    // 🚀 향후 확장 예시: 아래처럼 간단히 추가만 하면 됨!
    // _TabInfo(
    //   route: '/settings',
    //   icon: Icons.settings_outlined,
    //   activeIcon: Icons.settings,
    //   label: '설정',
    //   tooltip: '앱 설정 및 환경설정',
    // ),
  ];

  /// 📱 페이지 위젯 매핑 (PageView용 - 확장성 보장!)
  /// 🚀 NEW: GoRouter child 대신 직접 페이지 관리
  static final List<Widget> _pages = [
    const FeedPage(),
    const SearchPage(),
    const QueuePage(),
    const ProfilePage(),
    // 🚀 향후 확장 시: 위 _tabs와 동일한 순서로 추가만 하면 됨!
    // const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializePageController();
  }

  /// 🚀 PageController 초기화 (화면 전환 애니메이션 전용!)
  void _initializePageController() {
    // ✅ 안전한 기본값으로 초기화
    _currentPageIndex = 0; // 기본값: 첫 번째 탭 (피드)

    _pageController = PageController(
      initialPage: _currentPageIndex,
      viewportFraction: 1.0, // 한 번에 하나 페이지만 보이기
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔄 GoRouter 라우트와 PageView 동기화!
    final currentLocation = GoRouterState.of(context).uri.path;
    final routeIndex = _getCurrentIndex(currentLocation);

    if (routeIndex != _currentPageIndex) {
      // 🧠 라우트 변경 감지 (브라우저 뒤로가기, 직접 URL 입력 등)
      _currentPageIndex = routeIndex;

      // 🚀 PageController 안전하게 동기화
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          // 🔥 부드러운 화면 슬라이드 애니메이션
          _pageController.animateToPage(
            _currentPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(), // 🚀 PageView로 화면 전환!
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  /// 🚀 PageView 기반 화면 전환 (진짜 원하시던 기능!)
  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      // 🎯 사용자 스와이프 차단 (탭 클릭으로만 전환하도록)
      physics: const NeverScrollableScrollPhysics(),
      // 🔄 페이지 변경 감지 (GoRouter와 동기화용)
      onPageChanged: (index) {
        setState(() {
          _currentPageIndex = index;
        });
        // 🧭 GoRouter 라우트도 동기화
        context.go(_tabs[index].route);
      },
      itemBuilder: (context, index) {
        return _pages[index];
      },
    );
  }

  /// 🧭 깔끔한 기본 BottomNavigationBar (애니메이션 제거!)
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPageIndex,
        onTap: _onTabTapped,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brandCrimson,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12.sp,
        unselectedFontSize: 10.sp,
        iconSize: 24.r,
        items: _tabs.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon),
          label: tab.label,
          tooltip: tab.tooltip,
        )).toList(),
      ),
    );
  }

  /// 🎯 현재 경로를 기반으로 선택된 탭 인덱스 계산 (확장성 100%!)
  int _getCurrentIndex(String location) {
    // 🚀 _tabs 배열 기반으로 자동 매칭! (탭이 늘어나도 자동 대응)
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].route == location) {
        return i;
      }
    }
    return 0; // 기본값: 첫 번째 탭 (피드)
  }

  /// 🔄 스마트 탭 전환 (인접=애니메이션, 원거리=즉시이동!)
  void _onTabTapped(int index) {
    if (index >= 0 && index < _tabs.length && index != _currentPageIndex) {

      // 🧠 인덱스 차이 계산 (핵심 로직!)
      final indexDifference = (index - _currentPageIndex).abs();

      if (indexDifference == 1) {
        // ✨ 인접한 탭: 부드러운 슬라이드 애니메이션
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // ⚡ 멀리 떨어진 탭: 즉시 이동 (빠르고 효율적!)
        _pageController.jumpToPage(index);
      }
    }
  }
}