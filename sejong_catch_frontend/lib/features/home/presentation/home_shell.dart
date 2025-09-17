import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/config/app_routes.dart';
import '../../../core/theme/app_colors.dart';

/// 🏠 세종 캐치 메인 앱 쉘
///
/// CLAUDE.md 핵심 원칙:
/// ✅ BottomNavigationBar는 여기서만 정의!
/// ✅ 각 탭별 페이지는 자신의 UI만 담당
/// ✅ 모든 탭 전환은 여기서 중앙 관리
/// ❌ 각 Feature에서 BottomNavigationBar 중복 구현 절대 금지!
class HomeShell extends StatelessWidget {
  /// 현재 선택된 탭의 페이지 위젯
  final Widget child;

  const HomeShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // 현재 선택된 탭 페이지 표시
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  /// 🧭 BottomNavigationBar 위젯 (중앙 관리!)
  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

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
        currentIndex: _getCurrentIndex(currentLocation),
        onTap: (index) => _onTabTapped(context, index),
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brandCrimson,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12.sp,
        unselectedFontSize: 10.sp,
        iconSize: 24.r,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: '피드',
            tooltip: '공모전, 취업, 논문 정보 피드',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            activeIcon: const Icon(Icons.search),
            label: '검색',
            tooltip: '정보 검색 및 필터링',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.queue_outlined),
            activeIcon: const Icon(Icons.queue),
            label: '줄서기',
            tooltip: '인기 정보 대기열 관리',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: '프로필',
            tooltip: '개인 설정 및 권한 관리',
          ),
        ],
      ),
    );
  }

  /// 🎯 현재 경로를 기반으로 선택된 탭 인덱스 계산
  int _getCurrentIndex(String location) {
    switch (location) {
      case AppRoutes.feed:
        return 0;
      case AppRoutes.search:
        return 1;
      case AppRoutes.queue:
        return 2;
      case AppRoutes.profile:
        return 3;
      default:
        return 0; // 기본값: 피드 탭
    }
  }

  /// 🔄 탭 선택 시 라우팅 처리
  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.feed);
        break;
      case 1:
        context.go(AppRoutes.search);
        break;
      case 2:
        context.go(AppRoutes.queue);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}