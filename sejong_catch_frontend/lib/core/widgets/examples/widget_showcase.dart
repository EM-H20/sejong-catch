import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets.dart';
import '../../core.dart';

/// Nucleus UI 컴포넌트 쇼케이스
/// 개발자가 모든 위젯들을 한눈에 보고 테스트할 수 있는 데모 페이지
/// 
/// 사용법:
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (context) => const WidgetShowcase(),
/// ));
/// ```
class WidgetShowcase extends StatefulWidget {
  const WidgetShowcase({super.key});

  @override
  State<WidgetShowcase> createState() => _WidgetShowcaseState();
}

class _WidgetShowcaseState extends State<WidgetShowcase> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context), // 다크 테마 배경색 명시적 설정!
      appBar: AppBar(
        title: const Text("Nucleus UI Showcase"),
        centerTitle: true,
      ),
      body: AppLoadingOverlay(
        isLoading: _isLoading,
        message: "컴포넌트를 로딩중...",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 세종대학교 로고 섹션
              _buildLogoSection(),
              
              SizedBox(height: 24.h),
              
              _buildSectionTitle("🎨 Color Palette"),
              _buildColorPaletteSection(),
              
              _buildSectionTitle("🎯 Buttons"),
              _buildButtonSection(),
              
              _buildSectionTitle("📝 Inputs"),
              _buildInputSection(),
              
              _buildSectionTitle("🗃 Cards"),
              _buildCardSection(),
              
              _buildSectionTitle("⏳ Loading States"),
              _buildLoadingSection(),
              
              _buildSectionTitle("💬 Dialogs & Feedback"),
              _buildDialogSection(),
              
              _buildSectionTitle("📊 Progress & Controls"),
              _buildProgressAndControlsSection(),
              
              _buildSectionTitle("👤 Avatar & Media"),
              _buildAvatarSection(),
              
              _buildSectionTitle("🧭 Navigation"),
              _buildNavigationSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // COLOR PALETTE SECTION - 테마별 색상 시스템 표시
  // ============================================================================
  
  Widget _buildColorPaletteSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 현재 테마 정보
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.themePrimary(context).withAlpha(26), // 10% 투명도
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.themePrimary(context).withAlpha(51), // 20% 투명도
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDark ? '🌙 Dark Theme Colors' : '☀️ Light Theme Colors',
                style: AppTextStyles.regularBold.copyWith(
                  color: AppColors.themePrimary(context),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                isDark 
                    ? 'Nucleus UI Purple 시스템 (개발자 친화적)'
                    : '세종대학교 Crimson Red 시스템 (대학 정체성)',
                style: AppTextStyles.smallRegular.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // 색상 칩들
        Row(
          children: [
            Expanded(
              child: _buildColorChip(
                "Primary",
                AppColors.themePrimary(context),
                isDark ? "#6B4EFF" : "#DC143C",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildColorChip(
                "Primary Dark", 
                AppColors.themePrimaryDark(context),
                isDark ? "#5538EE" : "#B0102F",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildColorChip(
                "Primary Light",
                AppColors.themePrimaryLight(context), 
                isDark ? "#9990FF" : "#E85D75",
              ),
            ),
          ],
        ),
        
        SizedBox(height: 8.h),
        
        // 시스템 색상들
        Row(
          children: [
            Expanded(
              child: _buildColorChip(
                "Success",
                AppColors.success,
                "#23C16B",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildColorChip(
                "Warning",
                AppColors.warning,
                "#FFB323",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildColorChip(
                "Error",
                AppColors.error,
                "#FF5247",
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildColorChip(String name, Color color, String hex) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(77), // 30% 투명도
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.skyWhite.withAlpha(230), // 90% 투명도
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            child: Column(
              children: [
                Text(
                  name,
                  style: AppTextStyles.tinyBold.copyWith(
                    color: AppColors.inkDarkest,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  hex,
                  style: AppTextStyles.tinyRegular.copyWith(
                    color: AppColors.inkLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // LOGO SECTION - 세종대학교 브랜딩
  // ============================================================================
  
  Widget _buildLogoSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        children: [
          // 세종대학교 로고 (그림자 제거하여 깔끔하게)
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                'assets/sejong-logo.png',
                fit: BoxFit.contain,
                color: isDark ? AppColors.skyWhite.withAlpha(204) : null, // 다크모드에서 80% 투명도
                colorBlendMode: isDark ? BlendMode.modulate : null,
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // 대학명 및 설명
          Text(
            'Sejong University',
            style: AppTextStyles.title3.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          Text(
            'Nucleus UI Design System',
            style: AppTextStyles.smallMedium.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // 테마 표시 뱃지
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.themePrimary(context).withAlpha(26), // 10% 투명도
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.themePrimary(context).withAlpha(51), // 20% 투명도
                width: 1,
              ),
            ),
            child: Text(
              isDark ? '🌙 Dark Theme' : '☀️ Light Theme',
              style: AppTextStyles.tinyMedium.copyWith(
                color: AppColors.themePrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, bottom: 16.h),
      child: Text(
        title,
        style: AppTextStyles.title3.copyWith(
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  // ============================================================================
  // BUTTON SHOWCASE
  // ============================================================================
  
  Widget _buildButtonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Buttons
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            AppPrimaryButton(
              text: "Primary",
              onPressed: () => _showToast("Primary 버튼 클릭!"),
            ),
            AppSecondaryButton(
              text: "Secondary",
              onPressed: () => _showToast("Secondary 버튼 클릭!"),
            ),
            AppTextButton(
              text: "Text Button",
              onPressed: () => _showToast("Text 버튼 클릭!"),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Special Buttons
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            AppDangerButton(
              text: "Delete",
              icon: Icons.delete,
              onPressed: () => _showDeleteDialog(),
            ),
            AppSuccessButton(
              text: "Save",
              icon: Icons.save,
              onPressed: () => _showToast("저장되었습니다!", type: AppToastType.success),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Icon Buttons
        Row(
          children: [
            AppIconButton(
              icon: Icons.favorite_outline,
              onPressed: () => _showToast("하트 클릭!"),
            ),
            SizedBox(width: 8.w),
            AppIconButton(
              icon: Icons.share,
              onPressed: () => _showToast("공유 클릭!"),
            ),
            SizedBox(width: 8.w),
            AppIconButton(
              icon: Icons.bookmark_border,
              onPressed: () => _showToast("북마크 클릭!"),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Loading Button
        AppButton(
          text: "Loading Test",
          type: AppButtonType.primary,
          isLoading: _isLoading,
          onPressed: () => _toggleLoading(),
        ),
      ],
    );
  }

  // ============================================================================
  // INPUT SHOWCASE
  // ============================================================================
  
  Widget _buildInputSection() {
    return Column(
      children: [
        AppSearchField(
          controller: _searchController,
          onChanged: (value) => debugPrint("검색어: $value"),
        ),
        
        SizedBox(height: 16.h),
        
        const AppEmailField(
          isRequired: true,
        ),
        
        SizedBox(height: 16.h),
        
        const AppPasswordField(
          isRequired: true,
        ),
        
        SizedBox(height: 16.h),
        
        const AppPhoneField(),
        
        SizedBox(height: 16.h),
        
        const AppTextArea(
          label: "메모",
          hintText: "자유롭게 작성해주세요...",
        ),
      ],
    );
  }

  // ============================================================================
  // CARD SHOWCASE  
  // ============================================================================
  
  Widget _buildCardSection() {
    return Column(
      children: [
        // Basic Cards
        Row(
          children: [
            Expanded(
              child: AppCard(
                variant: AppCardVariant.elevated,
                size: AppCardSize.medium,
                onTap: () => _showToast("Elevated Card 클릭!"),
                child: Column(
                  children: [
                    Icon(Icons.cloud, size: 32.w, color: AppColors.primary),
                    SizedBox(height: 8.h),
                    Text("Elevated", style: AppTextStyles.cardTitle),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: AppCard(
                variant: AppCardVariant.outlined,
                size: AppCardSize.medium,
                onTap: () => _showToast("Outlined Card 클릭!"),
                child: Column(
                  children: [
                    Icon(Icons.bookmark_outline, size: 32.w, color: AppColors.primary),
                    SizedBox(height: 8.h),
                    Text("Outlined", style: AppTextStyles.cardTitle),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Info Card Example
        InfoCard(
          title: "2024 세종대학교 창업경진대회 개최",
          source: "세종대학교 창업지원단",
          subtitle: "창업 아이디어 공모전",
          description: "세종대학교 재학생 및 졸업생을 대상으로 하는 창업경진대회입니다. 참신한 아이디어로 도전해보세요!",
          tags: const ["창업", "공모전", "대학생"],
          deadline: DateTime.now().add(const Duration(days: 5)),
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          trustLevel: TrustLevel.official,
          priority: Priority.high,
          isBookmarked: false,
          onTap: () => _showToast("정보 카드 클릭!"),
          onBookmarkTap: () => _showToast("북마크 토글!"),
        ),
      ],
    );
  }

  // ============================================================================
  // LOADING SHOWCASE
  // ============================================================================
  
  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading Indicators
        Row(
          children: [
            const AppLoadingIndicator(size: AppLoadingSize.small),
            SizedBox(width: 16.w),
            const AppLoadingIndicator(size: AppLoadingSize.medium),
            SizedBox(width: 16.w),
            const AppLoadingIndicator(size: AppLoadingSize.large, message: "로딩중..."),
          ],
        ),
        
        SizedBox(height: 24.h),
        
        // Skeleton Loading
        Container(
          height: 100.h,
          child: Row(
            children: [
              AppSkeleton(width: 60.w, height: 60.w, isCircle: true),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton(width: double.infinity, height: 16.h),
                    SizedBox(height: 8.h),
                    AppSkeleton(width: 150.w, height: 14.h),
                    const Spacer(),
                    AppSkeleton(width: 100.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // DIALOG SHOWCASE
  // ============================================================================
  
  Widget _buildDialogSection() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        ElevatedButton(
          onPressed: () => _showSuccessToast(),
          child: const Text("Success Toast"),
        ),
        ElevatedButton(
          onPressed: () => _showErrorToast(),
          child: const Text("Error Toast"),
        ),
        ElevatedButton(
          onPressed: () => _showConfirmDialog(),
          child: const Text("Confirm Dialog"),
        ),
        ElevatedButton(
          onPressed: () => _showBottomSheet(),
          child: const Text("Bottom Sheet"),
        ),
      ],
    );
  }

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================

  void _showToast(String message, {AppToastType type = AppToastType.info}) {
    AppToast.show(context, message, type: type);
  }

  void _showSuccessToast() {
    AppToast.success(context, "성공적으로 완료되었습니다! 🎉");
  }

  void _showErrorToast() {
    AppToast.error(context, "오류가 발생했습니다. 다시 시도해주세요.");
  }

  void _showDeleteDialog() {
    AppDialogs.showDeleteConfirmation(
      context: context,
      itemName: "테스트 항목",
      onConfirm: () => _showToast("삭제되었습니다!", type: AppToastType.success),
    );
  }

  void _showConfirmDialog() {
    AppDialogs.showConfirmation(
      context: context,
      title: "설정 저장",
      message: "변경된 설정을 저장하시겠습니까?",
      onConfirm: () => _showToast("설정이 저장되었습니다!", type: AppToastType.success),
    );
  }

  void _showBottomSheet() {
    AppDialogs.showOptions<String>(
      context: context,
      title: "옵션 선택",
      subtitle: "원하는 옵션을 선택해주세요",
      options: [
        const AppBottomSheetOption(
          title: "편집하기",
          subtitle: "내용을 수정합니다",
          icon: Icons.edit,
          value: "edit",
        ),
        const AppBottomSheetOption(
          title: "공유하기",
          subtitle: "다른 사람과 공유합니다",
          icon: Icons.share,
          value: "share",
        ),
        const AppBottomSheetOption(
          title: "삭제하기",
          subtitle: "영구적으로 삭제합니다",
          icon: Icons.delete,
          value: "delete",
          isDestructive: true,
        ),
      ],
    ).then((result) {
      if (result != null) {
        _showToast("선택된 옵션: $result");
      }
    });
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
    
    if (_isLoading) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  // ============================================================================
  // PROGRESS & CONTROLS SHOWCASE
  // ============================================================================
  
  Widget _buildProgressAndControlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Bars
        Text("Progress Bars", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        AppProgressBar(
          progress: 0.7,
          showPercentage: true,
          showLabel: true,
          label: "다운로드 진행률",
        ),
        SizedBox(height: 16.h),
        
        Row(
          children: [
            AppCircularProgress(
              progress: 0.6,
              showPercentage: true,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppStepProgressBar(
                totalSteps: 5,
                currentStep: 2,
                showLabels: true,
                stepLabels: const ["시작", "진행", "완료", "검토", "종료"],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 24.h),
        
        // Switches
        Text("Switches & Toggles", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        AppDarkModeToggle(
          value: false,
          onChanged: (value) => _showToast("다크모드: ${value ? 'ON' : 'OFF'}"),
        ),
        AppNotificationToggle(
          value: true,
          onChanged: (value) => _showToast("알림: ${value ? '허용' : '차단'}"),
        ),
        
        SizedBox(height: 16.h),
        
        // Selection Controls
        Text("Selection Controls", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        AppInterestCheckboxGroup(
          selectedValues: const {"startup", "job"},
          onChanged: (values) => _showToast("관심분야: ${values.length}개 선택"),
        ),
        
        SizedBox(height: 16.h),
        
        AppSortRadioGroup(
          value: "recommended",
          onChanged: (value) => _showToast("정렬: $value"),
        ),
      ],
    );
  }

  // ============================================================================
  // AVATAR SHOWCASE
  // ============================================================================
  
  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatars
        Text("Avatars", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        Row(
          children: [
            AppAvatar(
              name: "홍길동",
              size: AppAvatarSize.small,
              isOnline: true,
            ),
            SizedBox(width: 8.w),
            AppAvatar(
              name: "김철수",
              size: AppAvatarSize.medium,
              badge: const AppNotificationBadge(count: 3),
            ),
            SizedBox(width: 8.w),
            AppAvatar(
              name: "박영희",
              size: AppAvatarSize.large,
              shape: AppAvatarShape.rounded,
            ),
            SizedBox(width: 8.w),
            AppSourceAvatar(
              imageUrl: "https://via.placeholder.com/64",
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Avatar Group
        AppAvatarGroup(
          avatars: const [
            AppAvatarData(name: "홍길동"),
            AppAvatarData(name: "김철수"),
            AppAvatarData(name: "박영희"),
            AppAvatarData(name: "이민호"),
            AppAvatarData(name: "최지우"),
          ],
          onTap: () => _showToast("아바타 그룹 클릭!"),
        ),
        
        SizedBox(height: 16.h),
        
        // Badges
        Text("Badges", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        Row(
          children: [
            const AppNewBadge(),
            SizedBox(width: 8.w),
            const AppHotBadge(),
            SizedBox(width: 8.w),
            const AppNotificationBadge(count: 99),
            SizedBox(width: 8.w),
            const AppBadge(
              text: "추천",
              type: AppBadgeType.status,
              status: AppBadgeStatus.info,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================================
  // NAVIGATION SHOWCASE
  // ============================================================================
  
  Widget _buildNavigationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bars
        Text("Tab Bars", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        AppMainTabBar(
          currentIndex: 0,
          onTap: (index) => _showToast("탭 $index 선택"),
        ),
        
        SizedBox(height: 16.h),
        
        // Icon Tab Bar
        AppTabBar(
          type: AppTabBarType.iconText,
          tabs: const [
            AppTabItem(label: "홈", icon: Icons.home),
            AppTabItem(label: "검색", icon: Icons.search),
            AppTabItem(label: "프로필", icon: Icons.person),
          ],
          currentIndex: 0,
          onTap: (index) => _showToast("아이콘 탭 $index 선택"),
        ),
        
        SizedBox(height: 16.h),
        
        // Breadcrumb
        Text("Breadcrumb", style: AppTextStyles.regularBold),
        SizedBox(height: 8.h),
        const AppBreadcrumb(
          items: [
            AppBreadcrumbItem(label: "홈"),
            AppBreadcrumbItem(label: "공모전"),
            AppBreadcrumbItem(label: "IT/개발"),
            AppBreadcrumbItem(label: "세종대학교 해커톤"),
          ],
        ),
      ],
    );
  }
}