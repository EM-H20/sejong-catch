import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/feed_category.dart';
import '../../controllers/feed_controller.dart';

/// 🏷️ 스마트 카테고리 필터 바
///
/// 치킨집 메뉴판보다 직관적이고 BTS처럼 완벽한 하모니를 이루는 필터!
/// 사용자 친화적 기능:
/// - 부드러운 SlideTransition 애니메이션
/// - 선택된 카테고리 크림슨 하이라이트
/// - 뱃지로 새 항목 수 표시
/// - 햅틱 피드백
/// - 접근성 완벽 지원
class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);
    final feedController = ref.read(feedControllerProvider.notifier);
    final categoryItemCounts = feedState.categoryItemCounts;

    return Container(
      height: 56.h,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // iOS급 부드러운 스크롤
        itemCount: FeedCategory.values.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final category = FeedCategory.values[index];
          final isSelected = feedState.selectedCategory == category;
          final itemCount = categoryItemCounts[category] ?? 0;

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: _CategoryChip(
              category: category,
              isSelected: isSelected,
              itemCount: itemCount,
              onTap: () => _onCategoryTap(feedController, category, isSelected),
            ),
          );
        },
      ),
    );
  }

  /// 카테고리 탭 처리 - 사용자 친화적 피드백 포함
  void _onCategoryTap(
    FeedController controller,
    FeedCategory category,
    bool isCurrentlySelected,
  ) {
    if (isCurrentlySelected) return; // 이미 선택된 카테고리는 무시

    // 햅틱 피드백 - 카테고리 전환 시 미세한 진동
    HapticFeedback.selectionClick();

    // 카테고리 변경
    controller.changeCategory(category);
  }
}

/// 개별 카테고리 칩 위젯
class _CategoryChip extends StatefulWidget {
  final FeedCategory category;
  final bool isSelected;
  final int itemCount;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.itemCount,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.category.displayName} 카테고리',
      hint: widget.itemCount > 0
          ? '${widget.itemCount}개의 새로운 정보가 있습니다. 탭하여 확인하세요'
          : '탭하여 카테고리를 변경하세요',
      button: true,
      selected: widget.isSelected,
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildChipContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChipContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5.w,
        ),
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color: AppColors.brandCrimson.withValues(alpha: 0.2),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 카테고리 아이콘
          Icon(
            _getCategoryIcon(),
            size: 18.w,
            color: _getContentColor(),
          ),

          SizedBox(width: 6.w),

          // 카테고리 이름
          Text(
            widget.category.displayName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: _getContentColor(),
            ),
          ),

          // 아이템 수 배지 (새로운 항목이 있을 때만)
          if (widget.itemCount > 0 && !widget.isSelected) ...[
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.brandCrimson,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                widget.itemCount > 99 ? '99+' : widget.itemCount.toString(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 카테고리별 아이콘 반환
  IconData _getCategoryIcon() {
    switch (widget.category) {
      case FeedCategory.contest:
        return Icons.emoji_events;
      case FeedCategory.job:
        return Icons.work;
      case FeedCategory.paper:
        return Icons.article;
      case FeedCategory.notice:
        return Icons.announcement;
      case FeedCategory.all:
        return Icons.dashboard;
    }
  }

  /// 배경색 계산
  Color _getBackgroundColor() {
    if (widget.isSelected) {
      return AppColors.brandCrimson;
    }
    return Colors.white;
  }

  /// 테두리 색상 계산
  Color _getBorderColor() {
    if (widget.isSelected) {
      return AppColors.brandCrimson;
    }
    return AppColors.textSecondary.withValues(alpha: 0.2);
  }

  /// 콘텐츠 색상 계산
  Color _getContentColor() {
    if (widget.isSelected) {
      return Colors.white;
    }
    return AppColors.textSecondary;
  }
}