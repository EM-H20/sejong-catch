import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/config/app_mode.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../onboarding/data/services/onboarding_service.dart';
import '../../../onboarding/data/models/interest.dart';
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
                onTap: () => _showInterestSettingsDialog(context),
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

  /// 🎯 관심사 설정 다이얼로그
  void _showInterestSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _InterestSettingsDialog(),
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

/// 🎯 관심사 설정 다이얼로그 위젯
class _InterestSettingsDialog extends StatefulWidget {
  @override
  State<_InterestSettingsDialog> createState() => _InterestSettingsDialogState();
}

class _InterestSettingsDialogState extends State<_InterestSettingsDialog> {
  final Set<Interest> _selectedInterests = {};

  // 🎯 추천 관심사 데이터 (InterestData에서 가져오기)
  final List<Interest> _allInterests = [
    // 진로/취업
    const Interest(
      id: 'job_fair',
      name: '취업박람회',
      emoji: '💼',
      category: InterestCategory.career,
      description: '기업 채용 설명회 및 면접 기회',
      relatedKeywords: ['채용', '면접', '구직'],
    ),
    const Interest(
      id: 'internship',
      name: '인턴십',
      emoji: '👔',
      category: InterestCategory.career,
      description: '실무 경험 및 취업 준비',
      relatedKeywords: ['인턴', '실습', '경험'],
    ),

    // 공모전/대회
    const Interest(
      id: 'programming_contest',
      name: '프로그래밍 대회',
      emoji: '💻',
      category: InterestCategory.contest,
      description: 'AI, 개발, 해커톤 등 프로그래밍 경진대회',
      relatedKeywords: ['프로그래밍', '코딩', '해커톤'],
    ),
    const Interest(
      id: 'design_contest',
      name: '디자인 공모전',
      emoji: '🎨',
      category: InterestCategory.contest,
      description: '시각, 제품, UX/UI 디자인 공모전',
      relatedKeywords: ['디자인', '시각', 'UI'],
    ),

    // 장학금/지원
    const Interest(
      id: 'scholarship',
      name: '성적우수 장학금',
      emoji: '🏆',
      category: InterestCategory.scholarship,
      description: '학업 성취도 기반 장학 혜택',
      relatedKeywords: ['장학금', '성적', '학업'],
    ),

    // 동아리/모임
    const Interest(
      id: 'tech_club',
      name: 'IT/개발 동아리',
      emoji: '⚡',
      category: InterestCategory.club,
      description: '프로그래밍 및 기술 관련 동아리',
      relatedKeywords: ['IT', '개발', '프로그래밍'],
    ),

    // 문화/행사
    const Interest(
      id: 'festival',
      name: '대학 축제',
      emoji: '🎪',
      category: InterestCategory.culture,
      description: '학교 축제 및 문화 행사',
      relatedKeywords: ['축제', '문화', '행사'],
    ),

    // 봉사/사회
    const Interest(
      id: 'volunteer',
      name: '봉사활동',
      emoji: '❤️',
      category: InterestCategory.volunteer,
      description: '지역사회 봉사 및 나눔 활동',
      relatedKeywords: ['봉사', '나눔', '지역사회'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 600.h),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: const Color(0xFFDC143C),
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  '관심 분야 설정',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            Text(
              '최대 5개까지 선택할 수 있어요',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF6B7280),
              ),
            ),

            SizedBox(height: 24.h),

            // 관심사 목록
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _allInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return _buildInterestChip(interest, isSelected);
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // 선택된 개수 표시
            Row(
              children: [
                Text(
                  '선택됨: ${_selectedInterests.length}/5',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: _selectedInterests.length > 5
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // 버튼들
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: const Color(0xFFE5E7EB)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // 저장 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedInterests.length <= 5
                        ? () => _saveInterests()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC143C),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestChip(Interest interest, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleInterest(interest),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFDC143C)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFDC143C)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              interest.emoji,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(width: 6.w),
            Text(
              interest.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleInterest(Interest interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else if (_selectedInterests.length < 5) {
        _selectedInterests.add(interest);
      }
    });
  }

  void _saveInterests() {
    // TODO: 실제로는 여기서 API 호출하여 관심사 저장
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('관심 분야가 저장되었어요 (${_selectedInterests.length}개)'),
        backgroundColor: const Color(0xFFDC143C),
      ),
    );
  }
}