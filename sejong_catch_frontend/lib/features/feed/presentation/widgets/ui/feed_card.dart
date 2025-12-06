import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';
import 'package:sejong_catch_frontend/core/widgets/chips/app_chip.dart';
import 'package:sejong_catch_frontend/core/widgets/badges/app_badge.dart';
import 'package:sejong_catch_frontend/features/feed/presentation/widgets/ui/feed_card_thumbnail.dart';

/// 📇 피드 카드 위젯
///
/// 기능:
/// - 썸네일 이미지
/// - 제목, 설명
/// - D-Day, 조회수, 우선순위 정보
/// - 탭 시 상세보기
class FeedCard extends StatelessWidget {
  /// 피드 아이템 데이터 (TODO: 나중에 FeedItem 모델로 변경)
  final Map<String, dynamic> item;

  /// 카드 탭 콜백
  final VoidCallback onTap;

  const FeedCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dDay = item['dDay'] as int;
    final isUrgent = dDay <= 7; // 7일 이내 게시글은 최신으로 강조
    final priority = item['priority'] as String;

    return GestureDetector(
      onTap: () {
        debugPrint('👆 [FeedCard] GestureDetector.onTap 실행! ID: ${item['id']}');
        onTap();
        debugPrint('✅ [FeedCard] onTap() 콜백 호출 완료!');
      },
      behavior: HitTestBehavior.opaque, // 📍 투명한 영역도 클릭 가능하게!
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUrgent
                ? AppColors.brandCrimson.withValues(alpha: 0.3)
                : AppColors.divider,
            width: isUrgent ? 2 : 1,
          ),
          boxShadow: AppShadows.basic,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            FeedCardThumbnail(
              thumbnailUrl: item['thumbnailUrl'] as String?,
              category: item['category'] as String,
            ),

            // 구분선 (썸네일과 내용 사이)
            AppDivider.thin(),

            // 카드 내용
            Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    item['title'] as String,
                    style: AppTextStyles.titleSemiBold16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.verticalSpaceXS,

                  // 설명
                  Text(
                    item['description'] as String,
                    style: AppTextStyles.bodyRegular14,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.verticalSpaceMD,

                  // 구분선 (내용과 하단 정보 사이)
                  AppDivider.thin(),

                  AppSpacing.verticalSpaceMD,

                  // 하단 정보 (D-Day, 조회수, 우선순위)
                  _FeedCardInfo(
                    dDay: dDay,
                    isUrgent: isUrgent,
                    viewCount: item['viewCount'] as int,
                    priority: priority,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ℹ️ 피드 카드 하단 정보 (내부 위젯)
class _FeedCardInfo extends StatelessWidget {
  final int dDay;
  final bool isUrgent;
  final int viewCount;
  final String priority;

  const _FeedCardInfo({
    required this.dDay,
    required this.isUrgent,
    required this.viewCount,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // D-Day 칩
        AppChip.dDay(daysLeft: dDay, isUrgent: isUrgent),

        AppSpacing.horizontalSpaceSM,

        // 조회수 칩
        AppChip.viewCount(count: viewCount),

        AppSpacing.horizontalSpaceSM,

        // 우선순위 배지 (낮음은 제외)
        if (priority != 'low') AppBadge.priority(priority: priority),
      ],
    );
  }
}
