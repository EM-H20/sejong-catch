import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

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
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  /// 📱 앱바 (로고, 설정, 알림 등)
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SizedBox(
            width: 28.r,
            height: 28.r,
            child: Image.asset('assets/sejong-logo.png', fit: BoxFit.contain),
          ),
          SizedBox(width: 8.w),
          Text(
            '세종 캐치',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.brandCrimson,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        // 🔔 알림 버튼
        IconButton(
          icon: Icon(Icons.notifications_outlined, size: 24.r),
          onPressed: () {
            // TODO: 알림 페이지로 이동
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('알림 기능 구현 예정')));
          },
        ),
        // ⚙️ 설정 버튼
        IconButton(
          icon: Icon(Icons.settings_outlined, size: 24.r),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // 임시 더미 데이터
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) {
        return _buildFeedCard(context, index);
      },
    );
  }

  /// 📇 피드 카드 (정보 카드)
  Widget _buildFeedCard(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: InkWell(
        onTap: () => context.push(AppRoutes.detailWithId(index.toString())),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ 카테고리 배지
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandCrimsonLight,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '공모전',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.brandCrimson,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16.r, color: Colors.grey[600]),
                  SizedBox(width: 4.w),
                  Text(
                    'D-15',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // 📰 제목
              Text(
                '2024 세종대학교 창업 아이디어 경진대회',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 8.h),

              // 📝 설명
              Text(
                '혁신적인 창업 아이디어로 미래를 설계해보세요. 우수상 수상자에게는 창업 지원금과 멘토링을 제공합니다.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12.h),

              // 🎯 액션 버튼
              Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 20.r,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '북마크',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.share_outlined,
                    size: 20.r,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '공유',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.r,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
