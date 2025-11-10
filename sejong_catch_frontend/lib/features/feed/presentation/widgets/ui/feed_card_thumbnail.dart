import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/widgets/badges/app_badge.dart';

/// 🖼️ 피드 카드 썸네일 위젯
///
/// 기능:
/// - 썸네일 이미지 표시 (현재는 플레이스홀더)
/// - 카테고리 배지 오버레이
/// - 북마크 버튼 오버레이
class FeedCardThumbnail extends StatelessWidget {
  /// 썸네일 이미지 URL (선택사항)
  final String? thumbnailUrl;

  /// 카테고리 (배지 색상 결정)
  final String category;

  /// 북마크 여부
  final bool isBookmarked;

  /// 북마크 토글 콜백
  final VoidCallback onBookmarkToggle;

  const FeedCardThumbnail({
    super.key,
    this.thumbnailUrl,
    required this.category,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.feedThumbnailHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Stack(
        children: [
          // 썸네일 플레이스홀더
          Center(
            child: Icon(
              Icons.image_outlined,
              size: 48.sp,
              color: AppColors.disabled,
            ),
          ),

          // 카테고리 배지 (왼쪽 상단)
          Positioned(
            top: AppSpacing.thumbnailElementSpacing,
            left: AppSpacing.thumbnailElementSpacing,
            child: AppBadge.category(category: category),
          ),

          // 북마크 버튼 (오른쪽 상단)
          Positioned(
            top: AppSpacing.thumbnailElementSpacing,
            right: AppSpacing.thumbnailElementSpacing,
            child: _BookmarkButton(
              isBookmarked: isBookmarked,
              onToggle: onBookmarkToggle,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔖 북마크 버튼 (내부 위젯)
class _BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onToggle;

  const _BookmarkButton({
    required this.isBookmarked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint('🔖 [BookmarkButton] 북마크 버튼 클릭!');
        onToggle();
        debugPrint('✅ [BookmarkButton] onToggle() 호출 완료!');
      },
      behavior: HitTestBehavior.opaque, // 북마크 버튼 영역만 감지
      child: Container(
        padding: AppSpacing.bookmarkButtonPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: AppShadows.basic,
        ),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          size: 20.sp,
          color: AppColors.brandCrimson,
        ),
      ),
    );
  }
}
