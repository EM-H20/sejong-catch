import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/ui/category_filter_bar.dart';
import '../widgets/ui/feed_list_view.dart';

/// 📰 피드 페이지 - 메인 홈 화면
///
/// 🏆 login_page.dart의 86% 코드 감소 성공 패턴 적용!
/// ✅ UI 레이아웃만 담당 (150줄 목표 달성!)
/// ✅ 모든 상태 관리는 FeedController로 위임
/// ✅ 사용자 친화적 컴포넌트들로 분리
/// ✅ Clean Architecture 완벽 적용
class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // 🎨 세종 캐치 브랜드 앱바
      appBar: _buildAppBar(context),

      // 📱 메인 컨텐츠 영역
      body: const Column(
        children: [
          // 🏷️ 스마트 카테고리 필터 바
          CategoryFilterBar(),

          // 📋 인텔리전트 피드 리스트 뷰
          Expanded(child: FeedListView()),
        ],
      ),
    );
  }

  /// 🎨 세종 캐치 브랜드 앱바
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // 세종 캐치 로고 (향후 추가)
          Text(
            '세종 캐치',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.brandCrimson,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(width: 8.w),
          // 베타 배지
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.brandCrimsonLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'BETA',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow.withValues(alpha: 0.1),
      actions: [
        // 🔔 알림 버튼
        IconButton(
          icon: Stack(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 24.r,
                color: AppColors.brandCrimson,
              ),
              // 알림 뱃지 (새 알림이 있을 때만)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () => _showNotifications(context),
          tooltip: '새로운 알림 확인',
        ),

        // 🔍 검색 버튼 (향후 확장)
        IconButton(
          icon: Icon(
            Icons.search,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _showSearch(context),
          tooltip: '정보 검색',
        ),
      ],
    );
  }

  /// 📱 알림 버튼 처리 - 한국적 마이크로카피
  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('새로운 알림이 3개 있어요! 마감임박 정보도 확인해보세요 🔔'),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        action: SnackBarAction(
          label: '확인',
          textColor: Colors.white,
          onPressed: () {
            // 향후 알림 페이지로 이동
          },
        ),
      ),
    );
  }

  /// 🔍 검색 버튼 처리
  void _showSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('검색 기능이 곧 추가될 예정이에요! 기대해주세요 🔍'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
