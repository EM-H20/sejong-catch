import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

// Controller imports
import '../controllers/onboarding_controller.dart';

/// 온보딩 4단계: 개인화 설정 페이지
/// 
/// 사용자의 학과와 관심사를 설정받아서
/// 맞춤 추천을 위한 데이터를 수집합니다.
class OnboardingPersonalizePage extends StatefulWidget {
  const OnboardingPersonalizePage({super.key});

  @override
  State<OnboardingPersonalizePage> createState() => _OnboardingPersonalizePageState();
}

class _OnboardingPersonalizePageState extends State<OnboardingPersonalizePage>
    with TickerProviderStateMixin {
  
  late AnimationController _sectionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _customInterestController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    _sectionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sectionController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sectionController,
      curve: Curves.easeOut,
    ));
    
    // 애니메이션 시작
    _startAnimations();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _sectionController.forward();
  }
  
  @override
  void dispose() {
    _customInterestController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              
              // 타이틀 섹션
              _buildTitleSection(),
              
              SizedBox(height: 30.h),
              
              // 설정 섹션들
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // 학과 선택
                      _buildDepartmentSection(),
                      
                      SizedBox(height: 30.h),
                      
                      // 관심사 선택
                      _buildInterestsSection(),
                      
                      SizedBox(height: 30.h),
                      
                      // 설정 확인
                      _buildSettingsPreview(),
                      
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 타이틀 섹션
  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          '맞춤 설정',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '나만의 맞춤 정보를 받기 위해\n학과와 관심사를 설정해주세요',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// 학과 선택 섹션
  Widget _buildDepartmentSection() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.brandCrimsonLight,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandCrimson.withValues(alpha: 0.08),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 섹션 헤더
              Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 24.w,
                    color: AppColors.brandCrimson,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '학과 선택',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandCrimsonLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '필수',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.brandCrimson,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // 학과 드롭다운
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: controller.selectedDepartment != null
                        ? AppColors.brandCrimson
                        : AppColors.divider,
                    width: 1.w,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Department>(
                    value: controller.selectedDepartment,
                    hint: Text(
                      '학과를 선택해주세요',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.brandCrimson,
                    ),
                    onChanged: controller.selectDepartment,
                    items: Departments.all.map((dept) {
                      return DropdownMenuItem<Department>(
                        value: dept,
                        child: Text(
                          dept.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // 도움말 텍스트
              Text(
                '선택한 학과에 맞는 정보를 우선적으로 추천해드려요',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// 관심사 선택 섹션
  Widget _buildInterestsSection() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.brandCrimsonLight,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandCrimson.withValues(alpha: 0.08),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 섹션 헤더
              Row(
                children: [
                  Icon(
                    Icons.interests,
                    size: 24.w,
                    color: AppColors.brandCrimson,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '관심사 선택',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${controller.selectedInterests.length}/5',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.brandCrimson,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // 카테고리별 관심사
              ...InterestKeywords.byCategory.entries.map((entry) {
                return _buildInterestCategory(
                  entry.key,
                  entry.value,
                  controller,
                );
              }),
              
              SizedBox(height: 16.h),
              
              // 커스텀 관심사 추가
              _buildCustomInterestField(controller),
              
              SizedBox(height: 8.h),
              
              // 도움말 텍스트
              Text(
                '최대 5개까지 선택할 수 있어요. 관심사에 맞는 정보를 우선 추천해드릴게요!',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// 관심사 카테고리
  Widget _buildInterestCategory(
    String category,
    List<String> keywords,
    OnboardingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: keywords.map((keyword) {
            final isSelected = controller.selectedInterests.contains(keyword);
            final canSelect = controller.selectedInterests.length < 5 || isSelected;
            
            return GestureDetector(
              onTap: canSelect ? () => controller.toggleInterest(keyword) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.brandCrimson
                      : canSelect
                          ? AppColors.surface
                          : AppColors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.brandCrimson
                        : canSelect
                            ? AppColors.divider
                            : AppColors.divider.withValues(alpha: 0.5),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  keyword,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.white
                        : canSelect
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
  
  /// 커스텀 관심사 입력 필드
  Widget _buildCustomInterestField(OnboardingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _customInterestController,
            decoration: InputDecoration(
              hintText: '다른 관심사를 직접 입력해보세요',
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.brandCrimson),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
            style: TextStyle(fontSize: 12.sp),
            onSubmitted: (value) => _addCustomInterest(controller, value),
          ),
        ),
        SizedBox(width: 8.w),
        IconButton(
          onPressed: controller.selectedInterests.length < 5
              ? () => _addCustomInterest(controller, _customInterestController.text)
              : null,
          icon: Icon(
            Icons.add_circle,
            color: controller.selectedInterests.length < 5
                ? AppColors.brandCrimson
                : AppColors.textSecondary,
            size: 24.w,
          ),
        ),
      ],
    );
  }
  
  /// 커스텀 관심사 추가
  void _addCustomInterest(OnboardingController controller, String value) {
    if (value.trim().isNotEmpty && controller.selectedInterests.length < 5) {
      controller.addCustomInterest(value.trim());
      _customInterestController.clear();
    }
  }
  
  /// 설정 미리보기
  Widget _buildSettingsPreview() {
    return Consumer<OnboardingController>(
      builder: (context, controller, child) {
        if (controller.selectedDepartment == null && 
            controller.selectedInterests.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.brandCrimsonLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.preview,
                    size: 20.w,
                    color: AppColors.brandCrimson,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '설정 미리보기',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brandCrimson,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              if (controller.selectedDepartment != null) ...[
                _buildPreviewItem(
                  '학과',
                  controller.selectedDepartment!.name,
                ),
                SizedBox(height: 8.h),
              ],
              
              if (controller.selectedInterests.isNotEmpty) ...[
                _buildPreviewItem(
                  '관심사',
                  controller.selectedInterests.join(', '),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  
  /// 미리보기 아이템
  Widget _buildPreviewItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.brandCrimson,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}