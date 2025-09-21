import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../onboarding/data/models/interest.dart';
import '../../../../onboarding/presentation/controllers/personalization_controller.dart';

/// Toss-Style 관심사 다중 선택 위젯
/// 카테고리별 관심사를 선택하고 최대 5개까지 제한하는 시스템
class InterestTags extends ConsumerStatefulWidget {
  const InterestTags({super.key});

  @override
  ConsumerState<InterestTags> createState() => _InterestTagsState();
}

class _InterestTagsState extends ConsumerState<InterestTags>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _selectedController;
  late AnimationController _categoriesController;

  InterestCategory _selectedCategory = InterestCategory.career;

  // Timer들을 관리해서 dispose 시 취소 가능하게 만들기
  Timer? _headerTimer;
  Timer? _selectedTimer;
  Timer? _categoriesTimer;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _selectedController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _categoriesController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() {
    // Timer 기반으로 변경해서 dispose 시 취소 가능하게 만들기
    _headerTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) {
        _headerController.forward();
      }
    });

    _selectedTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        _selectedController.forward();
      }
    });

    _categoriesTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        _categoriesController.forward();
      }
    });
  }

  @override
  void dispose() {
    // Timer들 먼저 취소해서 dispose 후 콜백 실행 방지
    _headerTimer?.cancel();
    _selectedTimer?.cancel();
    _categoriesTimer?.cancel();

    _headerController.dispose();
    _selectedController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalizationState = ref.watch(personalizationControllerProvider);
    final controller = ref.read(personalizationControllerProvider.notifier);

    // 🧮 선택된 관심사 영역 상태만 확인 (높이 계산은 Flexible이 알아서!)
    final hasSelectedInterests = personalizationState.selectedInterests.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea( // 🛡️ SafeArea로 시스템 UI 영역 피하기
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h), // 🛡️ 더 충분한 하단 패딩
              child: Column(
                mainAxisSize: MainAxisSize.min, // 🔧 RenderFlex 에러 해결!
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎯 헤더 섹션
                  _buildHeader(personalizationState.selectedInterests.length),

                  SizedBox(height: 20.h),

                  // 🎁 선택된 관심사 영역 (안전한 애니메이션!)
                  if (hasSelectedInterests)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: 1.0,
                      child: _buildSelectedInterests(personalizationState, controller),
                    ),

                  if (hasSelectedInterests) SizedBox(height: 24.h),

                  // 📱 카테고리 탭
                  _buildCategoryTabs(),

                  SizedBox(height: 20.h),

                  // 🏷️ 관심사 태그 목록 (shrinkWrap으로 높이 자동 조절!)
                  _buildInterestList(personalizationState, controller),

                  SizedBox(height: 20.h), // 하단 여백 (패딩과 함께)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🎯 헤더 섹션
  Widget _buildHeader(int selectedCount) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 🔧 RenderFlex 에러 해결!
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "관심사를 선택해주세요",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            // 선택 개수 표시
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // 패딩 증가
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selectedCount >= 5
                      ? [
                          const Color(0xFFDC143C),
                          const Color(0xFFB0102F),
                        ]
                      : [
                          const Color(0xFF10B981),
                          const Color(0xFF059669),
                        ],
                ),
                borderRadius: BorderRadius.circular(25.r), // 20.r → 25.r로 더 둥글게
                boxShadow: [
                  BoxShadow(
                    color: (selectedCount >= 5
                            ? const Color(0xFFDC143C)
                            : const Color(0xFF10B981))
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedCount >= 5 ? Icons.check_circle_rounded : Icons.favorite_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "$selectedCount/5",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700, // w600 → w700로 강화
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            .animate(controller: _headerController)
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.3, duration: 600.ms, curve: Curves.easeOutCubic),

        SizedBox(height: 8.h),

        Text(
          "최대 5개까지 선택할 수 있어요. 맞춤 정보 추천에 활용됩니다.",
          style: TextStyle(
            fontSize: 16.sp,
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        )
            .animate(controller: _headerController)
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideX(begin: -0.3, delay: 200.ms, duration: 600.ms, curve: Curves.easeOutCubic),

        SizedBox(height: 16.h),

        // 🎯 빠른 선택 버튼들
        Row(
          children: [
            _buildQuickSelectButton(
              text: "추천 관심사",
              icon: Icons.auto_awesome,
              color: const Color(0xFF8B5CF6),
              onTap: () {
                final controller = ref.read(personalizationControllerProvider.notifier);
                // 추천 관심사 선택
                final recommended = InterestData.getRecommendedInterests();
                for (final interest in recommended) {
                  if (!ref.read(personalizationControllerProvider).selectedInterests.contains(interest)) {
                    controller.toggleInterest(interest);
                  }
                }
              },
            ),
            SizedBox(width: 12.w),
            _buildQuickSelectButton(
              text: "모두 지우기",
              icon: Icons.clear_all,
              color: const Color(0xFF6B7280),
              onTap: () {
                final controller = ref.read(personalizationControllerProvider.notifier);
                final state = ref.read(personalizationControllerProvider);
                for (final interest in state.selectedInterests) {
                  controller.toggleInterest(interest);
                }
              },
            ),
          ],
        )
            .animate(controller: _headerController)
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, delay: 400.ms, duration: 600.ms, curve: Curves.easeOutCubic),
      ],
    );
  }

  Widget _buildQuickSelectButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h), // 패딩 증가
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12), // 0.1 → 0.12로 약간 진하게
          borderRadius: BorderRadius.circular(25.r), // 20.r → 25.r로 더 둥글게
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5), // 보더 진하게
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 14.sp), // 16.sp → 14.sp로 약간 축소
            ),
            SizedBox(width: 8.w), // 6.w → 8.w로 증가
            Text(
              text,
              style: TextStyle(
                fontSize: 13.sp, // 14.sp → 13.sp로 약간 축소
                fontWeight: FontWeight.w700, // w600 → w700로 강화
                color: color,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎁 선택된 관심사 영역
  Widget _buildSelectedInterests(PersonalizationState state, PersonalizationController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFDC143C).withValues(alpha: 0.05),
            const Color(0xFFDC143C).withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFDC143C).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔧 RenderFlex 에러 해결!
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "선택한 관심사",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFDC143C),
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: state.selectedInterests.asMap().entries.map((entry) {
              final index = entry.key;
              final interest = entry.value;
              return _buildSelectedTag(interest, controller, index);
            }).toList(),
          ),
        ],
      ),
    )
        .animate(controller: _selectedController)
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, duration: 600.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildSelectedTag(Interest interest, PersonalizationController controller, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h), // 패딩 증가
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFDC143C),
            const Color(0xFFB0102F), // 더 진한 크림슨
          ],
        ),
        borderRadius: BorderRadius.circular(25.r), // 20.r → 25.r로 더 둥글게
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.3), // 그림자 진하게
            blurRadius: 12, // 8 → 12로 증가
            offset: const Offset(0, 3), // 2 → 3으로 증가
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              interest.emoji,
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 10.w), // 6.w → 10.w로 증가
          Text(
            interest.name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700, // w600 → w700로 강화
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(width: 10.w), // 6.w → 10.w로 증가
          GestureDetector(
            onTap: () => controller.toggleInterest(interest),
            child: Container(
              padding: EdgeInsets.all(4.w), // 2.w → 4.w로 증가
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.close_rounded, // close → close_rounded로 변경
                color: Colors.white,
                size: 14.sp, // 12.sp → 14.sp로 증가
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          duration: 300.ms,
          delay: (index * 100).ms,
          curve: Curves.elasticOut,
        );
  }

  /// 📱 카테고리 탭
  Widget _buildCategoryTabs() {
    return Container(
      height: 95.h, // 90.h → 95.h로 약간 증가
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        itemCount: InterestCategory.values.length,
        itemBuilder: (context, index) {
          final category = InterestCategory.values[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(right: 10.w), // 12.w → 10.w로 축소
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350), // 300 → 350ms로 증가
                curve: Curves.easeOutCubic, // 안전한 곡선
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h), // 패딩 조정
                decoration: BoxDecoration(
                  color: isSelected ? category.color : Colors.white,
                  borderRadius: BorderRadius.circular(16.r), // 20.r → 16.r로 축소
                  border: Border.all(
                    color: category.color,
                    width: isSelected ? 2.5 : 1.5, // 보더 두께 증가
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: category.color.withValues(alpha: 0.4), // 그림자 진하게
                            blurRadius: 10, // 8 → 10으로 증가
                            offset: const Offset(0, 3), // 2 → 3으로 증가
                            spreadRadius: 1,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        category.icon,
                        color: isSelected ? Colors.white : category.color,
                        size: 20.sp, // 24.sp → 20.sp로 축소
                      ),
                    ),
                    SizedBox(height: 4.h), // 6.h → 4.h로 축소
                    Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: 11.sp, // 12.sp → 11.sp로 축소
                        fontWeight: FontWeight.w700, // w600 → w700로 강화
                        color: isSelected ? Colors.white : category.color,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    )
        .animate(controller: _categoriesController)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOutCubic);
  }

  /// 🏷️ 관심사 태그 목록
  Widget _buildInterestList(PersonalizationState state, PersonalizationController controller) {
    final interests = InterestData.getInterestsByCategory(_selectedCategory);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _selectedCategory.color.withValues(alpha: 0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _selectedCategory.color.withValues(alpha: 0.02),
            _selectedCategory.color.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: GridView.builder(
          shrinkWrap: true, // 🔧 핵심 수정: Scrollable 충돌 방지!
          physics: const NeverScrollableScrollPhysics(), // 🔧 스크롤 비활성화 (상위 SingleChildScrollView 사용)
          padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 30.w), // 하단 패딩 더 증가
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14.w, // 간격 증가
            mainAxisSpacing: 14.h,
            childAspectRatio: 3.0, // 🔧 2.6 → 3.0으로 늘려서 overflow 해결
          ),
          itemCount: interests.length,
          itemBuilder: (context, index) {
            final interest = interests[index];
            final isSelected = state.selectedInterests.contains(interest);
            final canSelect = state.selectedInterests.length < 5 || isSelected;

            // 🔧 안전한 기본 애니메이션으로 변경
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 50)), // 스태거 효과
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value), // 0.8에서 1.0으로 스케일
                  child: Opacity(
                    opacity: value,
                    child: _buildInterestTag(interest, isSelected, canSelect, controller),
                  ),
                );
              },
            );
          },
        ),
    );
  }

  Widget _buildInterestTag(
    Interest interest,
    bool isSelected,
    bool canSelect,
    PersonalizationController controller,
  ) {
    return GestureDetector(
      onTap: canSelect ? () => controller.toggleInterest(interest) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350), // 300 → 350ms로 약간 증가
        curve: Curves.easeOutCubic, // 안전한 곡선!
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h), // 🔧 vertical 패딩 줄여서 overflow 해결
        decoration: BoxDecoration(
          color: isSelected
              ? interest.category.color
              : (canSelect ? Colors.white : Colors.grey[50]),
          borderRadius: BorderRadius.circular(18.r), // 16.r → 18.r로 둥글게
          border: Border.all(
            color: isSelected
                ? interest.category.color
                : (canSelect ? interest.category.color.withValues(alpha: 0.4) : Colors.grey[300]!),
            width: isSelected ? 2.5 : 1.5, // 보더 두께 증가
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: interest.category.color.withValues(alpha: 0.4), // 그림자 진하게
                    blurRadius: 12, // 8 → 12로 증가
                    offset: const Offset(0, 3), // 2 → 3으로 증가
                    spreadRadius: 1,
                  ),
                ]
              : [
                  // 선택되지 않은 경우에도 미묘한 그림자 추가
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : interest.category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                interest.emoji,
                style: TextStyle(
                  fontSize: isSelected ? 20.sp : 18.sp, // 크기 증가
                ),
              ),
            ),
            SizedBox(width: 10.w), // 8.w → 10.w로 증가
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    interest.name,
                    style: TextStyle(
                      fontSize: isSelected ? 15.sp : 14.sp, // 선택 시 크기 증가
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (canSelect ? const Color(0xFF1F2937) : Colors.grey[500]),
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (isSelected) // 선택 시 추가 텍스트
                    Text(
                      "선택됨",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}