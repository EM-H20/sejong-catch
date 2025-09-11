import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 프로필 페이지
/// 
/// 사용자 정보, 관심사 설정, 앱 설정 등을 관리합니다.
/// 역할별 접근 권한에 따라 다른 메뉴를 보여줄 예정이에요.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // 임시 사용자 정보
  bool _isLoggedIn = false;
  String _userName = '세종대학교 학생';
  String _userEmail = 'student@sejong.ac.kr';
  String _userRole = 'Student';
  String _department = '컴퓨터공학과';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettingsBottomSheet,
            icon: Icon(
              Icons.settings,
              size: 24.w,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // 사용자 정보 섹션
            _buildUserInfoSection(),
            SizedBox(height: 24.h),
            
            // 로그인/계정 관리 섹션
            _buildAccountSection(),
            SizedBox(height: 24.h),
            
            // 활동 통계 섹션
            if (_isLoggedIn) ...[
              _buildActivityStatsSection(),
              SizedBox(height: 24.h),
            ],
            
            // 관심사 설정 섹션
            if (_isLoggedIn) ...[
              _buildInterestsSection(),
              SizedBox(height: 24.h),
            ],
            
            // 앱 정보 섹션
            _buildAppInfoSection(),
          ],
        ),
      ),
    );
  }
  
  /// 사용자 정보 섹션
  Widget _buildUserInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: _isLoggedIn 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandCrimson,
                  AppColors.brandCrimsonDark,
                ],
              )
            : null,
        color: _isLoggedIn ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _isLoggedIn 
                ? AppColors.brandCrimson.withValues(alpha: 0.3)
                : AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 프로필 이미지
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isLoggedIn 
                  ? AppColors.white.withValues(alpha: 0.2)
                  : AppColors.brandCrimsonLight,
              border: Border.all(
                color: _isLoggedIn 
                    ? AppColors.white.withValues(alpha: 0.5)
                    : AppColors.brandCrimson.withValues(alpha: 0.3),
                width: 2.w,
              ),
            ),
            child: Icon(
              _isLoggedIn ? Icons.person : Icons.person_outline,
              size: 40.w,
              color: _isLoggedIn 
                  ? AppColors.white 
                  : AppColors.brandCrimson,
            ),
          ),
          SizedBox(height: 16.h),
          
          // 사용자 이름/상태
          Text(
            _isLoggedIn ? _userName : '로그인이 필요합니다',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: _isLoggedIn ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          
          // 이메일/안내문구
          Text(
            _isLoggedIn ? _userEmail : '학생 인증으로 더 많은 기능을 이용하세요',
            style: TextStyle(
              fontSize: 14.sp,
              color: _isLoggedIn 
                  ? AppColors.white.withValues(alpha: 0.9)
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (_isLoggedIn) ...[
            SizedBox(height: 8.h),
            // 역할 배지
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school,
                    size: 14.w,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$_userRole | $_department',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  /// 계정 관리 섹션
  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        children: [
          if (!_isLoggedIn) ...[
            _buildMenuItem(
              icon: Icons.login,
              title: '로그인 / 회원가입',
              subtitle: '학생 인증으로 개인화된 서비스를 이용하세요',
              onTap: _handleLogin,
              showArrow: true,
            ),
          ] else ...[
            _buildMenuItem(
              icon: Icons.edit,
              title: '프로필 수정',
              subtitle: '개인정보 및 관심사 수정',
              onTap: () => _showEditProfileDialog(),
              showArrow: true,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.security,
              title: '계정 설정',
              subtitle: '비밀번호 변경, 보안 설정',
              onTap: () => _showFeatureComingSoon('계정 설정'),
              showArrow: true,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.logout,
              title: '로그아웃',
              subtitle: '',
              onTap: _handleLogout,
              showArrow: false,
              iconColor: AppColors.error,
            ),
          ],
        ],
      ),
    );
  }
  
  /// 활동 통계 섹션
  Widget _buildActivityStatsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 20.w,
                  color: AppColors.brandCrimson,
                ),
                SizedBox(width: 8.w),
                Text(
                  '내 활동 통계',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // 통계 카드들
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: '북마크',
                    value: '24',
                    icon: Icons.bookmark,
                    color: AppColors.brandCrimson,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    title: '대기열',
                    value: '3',
                    icon: Icons.queue,
                    color: AppColors.warning,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    title: '완료',
                    value: '18',
                    icon: Icons.check_circle,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
  
  /// 통계 카드
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.w,
            color: color,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 관심사 설정 섹션
  Widget _buildInterestsSection() {
    final interests = ['공모전', '취업', '인턴십', '연구', '창업', '해외연수'];
    final selectedInterests = ['공모전', '취업', '인턴십'];
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 20.w,
                    color: AppColors.brandCrimson,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '관심 분야',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _showEditInterestsDialog(),
                child: Text(
                  '편집',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.brandCrimson,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: interests.map((interest) {
              final isSelected = selectedInterests.contains(interest);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.brandCrimsonLight 
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected 
                        ? AppColors.brandCrimson 
                        : AppColors.divider,
                    width: 1.w,
                  ),
                ),
                child: Text(
                  interest,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected 
                        ? AppColors.brandCrimson 
                        : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  /// 앱 정보 섹션
  Widget _buildAppInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.help_outline,
            title: '도움말',
            subtitle: '앱 사용법 및 FAQ',
            onTap: () => _showFeatureComingSoon('도움말'),
            showArrow: true,
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            subtitle: '',
            onTap: () => _showFeatureComingSoon('개인정보 처리방침'),
            showArrow: true,
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: '서비스 이용약관',
            subtitle: '',
            onTap: () => _showFeatureComingSoon('서비스 이용약관'),
            showArrow: true,
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: '앱 정보',
            subtitle: '버전 1.0.0',
            onTap: () => _showAppInfoDialog(),
            showArrow: true,
          ),
        ],
      ),
    );
  }
  
  /// 메뉴 아이템
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool showArrow,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: iconColor ?? AppColors.textSecondary,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  size: 20.w,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 메뉴 구분선
  Widget _buildMenuDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1.h,
        thickness: 1.w,
        color: AppColors.divider,
      ),
    );
  }
  
  /// 로그인 처리
  void _handleLogin() {
    // TODO: 실제 로그인 페이지로 이동
    setState(() {
      _isLoggedIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('로그인이 완료되었습니다! (개발 모드)'),
        backgroundColor: AppColors.success,
      ),
    );
  }
  
  /// 로그아웃 처리
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isLoggedIn = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('로그아웃되었습니다')),
              );
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }
  
  /// 개발 예정 기능 안내
  void _showFeatureComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능 개발 예정입니다!')),
    );
  }
  
  /// 프로필 수정 다이얼로그
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 수정'),
        content: const Text('프로필 수정 기능을 개발 중입니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  /// 관심사 편집 다이얼로그
  void _showEditInterestsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('관심 분야 설정'),
        content: const Text('관심 분야 설정 기능을 개발 중입니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  /// 앱 정보 다이얼로그
  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('세종 캐치'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '버전: 1.0.0\n'
              '개발: 세종 캐치 팀\n'
              '문의: support@sejongcatch.com\n\n'
              '세종인을 위한 정보 허브',
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  /// 설정 바텀시트
  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // 설정 메뉴들
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: '알림 설정',
              subtitle: '푸시 알림, 이메일 알림 설정',
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('알림 설정');
              },
              showArrow: true,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: '언어 설정',
              subtitle: '한국어',
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('언어 설정');
              },
              showArrow: true,
            ),
            _buildMenuDivider(),
            _buildMenuItem(
              icon: Icons.storage_outlined,
              title: '캐시 삭제',
              subtitle: '임시 파일 및 캐시 데이터 삭제',
              onTap: () {
                Navigator.pop(context);
                _showFeatureComingSoon('캐시 삭제');
              },
              showArrow: true,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}