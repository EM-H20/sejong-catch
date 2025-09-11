import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../routing/routes.dart';
import '../../routing/route_guards.dart';

/// 세종 캐치 앱의 바텀 네비게이션 바
/// 
/// 역할 기반 접근 제어를 지원하며,
/// 사용자의 권한에 따라 탭을 동적으로 표시합니다.
class AppBottomNav extends StatelessWidget {
  /// 현재 선택된 탭 인덱스
  final int currentIndex;
  
  /// 탭 선택 콜백
  final ValueChanged<int> onTap;
  
  /// 배지 정보 (탭별 알림 개수)
  final Map<int, int>? badges;
  
  /// 커스텀 배경색
  final Color? backgroundColor;
  
  /// 커스텀 선택된 아이템 색상
  final Color? selectedItemColor;
  
  /// 커스텀 선택되지 않은 아이템 색상
  final Color? unselectedItemColor;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badges,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    // 사용자가 접근 가능한 탭들만 필터링
    final availableTabs = _getAvailableTabs();
    
    // 접근 가능한 탭이 2개 미만이면 바텀 네비게이션 숨기기
    if (availableTabs.length < 2) {
      return const SizedBox.shrink();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: availableTabs.map((tabInfo) {
              final isSelected = currentIndex == tabInfo.originalIndex;
              return _buildNavItem(
                context,
                tabInfo,
                isSelected,
                availableTabs.length,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  
  /// 사용자가 접근 가능한 탭 정보 조회
  List<_TabInfo> _getAvailableTabs() {
    final allTabs = _getAllTabs();
    final availableTabs = <_TabInfo>[];
    
    for (int i = 0; i < allTabs.length; i++) {
      final tab = allTabs[i];
      if (RouteGuards.canAccessRoute(tab.route)) {
        availableTabs.add(_TabInfo(
          originalIndex: i,
          route: tab.route,
          icon: tab.icon,
          activeIcon: tab.activeIcon,
          label: tab.label,
        ));
      }
    }
    
    return availableTabs;
  }
  
  /// 모든 탭 정보 정의
  List<_TabInfo> _getAllTabs() {
    return [
      _TabInfo(
        originalIndex: 0,
        route: AppRoutes.feed,
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: '피드',
      ),
      _TabInfo(
        originalIndex: 1,
        route: AppRoutes.search,
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: '검색',
      ),
      _TabInfo(
        originalIndex: 2,
        route: AppRoutes.queue,
        icon: Icons.queue_outlined,
        activeIcon: Icons.queue,
        label: '대기열',
      ),
      _TabInfo(
        originalIndex: 3,
        route: AppRoutes.profile,
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: '프로필',
      ),
    ];
  }
  
  /// 개별 네비게이션 아이템 구성
  Widget _buildNavItem(
    BuildContext context,
    _TabInfo tabInfo,
    bool isSelected,
    int totalTabs,
  ) {
    final effectiveSelectedColor = selectedItemColor ?? AppColors.brandCrimson;
    final effectiveUnselectedColor = unselectedItemColor ?? AppColors.textSecondary;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(tabInfo.originalIndex),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 아이콘 + 배지
                _buildIconWithBadge(
                  tabInfo,
                  isSelected,
                  effectiveSelectedColor,
                  effectiveUnselectedColor,
                ),
                
                SizedBox(height: 4.h),
                
                // 라벨
                _buildLabel(
                  tabInfo.label,
                  isSelected,
                  effectiveSelectedColor,
                  effectiveUnselectedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 아이콘과 배지 구성
  Widget _buildIconWithBadge(
    _TabInfo tabInfo,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    final iconWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        isSelected ? tabInfo.activeIcon : tabInfo.icon,
        key: ValueKey(isSelected),
        size: 24.w,
        color: isSelected ? selectedColor : unselectedColor,
      ),
    );
    
    // 배지가 있는 경우
    final badgeCount = badges?[tabInfo.originalIndex];
    if (badgeCount != null && badgeCount > 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6.w,
            top: -6.h,
            child: _buildBadge(badgeCount),
          ),
        ],
      );
    }
    
    return iconWidget;
  }
  
  /// 배지 위젯 구성
  Widget _buildBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: count > 9 ? 6.w : 5.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white,
          width: 1.w,
        ),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      ),
    );
  }
  
  /// 라벨 텍스트 구성
  Widget _buildLabel(
    String label,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected ? selectedColor : unselectedColor,
        height: 1.0,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ============================================================================
// 탭 정보 데이터 클래스
// ============================================================================

/// 바텀 네비게이션 탭 정보
class _TabInfo {
  /// 원본 인덱스 (전체 탭 목록에서의 위치)
  final int originalIndex;
  
  /// 라우트 경로
  final String route;
  
  /// 기본 아이콘
  final IconData icon;
  
  /// 활성화된 아이콘
  final IconData activeIcon;
  
  /// 라벨 텍스트
  final String label;

  const _TabInfo({
    required this.originalIndex,
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ============================================================================
// 바텀 네비게이션 도우미 위젯들
// ============================================================================

/// 바텀 네비게이션과 함께 사용하는 스캐폴드 래퍼
class AppScaffoldWithBottomNav extends StatelessWidget {
  /// 현재 페이지 위젯
  final Widget child;
  
  /// 현재 라우트 경로
  final String currentRoute;
  
  /// 배지 정보
  final Map<int, int>? badges;
  
  /// 라우트 변경 콜백
  final ValueChanged<String>? onRouteChanged;

  const AppScaffoldWithBottomNav({
    super.key,
    required this.child,
    required this.currentRoute,
    this.badges,
    this.onRouteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: AppRoutes.getTabIndex(currentRoute),
        onTap: (index) {
          final route = AppRoutes.getRouteFromIndex(index);
          onRouteChanged?.call(route);
        },
        badges: badges,
      ),
    );
  }
}

/// 플로팅 액션 버튼과 함께 사용하는 바텀 네비게이션
class AppBottomNavWithFAB extends StatelessWidget {
  /// 현재 선택된 탭 인덱스
  final int currentIndex;
  
  /// 탭 선택 콜백
  final ValueChanged<int> onTap;
  
  /// 플로팅 액션 버튼
  final Widget floatingActionButton;
  
  /// FAB 위치
  final FloatingActionButtonLocation fabLocation;
  
  /// 배지 정보
  final Map<int, int>? badges;

  const AppBottomNavWithFAB({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.floatingActionButton,
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 바텀 네비게이션
        AppBottomNav(
          currentIndex: currentIndex,
          onTap: onTap,
          badges: badges,
        ),
        
        // 플로팅 액션 버튼
        Positioned(
          bottom: 20.h,
          left: 0,
          right: 0,
          child: Center(
            child: floatingActionButton,
          ),
        ),
      ],
    );
  }
}

/// 배지 업데이트를 위한 헬퍼 클래스
class BottomNavBadgeManager {
  static final Map<int, int> _badges = {};
  
  /// 배지 설정
  static void setBadge(int tabIndex, int count) {
    if (count > 0) {
      _badges[tabIndex] = count;
    } else {
      _badges.remove(tabIndex);
    }
  }
  
  /// 배지 증가
  static void incrementBadge(int tabIndex) {
    _badges[tabIndex] = (_badges[tabIndex] ?? 0) + 1;
  }
  
  /// 배지 감소
  static void decrementBadge(int tabIndex) {
    final current = _badges[tabIndex] ?? 0;
    if (current > 1) {
      _badges[tabIndex] = current - 1;
    } else {
      _badges.remove(tabIndex);
    }
  }
  
  /// 배지 클리어
  static void clearBadge(int tabIndex) {
    _badges.remove(tabIndex);
  }
  
  /// 모든 배지 클리어
  static void clearAllBadges() {
    _badges.clear();
  }
  
  /// 현재 배지 상태 반환
  static Map<int, int> getBadges() {
    return Map.from(_badges);
  }
  
  /// 특정 탭의 배지 개수 반환
  static int getBadgeCount(int tabIndex) {
    return _badges[tabIndex] ?? 0;
  }
  
  /// 전체 배지 개수 반환
  static int getTotalBadgeCount() {
    return _badges.values.fold(0, (sum, count) => sum + count);
  }
}