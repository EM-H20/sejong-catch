import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 온보딩 3단계: 역할 시스템 페이지
///
/// 게스트, 학생, 운영자, 관리자 역할을 설명하고
/// 각 역할별 권한과 특징을 소개합니다.
class OnboardingRolesPage extends StatefulWidget {
  const OnboardingRolesPage({super.key});

  @override
  State<OnboardingRolesPage> createState() => _OnboardingRolesPageState();
}

class _OnboardingRolesPageState extends State<OnboardingRolesPage>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<RoleInfo> _roles = [
    RoleInfo(
      icon: Icons.visibility,
      title: '게스트',
      subtitle: '둘러보기',
      description: '일부 정보를 볼 수 있어요\n회원가입 없이 이용 가능',
      color: Colors.grey,
      features: ['공개 정보 열람', '검색 기능', '기본 필터링'],
    ),
    RoleInfo(
      icon: Icons.school,
      title: '학생',
      subtitle: '세종대학교 학생',
      description: '맞춤 추천과 대기열을\n이용할 수 있어요',
      color: AppColors.brandCrimson,
      features: ['개인화 추천', '북마크 저장', '대기열 참여', '알림 설정'],
    ),
    RoleInfo(
      icon: Icons.admin_panel_settings,
      title: '운영자',
      subtitle: '정보 관리',
      description: '수집 규칙을 관리하고\n정보 품질을 관리해요',
      color: Colors.blue,
      features: ['수집 규칙 관리', '키워드 제외', '중복 처리', '품질 관리'],
    ),
    RoleInfo(
      icon: Icons.supervisor_account,
      title: '관리자',
      subtitle: '시스템 관리',
      description: '모든 시스템을 관리하고\n통계를 확인할 수 있어요',
      color: Colors.purple,
      features: ['사용자 관리', '통계 대시보드', '시스템 설정', '로그 분석'],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // 각 카드별 애니메이션 생성
    _cardAnimations = List.generate(_roles.length, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _cardController,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(_roles.length, (index) {
      return Tween<Offset>(
        begin: const Offset(0.5, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _cardController,
          curve: Interval(
            index * 0.2,
            (index * 0.2) + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 18.h),

            // 타이틀 섹션
            _buildTitleSection(),

            // 역할 카드들
            _buildRoleCards(),

            // 하단 설명
            _buildBottomInfo(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  /// 타이틀 섹션
  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          '다양한 역할 시스템',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '역할에 따라 다른 기능을 이용할 수 있어요',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 역할 카드들
  Widget _buildRoleCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 0.75,
      children: List.generate(_roles.length, (index) {
        return FadeTransition(
          opacity: _cardAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: _buildRoleCard(_roles[index]),
          ),
        );
      }),
    );
  }

  /// 개별 역할 카드
  Widget _buildRoleCard(RoleInfo role) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: role.color.withValues(alpha: 0.3),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: role.color.withValues(alpha: 0.1),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 아이콘
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: role.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(role.icon, size: 28.w, color: role.color),
          ),

          SizedBox(height: 5.h),

          // 타이틀
          Text(
            role.title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          // 서브타이틀
          Text(
            role.subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: role.color,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 8.h),

          // 설명
          Text(
            role.description,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // 주요 기능
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: role.color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${role.features.length}개 기능',
              style: TextStyle(
                fontSize: 10.sp,
                color: role.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 하단 정보
  Widget _buildBottomInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 24.w, color: AppColors.brandCrimson),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '학생 인증하기',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandCrimson,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '세종대학교 포털 계정으로 인증하면\n더 많은 기능을 이용할 수 있어요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 역할 정보 데이터 클래스
class RoleInfo {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final List<String> features;

  const RoleInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.features,
  });
}
