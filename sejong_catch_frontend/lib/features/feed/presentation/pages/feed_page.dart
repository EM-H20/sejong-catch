import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';

/// 📰 피드 페이지 - 공모전·취업·논문·공지·축제 통합 피드
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지 (Search 패턴 적용!)
/// ✅ 카테고리 필터 칩 + 피드 카드 리스트
/// ✅ 더미 데이터 하드코딩
/// ✅ AppColors, AppSpacing, AppDivider 디자인 토큰 사용
class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '공모전', '취업', '논문', '학교공지', '축제'];

  // 더미 피드 데이터
  final List<Map<String, dynamic>> _dummyFeedItems = [
    {
      'id': '1',
      'title': '2024 캡스톤 디자인 경진대회',
      'description': '우수작 선정 시 상금 300만원 + 창업 지원',
      'category': '공모전',
      'thumbnailUrl': 'https://via.placeholder.com/150',
      'dDay': 7,
      'viewCount': 1234,
      'priority': 'high',
      'isBookmarked': false,
    },
    {
      'id': '2',
      'title': '네이버 클라우드 신입 채용',
      'description': '백엔드 개발자 채용 (~25.12.31)',
      'category': '취업',
      'thumbnailUrl': 'https://via.placeholder.com/150',
      'dDay': 23,
      'viewCount': 567,
      'priority': 'mid',
      'isBookmarked': true,
    },
    {
      'id': '3',
      'title': '한국정보과학회 논문 공모',
      'description': 'AI/빅데이터 분야 우수 논문 모집',
      'category': '논문',
      'thumbnailUrl': 'https://via.placeholder.com/150',
      'dDay': 15,
      'viewCount': 892,
      'priority': 'mid',
      'isBookmarked': false,
    },
    {
      'id': '4',
      'title': '[학교공지] 2025-1학기 수강신청 안내',
      'description': '수강신청 기간: 2025.02.10 ~ 02.14',
      'category': '학교공지',
      'thumbnailUrl': 'https://via.placeholder.com/150',
      'dDay': 45,
      'viewCount': 3421,
      'priority': 'high',
      'isBookmarked': false,
    },
    {
      'id': '5',
      'title': '세종대 대동제 부스 모집',
      'description': '대동제 축제 부스 운영 팀 모집 중!',
      'category': '축제',
      'thumbnailUrl': 'https://via.placeholder.com/150',
      'dDay': 30,
      'viewCount': 1876,
      'priority': 'low',
      'isBookmarked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 카테고리 필터
          _buildCategoryFilter(),

          // 구분선 추가 (얇은 구분선)
          AppDivider.thin(),

          // 피드 리스트
          Expanded(child: _buildFeedList()),
        ],
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
            '피드',
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
          icon: Icon(Icons.notifications_outlined, size: 24.sp),
          color: AppColors.textSecondary,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('알림 기능 준비 중! 🔔')));
          },
        ),
      ],
    );
  }

  /// 🏷️ 카테고리 필터
  Widget _buildCategoryFilter() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(color: AppColors.white),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => AppSpacing.horizontalSpaceSM,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brandCrimson : AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandCrimson
                      : AppColors.divider,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📰 피드 리스트
  Widget _buildFeedList() {
    final filteredItems = _selectedCategory == '전체'
        ? _dummyFeedItems
        : _dummyFeedItems
              .where((item) => item['category'] == _selectedCategory)
              .toList();

    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: filteredItems.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceLG,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildFeedCard(item);
      },
    );
  }

  /// 📇 피드 카드
  Widget _buildFeedCard(Map<String, dynamic> item) {
    final dDay = item['dDay'] as int;
    final isUrgent = dDay <= 7;
    final priority = item['priority'] as String;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${item['title']} 상세보기 (준비 중)')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUrgent
                ? AppColors.brandCrimson.withValues(alpha: 0.3)
                : AppColors.divider,
            width: isUrgent ? 2 : 1,
          ),
          boxShadow: AppShadows.basic,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Stack(
                children: [
                  // 썸네일 플레이스홀더
                  Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: AppColors.disabled,
                    ),
                  ),

                  // 카테고리 배지
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: _buildCategoryBadge(item['category'] as String),
                  ),

                  // 북마크 버튼
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          item['isBookmarked'] =
                              !(item['isBookmarked'] as bool);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.basic,
                        ),
                        child: Icon(
                          item['isBookmarked'] as bool
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          size: 20.sp,
                          color: AppColors.brandCrimson,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 구분선 (카드 내부 - 썸네일과 내용 사이)
            AppDivider.thin(),

            // 카드 내용
            Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.verticalSpaceXS,

                  // 설명
                  Text(
                    item['description'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.verticalSpaceMD,

                  // 구분선 (내용과 하단 정보 사이)
                  AppDivider.thin(),

                  AppSpacing.verticalSpaceMD,

                  // 하단 정보 (D-Day, 조회수, 우선순위)
                  Row(
                    children: [
                      // D-Day
                      _buildInfoChip(
                        icon: Icons.access_time,
                        label: 'D-$dDay',
                        color: isUrgent
                            ? AppColors.error
                            : AppColors.textSecondary,
                        backgroundColor: isUrgent
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.surface,
                      ),

                      AppSpacing.horizontalSpaceSM,

                      // 조회수
                      _buildInfoChip(
                        icon: Icons.visibility_outlined,
                        label: _formatNumber(item['viewCount'] as int),
                        color: AppColors.textSecondary,
                        backgroundColor: AppColors.surface,
                      ),

                      AppSpacing.horizontalSpaceSM,

                      // 우선순위
                      if (priority != 'low') _buildPriorityBadge(priority),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏷️ 카테고리 배지
  Widget _buildCategoryBadge(String category) {
    Color badgeColor;
    switch (category) {
      case '공모전':
        badgeColor = AppColors.brandCrimson;
        break;
      case '취업':
        badgeColor = AppColors.trustAcademic; // 파란색
        break;
      case '논문':
        badgeColor = const Color(0xFF7C3AED); // 보라색
        break;
      case '학교공지':
        badgeColor = AppColors.success;
        break;
      case '축제':
        badgeColor = AppColors.warning;
        break;
      default:
        badgeColor = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// ℹ️ 정보 칩
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          AppSpacing.horizontalSpaceXS,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 🏆 우선순위 배지
  Widget _buildPriorityBadge(String priority) {
    String label;
    Color color;

    switch (priority) {
      case 'high':
        label = '높음';
        color = AppColors.priorityHigh;
        break;
      case 'mid':
        label = '중간';
        color = AppColors.priorityMid;
        break;
      default:
        label = '낮음';
        color = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12.sp, color: color),
          AppSpacing.horizontalSpaceXS,
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 📭 빈 상태
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64.sp, color: AppColors.disabled),
          AppSpacing.verticalSpaceLG,
          Text(
            '$_selectedCategory 정보가 없어요',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            '다른 카테고리를 확인해보세요',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// 🔢 숫자 포맷팅 (1234 → 1.2K)
  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
