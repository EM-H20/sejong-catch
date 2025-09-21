import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../onboarding/data/models/major.dart';
import '../../../../onboarding/presentation/controllers/personalization_controller.dart';

/// Toss-Style 인터랙티브 학과 선택 위젯
/// 검색, 카테고리 필터, 애니메이션이 포함된 학과 선택 시스템
class MajorSelector extends ConsumerStatefulWidget {
  const MajorSelector({super.key});

  @override
  ConsumerState<MajorSelector> createState() => _MajorSelectorState();
}

class _MajorSelectorState extends ConsumerState<MajorSelector>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;

  final TextEditingController _searchController = TextEditingController();
  MajorCategory? _selectedCategory;
  List<Major> _filteredMajors = MajorData.allMajors;

  // Timer들을 관리해서 dispose 시 취소 가능하게 만들기
  Timer? _headerTimer;
  Timer? _listTimer;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _searchController.addListener(_filterMajors);
    _startAnimations();
  }

  void _startAnimations() {
    // Timer 기반으로 변경해서 dispose 시 취소 가능하게 만들기
    _headerTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _headerController.forward();
      }
    });

    _listTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _listController.forward();
      }
    });
  }

  void _filterMajors() {
    String query = _searchController.text;
    List<Major> majors = MajorData.allMajors;

    // 카테고리 필터 적용
    if (_selectedCategory != null) {
      majors = majors
          .where((major) => major.category == _selectedCategory)
          .toList();
    }

    // 검색어 필터 적용
    if (query.isNotEmpty) {
      majors = MajorData.searchMajors(query);
      if (_selectedCategory != null) {
        majors = majors
            .where((major) => major.category == _selectedCategory)
            .toList();
      }
    }

    setState(() {
      _filteredMajors = majors;
    });
  }

  @override
  void dispose() {
    // Timer들 먼저 취소해서 dispose 후 콜백 실행 방지
    _headerTimer?.cancel();
    _listTimer?.cancel();

    _headerController.dispose();
    _listController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalizationState = ref.watch(personalizationControllerProvider);
    final controller = ref.read(personalizationControllerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min, // 🔧 RenderFlex 에러 해결!
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🎯 헤더 섹션
        _buildHeader(),

        SizedBox(height: 24.h),

        // 🔍 검색바
        _buildSearchBar(),

        SizedBox(height: 20.h),

        // 📱 카테고리 필터
        _buildCategoryFilter(),

        SizedBox(height: 24.h),

        // 📋 학과 목록
        Expanded(child: _buildMajorList(personalizationState, controller)),
      ],
    );
  }

  /// 🎯 헤더 섹션
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              "학과를 선택해주세요",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            )
            .animate(controller: _headerController)
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.3, duration: 600.ms, curve: Curves.easeOutCubic),

        SizedBox(height: 8.h),

        Text(
              "맞춤 정보 추천을 위해 소속 학과를 알려주세요",
              style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
            )
            .animate(controller: _headerController)
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(
              begin: -0.3,
              delay: 200.ms,
              duration: 600.ms,
              curve: Curves.easeOutCubic,
            ),
      ],
    );
  }

  /// 🔍 검색바
  Widget _buildSearchBar() {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDC143C).withValues(alpha: .1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "학과명을 입력하세요 (예: 컴퓨터, 경영, 디자인)",
              hintStyle: TextStyle(
                color: const Color(0xFF9CA3AF),
                fontSize: 16.sp,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: const Color(0xFFDC143C),
                size: 24.sp,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: const Color(0xFF9CA3AF),
                        size: 20.sp,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: const Color(0xFFE5E7EB),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: const Color(0xFFDC143C),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: const Color(0xFFE5E7EB),
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
            ),
            style: TextStyle(fontSize: 16.sp, color: const Color(0xFF1F2937)),
          ),
        )
        .animate(controller: _headerController)
        .fadeIn(delay: 400.ms, duration: 600.ms)
        .slideY(
          begin: 0.3,
          delay: 400.ms,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  /// 📱 카테고리 필터
  Widget _buildCategoryFilter() {
    return SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: MajorCategory.values.length + 1, // +1 for "전체" option
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryChip(
                  category: null,
                  isSelected: _selectedCategory == null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                    _filterMajors();
                  },
                );
              }

              final category = MajorCategory.values[index - 1];
              return _buildCategoryChip(
                category: category,
                isSelected: _selectedCategory == category,
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterMajors();
                },
              );
            },
          ),
        )
        .animate(controller: _headerController)
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(
          begin: 0.3,
          delay: 600.ms,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildCategoryChip({
    required MajorCategory? category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isAll = category == null;
    final displayName = isAll ? "전체" : category.displayName;
    final icon = isAll ? Icons.apps : category.icon;
    final color = isAll ? const Color(0xFF6B7280) : category.color;

    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? color : color.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 20.sp),
              SizedBox(height: 4.h),
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📋 학과 목록
  Widget _buildMajorList(
    PersonalizationState state,
    PersonalizationController controller,
  ) {
    if (_filteredMajors.isEmpty) {
      return _buildEmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: _filteredMajors.length,
        itemBuilder: (context, index) {
          final major = _filteredMajors[index];
          final isSelected = state.selectedMajor?.id == major.id;

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 600),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildMajorCard(major, isSelected, controller),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMajorCard(
    Major major,
    bool isSelected,
    PersonalizationController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.selectMajor(major),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFDC143C).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFDC143C)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFDC143C).withValues(alpha: 0.1)
                  : const Color(0xFF000000).withValues(alpha: 0.02),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 학과 아이콘
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: major.category.color.withValues(alpha: isSelected ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                major.icon,
                color: isSelected
                    ? const Color(0xFFDC143C)
                    : major.category.color,
                size: 28.sp,
              ),
            ),

            SizedBox(width: 16.w),

            // 학과 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    major.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFFDC143C)
                          : const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    major.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // 선택 표시
            if (isSelected)
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC143C),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16.sp),
              ).animate().scale(
                begin: const Offset(0, 0),
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 16.h),
          Text(
            "검색 결과가 없어요",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "다른 키워드로 검색해보세요",
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}