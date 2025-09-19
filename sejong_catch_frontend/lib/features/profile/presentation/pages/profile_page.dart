import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/config/app_mode.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../onboarding/data/services/onboarding_service.dart';

/// 👤 프로필 페이지 (Student 이상 권한 필요)
///
/// CLAUDE.md 원칙:
/// ✅ 권한 관리, 개인화 설정
/// ✅ 사용자 권한별 기능 차별화
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context, ref));
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 👤 사용자 프로필 카드
          _buildUserProfileCard(context),

          SizedBox(height: 24.h),

          // 📊 활동 통계
          _buildActivityStats(),

          SizedBox(height: 24.h),

          // ⚙️ 설정 메뉴
          _buildSettingsMenu(context),

          SizedBox(height: 24.h),

          // 🔐 권한 및 계정
          _buildAccountSection(context),

          // 🛠️ 개발자 옵션 (개발 모드에서만 표시)
          if (AppModeManager.showDeveloperTools) ...[
            SizedBox(height: 24.h),
            _buildDeveloperSection(context, ref),
          ],
        ],
      ),
    );
  }

  /// 👤 사용자 프로필 카드
  Widget _buildUserProfileCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // 프로필 이미지
            CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.brandCrimsonLight,
              child: Icon(
                Icons.person,
                size: 40.r,
                color: AppColors.brandCrimson,
              ),
            ),

            SizedBox(height: 16.h),

            // 사용자 이름
            Text(
              '홍길동',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4.h),

            // 학과/전공
            Text(
              '컴퓨터공학과 • 3학년',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 8.h),

            // 권한 배지
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.brandCrimson,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Student',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 프로필 편집 버튼
            AppButton.outline(
              text: '프로필 편집',
              isExpanded: true,
              onPressed: () {
                _showProfileEditDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 활동 통계 카드
  Widget _buildActivityStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 나의 활동',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                _buildStatItem('북마크', '12', Icons.bookmark),
                SizedBox(width: 24.w),
                _buildStatItem('지원완료', '8', Icons.check_circle),
                SizedBox(width: 24.w),
                _buildStatItem('대기중', '3', Icons.access_time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 통계 아이템
  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24.r, color: AppColors.brandCrimson),
        SizedBox(height: 8.h),
        Text(
          count,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.brandCrimson,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// ⚙️ 설정 메뉴
  Widget _buildSettingsMenu(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            onTap: () {
              // TODO: 알림 설정 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.filter_list,
            title: '관심 분야 설정',
            onTap: () {
              // TODO: 관심 분야 설정 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.download,
            title: '오프라인 저장',
            onTap: () {
              // TODO: 오프라인 저장 설정
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  /// 🔐 권한 및 계정 섹션
  Widget _buildAccountSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.school_outlined,
            title: '학생 인증 관리',
            onTap: () {
              // TODO: 학생 인증 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            onTap: () {
              // TODO: 개인정보 처리방침 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.help_outline,
            title: '도움말 및 지원',
            onTap: () {
              // TODO: 도움말 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: '앱 정보',
            onTap: () {
              // TODO: 앱 정보 페이지
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.logout,
            title: '로그아웃',
            titleColor: Colors.red[600],
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  /// 📋 메뉴 타일
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24.r, color: titleColor ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: titleColor ?? Colors.grey[900],
        ),
      ),
      trailing:
          trailing ??
          Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  /// 구분선
  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: Colors.grey[200],
      indent: 56.w,
    );
  }

  /// 🚪 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?'),
          actions: [
            AppButton.text(text: '취소', onPressed: () => Navigator.pop(context)),
            AppButton.primary(
              text: '로그아웃',
              backgroundColor: AppColors.error,
              onPressed: () {
                Navigator.pop(context);
                context.go(AppRoutes.auth);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('로그아웃되었습니다. 안전한 하루 되세요! 👋'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// ✏️ 프로필 편집 다이얼로그
  void _showProfileEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '프로필 편집',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재는 베타 버전이라 편집 기능이 제한되어 있어요.',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              '• 프로필 사진 변경\n• 관심 분야 수정\n• 알림 설정 변경',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          AppButton.primary(
            text: '확인',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('곧 더 많은 편집 기능이 추가될 예정이에요! 🚀'),
                  backgroundColor: AppColors.brandCrimson,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 👤 AppBar 윈짓
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '프로필',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.brandCrimson,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _showSettings(context),
        ),
      ],
    );
  }

  /// ⚙️ 설정 메뉴 보기
  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('설정 메뉴가 곧 추가될 예정이에요! ⚙️'),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// 🛠️ 개발자 옵션 섹션 (개발 모드에서만 표시)
  Widget _buildDeveloperSection(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      color: Colors.orange[50], // 개발자 섹션임을 강조
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.developer_mode,
                  color: Colors.orange[700],
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  '🛠️ 개발자 옵션 (${AppModeManager.modeString})',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          _buildMenuTile(
            icon: Icons.refresh,
            title: '온보딩 화면 다시 보기',
            titleColor: Colors.orange[700],
            onTap: () => _resetOnboarding(context, ref),
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: '앱 모드 정보',
            titleColor: Colors.orange[700],
            onTap: () => _showAppModeInfo(context),
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.bug_report_outlined,
            title: '디버그 정보',
            titleColor: Colors.orange[700],
            onTap: () => _showDebugInfo(context),
          ),
          _buildDivider(),
          _buildMenuTile(
            icon: Icons.tune,
            title: '환경 변수 사용법',
            titleColor: Colors.orange[700],
            onTap: () => _showEnvironmentVariableInfo(context),
          ),
        ],
      ),
    );
  }

  /// 🔄 온보딩 리셋
  void _resetOnboarding(BuildContext context, WidgetRef ref) async {
    try {
      final onboardingService = ref.read(onboardingServiceProvider);
      await onboardingService.resetOnboarding();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8.w),
                Text('온보딩이 리셋되었습니다! 앱을 재시작하면 온보딩을 다시 볼 수 있어요.'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('온보딩 리셋 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 📱 앱 모드 정보 표시
  void _showAppModeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange[700]),
            SizedBox(width: 8.w),
            Text('앱 모드 정보'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('현재 모드', AppModeManager.modeString),
            _buildInfoRow('개발 도구', AppModeManager.showDeveloperTools ? 'ON' : 'OFF'),
            _buildInfoRow('온보딩 항상 표시', AppModeManager.shouldShowOnboardingAlways ? 'ON' : 'OFF'),
            _buildInfoRow('디버그 로깅', AppModeManager.isDebugEnabled ? 'ON' : 'OFF'),
            _buildInfoRow('API 엔드포인트', AppModeManager.apiBaseUrl),
            _buildInfoRow('로그 레벨', AppModeManager.logLevel),
          ],
        ),
        actions: [
          AppButton.primary(
            text: '확인',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 🐛 디버그 정보 표시
  void _showDebugInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.bug_report_outlined, color: Colors.orange[700]),
            SizedBox(width: 8.w),
            Text('디버그 정보'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 개발모드 온보딩 활성화됨',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• 개발 모드에서는 온보딩이 항상 표시됩니다\n'
              '• 앱을 재시작할 때마다 온보딩을 볼 수 있습니다\n'
              '• 프로덕션 빌드에서는 일반적으로 작동합니다',
              style: TextStyle(fontSize: 12.sp, height: 1.4),
            ),
          ],
        ),
        actions: [
          AppButton.primary(
            text: '확인',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 🌍 환경 변수 사용법 표시
  void _showEnvironmentVariableInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.tune, color: Colors.orange[700]),
            SizedBox(width: 8.w),
            Text('환경 변수로 모드 변경'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🚀 터미널에서 앱 모드를 강제로 설정할 수 있어요!',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 16.h),
              _buildCommandExample('개발 모드', 'flutter run --dart-define=APP_MODE=dev'),
              _buildCommandExample('스테이징 모드', 'flutter run --dart-define=APP_MODE=staging'),
              _buildCommandExample('프로덕션 모드', 'flutter run --dart-define=APP_MODE=prod'),
              SizedBox(height: 16.h),
              Text(
                '💡 팁:',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              Text(
                '• 환경 변수가 설정되지 않으면 빌드 타입에 따라 자동 결정됩니다\n'
                '• flutter run --debug → 개발 모드\n'
                '• flutter run --profile → 스테이징 모드\n'
                '• flutter run --release → 프로덕션 모드',
                style: TextStyle(fontSize: 11.sp, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          AppButton.primary(
            text: '확인',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// 명령어 예시 위젯
  Widget _buildCommandExample(String label, String command) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              command,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'monospace',
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 정보 행 위젯
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
