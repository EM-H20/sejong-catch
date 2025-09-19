import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// 🎨 세종 캐치 브랜드 앱바
///
/// 세종대 학생들이 "이거 완전 내 스타일이야!" 하고 말할 만한 앱바!
/// 한국적 감성과 사용자 친화적 디자인이 완벽하게 조화된 헤더 컴포넌트
class FeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final bool hasNewNotifications;

  const FeedAppBar({
    super.key,
    this.onNotificationTap,
    this.onSearchTap,
    this.hasNewNotifications = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _buildTitle(),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow.withValues(alpha: 0.1),
      actions: _buildActions(context),
      // 접근성 개선
      automaticallyImplyLeading: false,
      toolbarTextStyle: Theme.of(context).textTheme.bodyMedium,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
    );
  }

  /// 브랜드 타이틀 구성
  Widget _buildTitle() {
    return Semantics(
      label: '세종 캐치, 세종대학교 학생을 위한 정보 허브',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 세종 캐치 로고 텍스트
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

          // 베타 배지 - 한국적 감성
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
    );
  }

  /// 액션 버튼들 구성
  List<Widget> _buildActions(BuildContext context) {
    return [
      // 🔔 알림 버튼
      Semantics(
        label: hasNewNotifications ? '새로운 알림이 있습니다' : '알림 확인',
        hint: '탭하여 알림을 확인하세요',
        button: true,
        child: IconButton(
          icon: Stack(
            children: [
              Icon(
                Icons.notifications_outlined,
                size: 24.r,
                color: AppColors.brandCrimson,
              ),
              // 알림 뱃지 - 한국적 빨간 점
              if (hasNewNotifications)
                Positioned(
                  right: 2.w,
                  top: 2.h,
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
          onPressed: () => _handleNotificationTap(context),
          tooltip: '새로운 알림 확인',
        ),
      ),

      // 🔍 검색 버튼
      Semantics(
        label: '정보 검색',
        hint: '원하는 정보를 검색해보세요',
        button: true,
        child: IconButton(
          icon: Icon(
            Icons.search,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _handleSearchTap(context),
          tooltip: '정보 검색',
        ),
      ),

      SizedBox(width: 8.w), // 우측 여백
    ];
  }

  /// 알림 버튼 처리 - 완전 한국적 마이크로카피
  void _handleNotificationTap(BuildContext context) {
    if (onNotificationTap != null) {
      onNotificationTap!();
    } else {
      _showKoreanSnackBar(
        context,
        '새로운 알림이 3개 있어요! 마감임박 정보도 확인해보세요 🔔',
        AppColors.brandCrimson,
        action: SnackBarAction(
          label: '확인',
          textColor: Colors.white,
          onPressed: () {
            // 향후 알림 페이지로 이동
          },
        ),
      );
    }
  }

  /// 검색 버튼 처리
  void _handleSearchTap(BuildContext context) {
    if (onSearchTap != null) {
      onSearchTap!();
    } else {
      _showKoreanSnackBar(
        context,
        '검색 기능이 곧 추가될 예정이에요! 기대해주세요 🔍',
        AppColors.success,
      );
    }
  }

  /// 한국적 감성의 스낵바 표시
  void _showKoreanSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor, {
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        margin: EdgeInsets.all(16.w),
        action: action,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}