import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cards/app_card.dart';

/// 📰 피드 페이지 - 메인 홈 화면
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당, BottomNavigationBar 관련 로직 없음
/// ✅ 추천/마감임박/최신 정보 + 무한 스크롤 구현 예정
/// ✅ 상태 관리는 별도 Controller에서 처리 예정
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }


  /// 📄 메인 컨텐츠 영역
  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 피드 새로고침 로직 구현
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // 🏷️ 카테고리 필터 (공모전, 취업, 논문, 공지사항)
          SliverToBoxAdapter(child: _buildCategoryFilter()),

          // 📋 피드 리스트
          SliverToBoxAdapter(child: _buildFeedList(context)),
        ],
      ),
    );
  }

  /// 🏷️ 카테고리 필터 (가로 스크롤)
  Widget _buildCategoryFilter() {
    final categories = ['전체', '공모전', '취업', '논문', '공지사항'];

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final isSelected = index == 0; // 임시로 첫 번째 선택

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: FilterChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (selected) {
                // TODO: 카테고리 필터 로직 구현
              },
              selectedColor: AppColors.brandCrimsonLight,
              checkmarkColor: AppColors.brandCrimson,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                color: isSelected ? AppColors.brandCrimson : Colors.grey[700],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📋 피드 리스트 (임시 더미 데이터)
  Widget _buildFeedList(BuildContext context) {
    final dummyData = [
      {
        'title': '2024 세종대학교 창업 아이디어 경진대회',
        'subtitle': '혁신적인 창업 아이디어로 미래를 설계해보세요. 우수상 수상자에게는 창업 지원금과 멘토링을 제공합니다.',
        'category': '공모전',
        'deadline': DateTime.now().add(const Duration(days: 15)),
        'trustLevel': 'official',
        'priority': 'high',
        'sourceDomain': '세종대학교 공식',
      },
      {
        'title': 'SK하이닉스 2024 하계 인턴십 모집',
        'subtitle': '반도체 분야 최고 기업에서 실무 경험을 쌓을 기회입니다. 우수 인턴은 정규직 전환 가능합니다.',
        'category': '취업',
        'deadline': DateTime.now().add(const Duration(days: 7)),
        'trustLevel': 'official',
        'priority': 'high',
        'sourceDomain': 'SK하이닉스 채용',
      },
      {
        'title': '2024 AI 혁신 논문 공모전',
        'subtitle': '인공지능 분야의 창의적 연구 아이디어를 공모합니다. 우수 논문은 해외 학회 발표 기회 제공.',
        'category': '논문',
        'deadline': DateTime.now().add(const Duration(days: 30)),
        'trustLevel': 'academic',
        'priority': 'mid',
        'sourceDomain': '한국AI학회',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyData.length,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
        final data = dummyData[index % dummyData.length];
        return AppCard(
          title: data['title'] as String,
          subtitle: data['subtitle'] as String,
          category: data['category'] as String,
          deadline: data['deadline'] as DateTime,
          trustLevel: data['trustLevel'] as String,
          priority: data['priority'] as String,
          sourceDomain: data['sourceDomain'] as String,
          createdAt: DateTime.now().subtract(Duration(hours: index * 2)),
          viewCount: 150 + (index * 23),
          onTap: () => context.push(AppRoutes.detailWithId(index.toString())),
          onBookmarkTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('북마크에 추가했어요! 📌'),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  /// 🎆 AppBar 윈짓
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '세종 캐치',
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
            Icons.notifications_outlined,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _showNotifications(context),
        ),
      ],
    );
  }

  /// 📱 알림 버튼 처리
  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('새로운 알림이 3개 있어요! 🔔'),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 2),
      ),
    );
  }

}
