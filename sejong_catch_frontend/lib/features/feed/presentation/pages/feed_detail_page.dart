import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';
import 'package:sejong_catch_frontend/core/widgets/chips/app_chip.dart';
import 'package:sejong_catch_frontend/core/widgets/badges/app_badge.dart';
import 'package:sejong_catch_frontend/core/widgets/loading_widget.dart';
import 'package:sejong_catch_frontend/features/feed/data/models/response/feed_item.dart';
import 'package:sejong_catch_frontend/features/feed/data/repositories/feed_repository.dart';

/// 📄 피드 상세보기 페이지
///
/// CLAUDE.md 원칙:
/// - 공용 위젯 (AppChip, AppBadge) 활용
/// - 디자인 토큰 100% 사용
/// - ScreenUtil 100% 적용
/// - DRY 원칙 준수
class FeedDetailPage extends ConsumerStatefulWidget {
  /// 피드 아이템 ID
  final String id;

  const FeedDetailPage({super.key, required this.id});

  @override
  ConsumerState<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends ConsumerState<FeedDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: FutureBuilder<FeedItem>(
        future: ref
            .read(feedRepositoryProvider.notifier)
            .getFeedDetail(widget.id),
        builder: (context, snapshot) {
          // 로딩 중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: '피드를 불러오는 중...');
          }

          // 에러 발생
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: AppColors.error,
                  ),
                  AppSpacing.verticalSpaceLG,
                  Text(
                    '데이터를 불러올 수 없어요',
                    style: AppTextStyles.headingSemiBold20,
                  ),
                  AppSpacing.verticalSpaceSM,
                  Text(
                    snapshot.error.toString(),
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.verticalSpaceLG,
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          // 데이터 없음
          final feedItem = snapshot.data;
          if (feedItem == null) {
            return Center(
              child: Text(
                '피드를 찾을 수 없어요',
                style: AppTextStyles.headingSemiBold20,
              ),
            );
          }

          return _buildContent(context, feedItem);
        },
      ),
    );
  }

  /// 📰 본문 컨텐츠
  Widget _buildContent(BuildContext context, FeedItem feedItem) {
    final isUrgent = feedItem.dDay <= 7; // 7일 이내 게시글은 최신으로 강조

    return CustomScrollView(
      slivers: [
        // 🔝 앱바 (뒤로가기, 공유, 북마크)
        _buildAppBar(context, feedItem),

        // 📰 본문 컨텐츠
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📷 썸네일 이미지 (선택사항)
                  if (feedItem.thumbnailUrl != null) ...[
                    _buildThumbnail(),
                    AppSpacing.verticalSpaceLG,
                  ],

                  // 🏷️ 카테고리 배지
                  AppBadge.category(category: feedItem.category),

                  AppSpacing.verticalSpaceMD,

                  // 📝 제목
                  Text(feedItem.title, style: AppTextStyles.headingBold24),

                  AppSpacing.verticalSpaceSM,

                  // 📅 정보 칩 (D-Day, 조회수)
                  Row(
                    children: [
                      AppChip.dDay(daysLeft: feedItem.dDay, isUrgent: isUrgent),
                      AppSpacing.horizontalSpaceSM,
                      AppChip.viewCount(count: feedItem.viewCount),
                      AppSpacing.horizontalSpaceSM,
                      if (feedItem.priority != 'low')
                        AppBadge.priority(priority: feedItem.priority),
                    ],
                  ),

                  AppSpacing.verticalSpace(56),

                  // 구분선
                  AppDivider.medium(),

                  AppSpacing.verticalSpace(40),

                  // 📋 기본 정보
                  _buildInfoSection(feedItem),

                  AppSpacing.verticalSpace(40),

                  // 📄 본문 내용 (크롤러 모드에서는 표시 안 함)
                  if (feedItem.content != null &&
                      feedItem.content!.isNotEmpty) ...[
                    _buildContentSection(feedItem),
                    AppSpacing.verticalSpace(40),
                  ],

                  AppSpacing.verticalSpace(32),

                  // 🔗 액션 버튼
                  _buildActionButtons(context, feedItem),

                  AppSpacing.verticalSpaceXXL,
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  /// 🔝 앱바
  Widget _buildAppBar(BuildContext context, FeedItem feedItem) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp),
        color: AppColors.textPrimary,
        onPressed: () => context.pop(),
      ),
      actions: [
        // 공유 버튼
        IconButton(
          icon: Icon(Icons.share_outlined, size: 24.sp),
          color: AppColors.textSecondary,
          onPressed: () async {
            final shareText =
                '''
${feedItem.title}

${feedItem.description}

🔗 ${feedItem.externalUrl ?? '세종대학교 공지사항'}
''';

            try {
              // share_plus 패키지 사용 (SharePlus.instance.share 권장)
              await SharePlus.instance.share(
                ShareParams(text: shareText, subject: feedItem.title),
              );
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('공유하기에 실패했어요: ${e.toString()}'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          },
        ),
        AppSpacing.horizontalSpaceSM,
      ],
    );
  }

  /// 📷 썸네일 이미지
  Widget _buildThumbnail() {
    return Container(
      height: 240.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.basic,
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64.sp,
          color: AppColors.disabled,
        ),
      ),
    );
  }

  /// 📋 기본 정보 섹션
  Widget _buildInfoSection(FeedItem feedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('기본 정보', style: AppTextStyles.headingSemiBold20),
        AppSpacing.verticalSpaceMD,
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          label: '게시일',
          value: feedItem.createdAt != null
              ? '${feedItem.createdAt!.year}.${feedItem.createdAt!.month.toString().padLeft(2, '0')}.${feedItem.createdAt!.day.toString().padLeft(2, '0')}'
              : '알 수 없음',
        ),
        AppSpacing.verticalSpaceSM,
        _buildInfoRow(
          icon: Icons.remove_red_eye_outlined,
          label: '조회수',
          value: '${feedItem.viewCount}회',
        ),
      ],
    );
  }

  /// 📋 정보 행 (아이콘 + 라벨 + 값)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textSecondary),
        AppSpacing.horizontalSpaceSM,
        Text(
          '$label:',
          style: AppTextStyles.bodyRegular14.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.horizontalSpaceSM,
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// 📄 본문 내용 섹션
  Widget _buildContentSection(FeedItem feedItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상세 내용', style: AppTextStyles.headingSemiBold20),
        AppSpacing.verticalSpaceMD,
        Text(
          feedItem.content ?? feedItem.description,
          style: AppTextStyles.bodySemiBold16.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// 🔗 액션 버튼
  Widget _buildActionButtons(BuildContext context, FeedItem feedItem) {
    return Column(
      children: [
        // 외부 링크 버튼 (크롤러 데이터의 url 사용)
        if (feedItem.externalUrl != null && feedItem.externalUrl!.isNotEmpty)
          _buildActionButton(
            icon: Icons.open_in_new,
            label: '세종대 공지 원문 보기',
            color: AppColors.brandCrimson,
            onPressed: () async {
              final url = Uri.parse(feedItem.externalUrl!);

              // URL을 열 수 있는지 확인
              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication, // 외부 브라우저로 열기
                );
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('링크를 열 수 없어요\n${feedItem.externalUrl}'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
          ),
      ],
    );
  }

  /// 버튼 위젯
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    final buttonColor = color ?? AppColors.textSecondary;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: AppSpacing.buttonPadding,
        decoration: BoxDecoration(
          color: buttonColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: buttonColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.sp, color: buttonColor),
            AppSpacing.horizontalSpaceSM,
            Text(
              label,
              style: AppTextStyles.buttonSemiBold16.copyWith(
                color: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
