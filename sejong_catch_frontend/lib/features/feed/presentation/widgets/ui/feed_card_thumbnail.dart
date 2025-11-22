import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/widgets/badges/app_badge.dart';

/// 🖼️ 피드 카드 썸네일 위젯
///
/// 기능:
/// - 썸네일 이미지 표시 (현재는 플레이스홀더)
/// - 카테고리 배지 오버레이
class FeedCardThumbnail extends StatelessWidget {
  /// 썸네일 이미지 URL (선택사항)
  final String? thumbnailUrl;

  /// 카테고리 (배지 색상 결정)
  final String category;

  const FeedCardThumbnail({
    super.key,
    this.thumbnailUrl,
    required this.category,
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
        ],
      ),
    );
  }
}
