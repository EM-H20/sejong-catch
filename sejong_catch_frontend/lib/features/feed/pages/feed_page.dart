import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 피드 페이지 (홈 화면)
///
/// 세종 캐치의 메인 화면입니다.
/// 공모전, 취업, 논문, 공지사항 등의 정보를 한눈에 볼 수 있어요.
/// 나중에는 Recommended/Deadline/Latest 탭으로 구성될 예정입니다.
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 투명한 AppBar (extendBodyBehindAppBar와 함께 사용)
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('세종 캐치'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 웰컴 섹션
              _buildWelcomeSection(context),
              SizedBox(height: 32.h),

              // 카테고리 섹션
              _buildCategorySection(context),
              SizedBox(height: 32.h),

              // 최근 정보 섹션
              _buildRecentInfoSection(context),
              SizedBox(height: 32.h),

              // 개발 상태 표시
              _buildDevelopmentStatus(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 웰컴 섹션 구성
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandCrimson, AppColors.brandCrimsonDark],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandCrimson.withValues(alpha: 0.3),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘
          SizedBox(
            width: 52.w,
            height: 52.h,
            child: Image.asset(
              'assets/sejong-logo.png',
              fit: BoxFit.contain,
              color: AppColors.white, // 필요하면 흰색 필터 입히기
            ),
          ),
          SizedBox(height: 16.h),

          // 제목
          Text(
            '환영합니다! 🎉',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),

          // 설명
          Text(
            '세종인을 위한 정보 허브에서\n공모전, 취업, 논문, 공지사항을\n한 곳에서 확인하세요!',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 카테고리 섹션 구성
  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '카테고리',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),

        // 카테고리 그리드
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.5,
          children: [
            _buildCategoryCard(
              context,
              icon: Icons.emoji_events,
              title: '공모전',
              subtitle: '다양한 공모전 정보',
              color: AppColors.brandCrimson,
            ),
            _buildCategoryCard(
              context,
              icon: Icons.work,
              title: '취업',
              subtitle: '채용 공고 & 인턴십',
              color: AppColors.trustAcademic,
            ),
            _buildCategoryCard(
              context,
              icon: Icons.article,
              title: '논문',
              subtitle: '학술 논문 & 연구',
              color: AppColors.trustPress,
            ),
            _buildCategoryCard(
              context,
              icon: Icons.announcement,
              title: '공지',
              subtitle: '학교 공지사항',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }

  /// 카테고리 카드 구성
  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 카테고리별 페이지로 이동
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title 카테고리 개발 예정입니다!'),
                backgroundColor: color,
              ),
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 아이콘
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, size: 20.w, color: color),
                ),
                SizedBox(height: 8.h),

                // 제목
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),

                // 부제목
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 최근 정보 섹션 구성
  Widget _buildRecentInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 정보',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: 전체 보기 페이지로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('전체 보기 기능 개발 예정입니다!')),
                );
              },
              child: Text(
                '전체 보기',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.brandCrimson,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // 샘플 정보 카드들
        Column(
          children: [
            _buildInfoCard(
              context,
              category: '공모전',
              title: '2024 세종대학교 창업 아이디어 공모전',
              deadline: 'D-15',
              trustLevel: 'official',
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              context,
              category: '취업',
              title: 'SW개발자 채용 - 카카오엔터프라이즈',
              deadline: 'D-7',
              trustLevel: 'press',
            ),
            SizedBox(height: 12.h),
            _buildInfoCard(
              context,
              category: '논문',
              title: '인공지능 학회 논문 발표 모집',
              deadline: 'D-30',
              trustLevel: 'academic',
            ),
          ],
        ),
      ],
    );
  }

  /// 정보 카드 구성
  Widget _buildInfoCard(
    BuildContext context, {
    required String category,
    required String title,
    required String deadline,
    required String trustLevel,
  }) {
    final trustColor = AppColors.getTrustColor(trustLevel);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 상세 페이지로 이동
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title 상세 정보 개발 예정입니다!')));
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 정보 (카테고리, 신뢰도, 마감일)
                Row(
                  children: [
                    // 카테고리 칩
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: trustColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: trustColor,
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 마감일
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            deadline.contains('D-7') ||
                                deadline.contains('D-15')
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        deadline,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              deadline.contains('D-7') ||
                                  deadline.contains('D-15')
                              ? AppColors.error
                              : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 제목
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // 추가 정보
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 12.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '2시간 전',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(width: 16.w),

                    Icon(
                      Icons.visibility,
                      size: 12.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '124명 조회',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 개발 상태 표시
  Widget _buildDevelopmentStatus(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 32.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(height: 12.h),
          Text(
            '🚧 열심히 개발 중입니다!',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '곧 더 많은 기능이 추가될 예정이에요.\n세종 캐치와 함께 정보를 효율적으로 관리하세요!',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
