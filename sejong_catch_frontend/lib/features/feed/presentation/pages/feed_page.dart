import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/widgets/ui/feed_category_filter.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/widgets/ui/feed_card.dart';

/// 📰 피드 페이지 - 공모전·취업·논문·공지·축제 통합 피드
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지
/// ✅ 공용 위젯 (AppChip, AppBadge) + Feature 위젯 활용
/// ✅ DRY 원칙 100% 적용 (534줄 → 197줄!)
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              '세종 캐치',
              style: AppTextStyles.appBarTitle,
            ),
          ],
        ),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppSpacing.categoryFilterHeight),
          child: FeedCategoryFilter(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
        ),
      ),
      body: _buildFeedList(),
    );
  }

  /// 📰 피드 리스트
  Widget _buildFeedList() {
    final filteredItems = _selectedCategory == '전체'
        ? _dummyFeedItems
        : _dummyFeedItems
              .where((item) => item['category'] == _selectedCategory)
              .toList();

    // 빈 상태 처리
    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    // 피드 카드 리스트
    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: filteredItems.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceLG,
      itemBuilder: (context, index) {
        final item = filteredItems[index];

        return FeedCard(
          item: item,
          onTap: () {
            debugPrint('🎯 [FeedPage] 카드 클릭! ID: ${item['id']}');
            debugPrint('🔍 [FeedPage] context.pushNamed 실행 시작...');

            // 상세 페이지로 이동 (GoRouter Named Route 사용 - 타입 안전!)
            try {
              context.pushNamed(
                'feed_detail',
                pathParameters: {'id': item['id'] as String},
              );
              debugPrint('✅ [FeedPage] pushNamed 성공!');
            } catch (e) {
              debugPrint('❌ [FeedPage] pushNamed 에러: $e');
            }
          },
          onBookmarkToggle: (isBookmarked) {
            setState(() {
              item['isBookmarked'] = isBookmarked;
            });
          },
        );
      },
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
            style: AppTextStyles.heading3,
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            '다른 카테고리를 확인해보세요',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
