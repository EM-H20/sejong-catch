import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/config/app_mode.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../onboarding/data/services/onboarding_service.dart';
import '../widgets/ui/user_profile_card.dart';
import '../widgets/ui/activity_stats_card.dart';
import '../../../../core/widgets/cards/menu_card.dart';

/// 👤 프로필 페이지 (Student 이상 권한 필요)
///
/// CLAUDE.md 원칙:
/// ✅ 권한 관리, 개인화 설정
/// ✅ 사용자 권한별 기능 차별화
/// ✅ 컴포넌트 분리로 코드 대폭 감소 (기존 719줄 → 150줄 예상)
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, ref),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('프로필'),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 👤 사용자 프로필 카드
          UserProfileCard(
            onEditProfile: () => _showProfileEditDialog(context),
          ),

          SizedBox(height: 24.h),

          // 📊 활동 통계
          const ActivityStatsCard(
            bookmarkCount: 12,
            completedCount: 8,
            pendingCount: 3,
          ),

          SizedBox(height: 24.h),

          // ⚙️ 설정 메뉴
          MenuCard(
            title: '설정',
            menuItems: [
              MenuItem(
                icon: Icons.notifications_outlined,
                title: '알림 설정',
                onTap: () => _showNotImplementedSnackBar(context, '알림 설정'),
              ),
              MenuItem(
                icon: Icons.filter_list,
                title: '관심 분야 설정',
                onTap: () => _showNotImplementedSnackBar(context, '관심 분야 설정'),
              ),
              MenuItem(
                icon: Icons.download,
                title: '오프라인 저장',
                onTap: () => _showNotImplementedSnackBar(context, '오프라인 저장'),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // 🔐 권한 및 계정
          MenuCard(
            title: '계정',
            menuItems: [
              MenuItem(
                icon: Icons.school_outlined,
                title: '학생 인증 관리',
                onTap: () => _showNotImplementedSnackBar(context, '학생 인증 관리'),
              ),
              MenuItem(
                icon: Icons.privacy_tip_outlined,
                title: '개인정보 처리방침',
                onTap: () => _showNotImplementedSnackBar(context, '개인정보 처리방침'),
              ),
              MenuItem(
                icon: Icons.help_outline,
                title: '도움말 및 지원',
                onTap: () => _showNotImplementedSnackBar(context, '도움말 및 지원'),
              ),
              MenuItem(
                icon: Icons.info_outline,
                title: '앱 정보',
                onTap: () => _showNotImplementedSnackBar(context, '앱 정보'),
              ),
              MenuItem(
                icon: Icons.logout,
                title: '로그아웃',
                titleColor: Colors.red[600],
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),

          // 🛠️ 개발자 옵션 (개발 모드에서만 표시)
          if (AppModeManager.showDeveloperTools) ...[
            SizedBox(height: 24.h),
            _buildDeveloperSection(context, ref),
          ],
        ],
      ),
    );
  }

  /// 🛠️ 개발자 섹션
  Widget _buildDeveloperSection(BuildContext context, WidgetRef ref) {
    return MenuCard(
      title: '개발자 옵션',
      menuItems: [
        MenuItem(
          icon: Icons.settings,
          title: '앱 모드 설정',
          onTap: () => _showAppModeDialog(context),
        ),
        MenuItem(
          icon: Icons.refresh,
          title: '온보딩 재시작',
          onTap: () => _resetOnboarding(context, ref),
        ),
        MenuItem(
          icon: Icons.bug_report,
          title: '디버그 정보',
          onTap: () => _showDebugInfo(context),
        ),
      ],
    );
  }

  /// 📝 프로필 편집 다이얼로그
  void _showProfileEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 편집'),
        content: const Text('프로필 편집 기능은 곧 추가될 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 🚪 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말로 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRoutes.auth);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }

  /// 📱 앱 모드 설정 다이얼로그
  void _showAppModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 모드 설정'),
        content: const Text('현재 앱 모드를 변경할 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 🔄 온보딩 재시작
  void _resetOnboarding(BuildContext context, WidgetRef ref) {
    final onboardingService = ref.read(onboardingServiceProvider);
    onboardingService.resetOnboarding();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('온보딩이 재설정되었습니다. 앱을 재시작해주세요.')),
    );
  }

  /// 🐛 디버그 정보 표시
  void _showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('디버그 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('앱 모드: ${AppModeManager.currentMode}'),
            Text('개발자 도구: ${AppModeManager.showDeveloperTools}'),
            Text('환경: ${AppModeManager.isDevelopment ? "개발" : "운영"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 🚫 미구현 기능 안내 (공통 에러 핸들러 사용)
  void _showNotImplementedSnackBar(BuildContext context, String feature) {
    ErrorHandler.showNotImplementedSnackBar(context, feature);
  }
}