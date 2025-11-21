import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';
import 'package:sejong_catch_frontend/features/auth/presentation/controllers/login_controller.dart';
import 'package:sejong_catch_frontend/features/auth/presentation/controllers/auth_state_controller.dart';
import 'package:sejong_catch_frontend/features/auth/data/models/response/login_response.dart';

/// 👤 프로필 페이지 - 사용자 정보 및 설정
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지
/// ✅ AuthStateController에서 실제 사용자 정보 가져오기
/// ✅ Mock/Real 모드 모두 지원
/// ✅ 디자인 토큰 사용 (AppColors, AppSpacing, AppDivider)
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // 🔥 AuthState에서 사용자 정보 가져오기
    final authState = ref.watch(authStateControllerProvider);

    // 로딩 중
    if (authState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.brandCrimson),
        ),
      );
    }

    // 로그인 안 됨 (방어 코드 - 라우팅 가드가 있지만 안전장치)
    if (!authState.isAuthenticated || authState.currentUser == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_off_outlined,
                size: 64.sp,
                color: AppColors.textTertiary,
              ),
              AppSpacing.verticalSpaceLG,
              Text(
                '로그인이 필요합니다',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 🎉 실제 사용자 정보 사용!
    final user = authState.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            _buildProfileHeader(user),

            AppSpacing.verticalSpaceLG,

            // 내 정보
            _buildMyInfoSection(user),

            AppSpacing.verticalSpaceLG,

            // 설정 메뉴
            _buildSettingsSection(),

            AppSpacing.verticalSpaceLG,

            // 로그아웃 버튼
            _buildLogoutButton(),

            AppSpacing.verticalSpaceHuge,
          ],
        ),
      ),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text(
            '세종 캐치',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.brandCrimson,
            ),
          ),
          AppSpacing.horizontalSpaceXS,
          Text(
            '프로필',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, size: 24.sp),
          color: AppColors.textSecondary,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('설정 페이지 준비 중! ⚙️')));
          },
        ),
      ],
    );
  }

  /// 👤 프로필 헤더
  Widget _buildProfileHeader(UserDto user) {
    final isOperator = user.role == 'operator';

    return Container(
      width: double.infinity,
      padding: AppSpacing.screenPaddingLarge,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.brandCrimson, AppColors.brandCrimsonDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // 프로필 이미지
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 50.sp,
              color: AppColors.brandCrimson,
            ),
          ),

          AppSpacing.verticalSpaceLG,

          // 이름
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),

          AppSpacing.verticalSpaceXS,

          // 학과
          Text(
            user.major,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),

          AppSpacing.verticalSpaceMD,

          // 역할 배지
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOperator ? Icons.admin_panel_settings : Icons.school,
                  size: 16.sp,
                  color: AppColors.white,
                ),
                AppSpacing.horizontalSpaceXS,
                Text(
                  user.role,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 내 정보 섹션
  Widget _buildMyInfoSection(UserDto user) {
    return Container(
      margin: AppSpacing.screenHorizontal,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.basic,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Padding(
            padding: AppSpacing.cardPadding,
            child: Text(
              '내 정보',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          AppDivider.thin(),

          // 이메일
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: '이메일',
            value: user.email,
          ),

          AppDivider.thin(),

          // 이름
          _buildInfoTile(
            icon: Icons.person_outline,
            label: '이름',
            value: user.name,
          ),

          AppDivider.thin(),

          // 학과
          _buildInfoTile(
            icon: Icons.school_outlined,
            label: '학과',
            value: user.major,
          ),

          AppDivider.thin(),

          // 역할
          _buildInfoTile(
            icon: Icons.verified_user_outlined,
            label: '역할',
            value: user.role,
          ),

          // 학년 (nullable이므로 조건부 렌더링)
          if (user.year != null) ...[
            AppDivider.thin(),
            _buildInfoTile(
              icon: Icons.grade_outlined,
              label: '학년',
              value: '${user.year}학년',
            ),
          ],
        ],
      ),
    );
  }

  /// ℹ️ 정보 타일
  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.brandCrimson.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.brandCrimson),
          ),
          AppSpacing.horizontalSpaceLG,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.verticalSpaceXS,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ⚙️ 설정 섹션
  Widget _buildSettingsSection() {
    return Container(
      margin: AppSpacing.screenHorizontal,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.basic,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Padding(
            padding: AppSpacing.cardPadding,
            child: Text(
              '설정',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          AppDivider.thin(),

          // 알림 설정
          _buildSettingTile(
            icon: Icons.notifications_outlined,
            label: '알림 설정',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('알림 설정 페이지 준비 중!')));
            },
          ),

          AppDivider.thin(),

          // 북마크 관리
          _buildSettingTile(
            icon: Icons.bookmark_outline,
            label: '북마크 관리',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('북마크 페이지 준비 중!')));
            },
          ),

          AppDivider.thin(),

          // 앱 정보
          _buildSettingTile(
            icon: Icons.info_outline,
            label: '앱 정보',
            onTap: () {
              _showAppInfoDialog();
            },
          ),

          AppDivider.thin(),

          // 문의하기
          _buildSettingTile(
            icon: Icons.help_outline,
            label: '문의하기',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('문의 페이지 준비 중!')));
            },
          ),
        ],
      ),
    );
  }

  /// ⚙️ 설정 타일
  Widget _buildSettingTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 20.sp, color: AppColors.textSecondary),
            ),
            AppSpacing.horizontalSpaceLG,
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  /// 🚪 로그아웃 버튼
  Widget _buildLogoutButton() {
    return Container(
      margin: AppSpacing.screenHorizontal,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showLogoutDialog();
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          side: BorderSide(color: AppColors.error, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20.sp, color: AppColors.error),
            AppSpacing.horizontalSpaceSM,
            Text(
              '로그아웃',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 💬 앱 정보 다이얼로그
  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 24.sp,
              color: AppColors.brandCrimson,
            ),
            AppSpacing.horizontalSpaceSM,
            Text(
              '앱 정보',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('앱 이름', '세종 캐치'),
            AppSpacing.verticalSpaceSM,
            AppDivider.thin(),
            AppSpacing.verticalSpaceSM,
            _buildInfoRow('버전', '1.0.0'),
            AppSpacing.verticalSpaceSM,
            AppDivider.thin(),
            AppSpacing.verticalSpaceSM,
            _buildInfoRow('개발자', '세종대학교 팀'),
            AppSpacing.verticalSpaceSM,
            AppDivider.thin(),
            AppSpacing.verticalSpaceSM,
            Text(
              '세종대학교 학생들을 위한\n올인원 정보 허브',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '확인',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ℹ️ 정보 행
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// 🚪 로그아웃 다이얼로그
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '로그아웃',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '정말 로그아웃 하시겠어요?\n다시 로그인하려면 세종 포털 계정이 필요해요.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // 다이얼로그 닫기
              Navigator.pop(context);

              // 로그아웃 처리
              final loginController = ref.read(
                loginControllerProvider.notifier,
              );
              final success = await loginController.logout();

              if (mounted) {
                if (success) {
                  // 로그아웃 성공 → 로그인 페이지로 이동
                  context.go('/auth');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그아웃되었습니다. 다시 만나요! 👋'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else {
                  // 로그아웃 실패 (드물지만 방어 코드)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('로그아웃 중 문제가 발생했어요'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(
              '로그아웃',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
