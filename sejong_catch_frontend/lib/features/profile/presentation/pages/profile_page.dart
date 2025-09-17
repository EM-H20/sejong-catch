import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/app_button.dart';

/// 👤 프로필 페이지 (Student 이상 권한 필요)
///
/// CLAUDE.md 원칙:
/// ✅ 권한 관리, 개인화 설정
/// ✅ 사용자 권한별 기능 차별화
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context) {
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
            AppButton.text(
              text: '취소',
              onPressed: () => Navigator.pop(context),
            ),
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
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
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
}
