import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../media/app_avatar.dart';

/// Nucleus UI 기반 네비게이션 컴포넌트 시스템
/// 세종캐치 앱의 모든 네비게이션을 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppTabBar(
///   tabs: ["홈", "검색", "북마크"],
///   currentIndex: selectedIndex,
///   onTap: (index) => setState(() => selectedIndex = index),
/// )
/// ```

enum AppTabBarType {
  /// 기본 탭바
  standard,
  
  /// 세그먼트 컨트롤 스타일
  segmented,
  
  /// 아이콘과 텍스트
  iconText,
  
  /// 아이콘만
  iconOnly,
}

enum AppAppBarType {
  /// 기본 앱바
  standard,
  
  /// 검색 앱바
  search,
  
  /// 뒤로가기 포함
  back,
  
  /// 액션 버튼 포함
  action,
}

// ============================================================================
// TAB BAR COMPONENTS
// ============================================================================

/// 기본 탭바
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.type = AppTabBarType.standard,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
  });

  /// 탭 아이템들
  final List<AppTabItem> tabs;
  
  /// 현재 선택된 인덱스
  final int currentIndex;
  
  /// 탭 선택 콜백
  final ValueChanged<int> onTap;
  
  /// 탭바 타입
  final AppTabBarType type;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 선택된 색상
  final Color? selectedColor;
  
  /// 선택되지 않은 색상
  final Color? unselectedColor;
  
  /// 인디케이터 색상
  final Color? indicatorColor;
  
  /// 패딩
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppTabBarType.standard:
        return _buildStandardTabBar(context);
      case AppTabBarType.segmented:
        return _buildSegmentedTabBar(context);
      case AppTabBarType.iconText:
        return _buildIconTextTabBar(context);
      case AppTabBarType.iconOnly:
        return _buildIconOnlyTabBar(context);
    }
  }

  Widget _buildStandardTabBar(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.surfaceContainer(context),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
        labelColor: selectedColor ?? AppColors.primary,
        unselectedLabelColor: unselectedColor ?? AppColors.textSecondary(context),
        labelStyle: AppTextStyles.regularMedium,
        unselectedLabelStyle: AppTextStyles.regularRegular,
        indicatorColor: indicatorColor ?? AppColors.primary,
        indicatorWeight: 2.h,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context) {
    return Container(
      margin: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.border(context),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;
          final isFirst = index == 0;
          final isLast = index == tabs.length - 1;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (selectedColor ?? AppColors.primary)
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isFirst ? 8.r : 0),
                    bottomLeft: Radius.circular(isFirst ? 8.r : 0),
                    topRight: Radius.circular(isLast ? 8.r : 0),
                    bottomRight: Radius.circular(isLast ? 8.r : 0),
                  ),
                ),
                child: Text(
                  tab.label,
                  style: AppTextStyles.smallMedium.copyWith(
                    color: isSelected
                        ? AppColors.skyWhite
                        : (unselectedColor ?? AppColors.textSecondary(context)),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconTextTabBar(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.surfaceContainer(context),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 24.w,
                        color: isSelected
                            ? (selectedColor ?? AppColors.primary)
                            : (unselectedColor ?? AppColors.textSecondary(context)),
                      ),
                      SizedBox(height: 4.h),
                    ],
                    Text(
                      tab.label,
                      style: (isSelected ? AppTextStyles.tinyMedium : AppTextStyles.tinyRegular)
                          .copyWith(
                        color: isSelected
                            ? (selectedColor ?? AppColors.primary)
                            : (unselectedColor ?? AppColors.textSecondary(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconOnlyTabBar(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.surfaceContainer(context),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Icon(
                  tab.icon ?? Icons.circle,
                  size: 24.w,
                  color: isSelected
                      ? (selectedColor ?? AppColors.primary)
                      : (unselectedColor ?? AppColors.textSecondary(context)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================================
// APP BAR COMPONENTS
// ============================================================================

/// 고도화된 앱바
class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppBar({
    super.key,
    this.title,
    this.type = AppAppBarType.standard,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.onBackPressed,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint = "검색...",
    this.avatar,
    this.notificationCount,
    this.onNotificationTap,
  });

  /// 제목
  final String? title;
  
  /// 앱바 타입
  final AppAppBarType type;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 전경색
  final Color? foregroundColor;
  
  /// 그림자 높이
  final double elevation;
  
  /// 제목 중앙 정렬
  final bool centerTitle;
  
  /// 왼쪽 위젯
  final Widget? leading;
  
  /// 오른쪽 액션들
  final List<Widget>? actions;
  
  /// 뒤로가기 콜백
  final VoidCallback? onBackPressed;
  
  /// 검색 컨트롤러
  final TextEditingController? searchController;
  
  /// 검색어 변경 콜백
  final ValueChanged<String>? onSearchChanged;
  
  /// 검색 제출 콜백
  final ValueChanged<String>? onSearchSubmitted;
  
  /// 검색 힌트
  final String searchHint;
  
  /// 사용자 아바타
  final AppAvatar? avatar;
  
  /// 알림 개수
  final int? notificationCount;
  
  /// 알림 탭 콜백
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppAppBarType.standard:
        return _buildStandardAppBar(context);
      case AppAppBarType.search:
        return _buildSearchAppBar(context);
      case AppAppBarType.back:
        return _buildBackAppBar(context);
      case AppAppBarType.action:
        return _buildActionAppBar(context);
    }
  }

  Widget _buildStandardAppBar(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: backgroundColor ?? AppColors.surfaceContainer(context),
      foregroundColor: foregroundColor ?? AppColors.textPrimary(context),
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
    );
  }

  Widget _buildSearchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surfaceContainer(context),
      elevation: elevation,
      title: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant(context),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: AppTextStyles.regularRegular.copyWith(
              color: AppColors.textTertiary(context),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary(context),
              size: 20.w,
            ),
            suffixIcon: searchController?.text.isNotEmpty == true
                ? IconButton(
                    onPressed: () {
                      searchController?.clear();
                      onSearchChanged?.call('');
                    },
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.textSecondary(context),
                      size: 20.w,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          ),
        ),
      ),
      actions: actions,
    );
  }

  Widget _buildBackAppBar(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: backgroundColor ?? AppColors.surfaceContainer(context),
      foregroundColor: foregroundColor ?? AppColors.textPrimary(context),
      elevation: elevation,
      centerTitle: centerTitle,
      leading: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: actions,
    );
  }

  Widget _buildActionAppBar(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: backgroundColor ?? AppColors.surfaceContainer(context),
      foregroundColor: foregroundColor ?? AppColors.textPrimary(context),
      elevation: elevation,
      centerTitle: centerTitle,
      leading: leading,
      actions: [
        // 알림 버튼
        if (onNotificationTap != null)
          AppBadgedWidget(
            badge: notificationCount != null && notificationCount! > 0
                ? AppNotificationBadge(count: notificationCount)
                : const SizedBox.shrink(),
            child: IconButton(
              onPressed: onNotificationTap,
              icon: const Icon(Icons.notifications_outlined),
            ),
          ),
        
        // 사용자 아바타
        if (avatar != null)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: avatar,
          ),
        
        // 추가 액션들
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// ============================================================================
// BOTTOM NAVIGATION COMPONENTS
// ============================================================================

/// 고도화된 하단 네비게이션
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.type = BottomNavigationBarType.fixed,
  });

  /// 네비게이션 아이템들
  final List<AppBottomNavItem> items;
  
  /// 현재 선택된 인덱스
  final int currentIndex;
  
  /// 아이템 선택 콜백
  final ValueChanged<int> onTap;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 선택된 색상
  final Color? selectedColor;
  
  /// 선택되지 않은 색상
  final Color? unselectedColor;
  
  /// 라벨 표시 여부
  final bool showLabels;
  
  /// 네비게이션 타입
  final BottomNavigationBarType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainer(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.inkDarkest.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 아이콘 + 배지
                        AppBadgedWidget(
                          badge: item.badgeCount != null && item.badgeCount! > 0
                              ? AppNotificationBadge(count: item.badgeCount)
                              : const SizedBox.shrink(),
                          child: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            size: 24.w,
                            color: isSelected
                                ? (selectedColor ?? AppColors.primary)
                                : (unselectedColor ?? AppColors.textSecondary(context)),
                          ),
                        ),
                        
                        // 라벨
                        if (showLabels) ...[
                          SizedBox(height: 4.h),
                          Text(
                            item.label,
                            style: AppTextStyles.tinyMedium.copyWith(
                              color: isSelected
                                  ? (selectedColor ?? AppColors.primary)
                                  : (unselectedColor ?? AppColors.textSecondary(context)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// BREADCRUMB COMPONENT
// ============================================================================

/// 브레드크럼 네비게이션
class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({
    super.key,
    required this.items,
    this.separator = ">",
    this.onTap,
    this.maxItems = 3,
  });

  /// 브레드크럼 아이템들
  final List<AppBreadcrumbItem> items;
  
  /// 구분자
  final String separator;
  
  /// 아이템 탭 콜백
  final Function(int index)? onTap;
  
  /// 최대 표시 개수
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final displayItems = items.length > maxItems 
        ? [items.first, ...items.skip(items.length - maxItems + 1)]
        : items;
    
    return Row(
      children: [
        ...displayItems.asMap().entries.expand((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == displayItems.length - 1;
          final actualIndex = items.length > maxItems && index > 0 
              ? items.length - maxItems + index 
              : index;
          
          return [
            if (index == 1 && items.length > maxItems)
              Text(
                "...",
                style: AppTextStyles.smallRegular.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            if (index == 1 && items.length > maxItems)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  separator,
                  style: AppTextStyles.smallRegular.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            GestureDetector(
              onTap: isLast ? null : () => onTap?.call(actualIndex),
              child: Text(
                item.label,
                style: AppTextStyles.smallMedium.copyWith(
                  color: isLast
                      ? AppColors.textPrimary(context)
                      : AppColors.primary,
                  decoration: isLast ? null : TextDecoration.underline,
                ),
              ),
            ),
            if (!isLast)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  separator,
                  style: AppTextStyles.smallRegular.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
          ];
        }).toList(),
      ],
    );
  }
}

// ============================================================================
// DATA CLASSES
// ============================================================================

/// 탭 아이템
class AppTabItem {
  const AppTabItem({
    required this.label,
    this.icon,
    this.badge,
  });

  final String label;
  final IconData? icon;
  final Widget? badge;
}

/// 하단 네비게이션 아이템
class AppBottomNavItem {
  const AppBottomNavItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badgeCount,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final int? badgeCount;
}

/// 브레드크럼 아이템
class AppBreadcrumbItem {
  const AppBreadcrumbItem({
    required this.label,
    this.route,
  });

  final String label;
  final String? route;
}

// ============================================================================
// 편의성 생성자들 - 세종캐치 특화
// ============================================================================

/// 세종캐치 메인 탭바 (홈, 검색, 북마크 등)
class AppMainTabBar extends AppTabBar {
  AppMainTabBar({
    super.key,
    required super.currentIndex,
    required super.onTap,
  }) : super(
         type: AppTabBarType.segmented,
         tabs: const [
           AppTabItem(label: "추천"),
           AppTabItem(label: "마감임박"),
           AppTabItem(label: "최신"),
         ],
       );
}

/// 세종캐치 하단 네비게이션
class AppMainBottomNav extends AppBottomNavigationBar {
  AppMainBottomNav({
    super.key,
    required super.currentIndex,
    required super.onTap,
  }) : super(
         items: const [
           AppBottomNavItem(
             label: "홈",
             icon: Icons.home_outlined,
             selectedIcon: Icons.home,
           ),
           AppBottomNavItem(
             label: "검색",
             icon: Icons.search_outlined,
             selectedIcon: Icons.search,
           ),
           AppBottomNavItem(
             label: "북마크",
             icon: Icons.bookmark_outline,
             selectedIcon: Icons.bookmark,
           ),
           AppBottomNavItem(
             label: "알림",
             icon: Icons.notifications_outlined,
             selectedIcon: Icons.notifications,
           ),
           AppBottomNavItem(
             label: "내 정보",
             icon: Icons.person_outline,
             selectedIcon: Icons.person,
           ),
         ],
       );
}