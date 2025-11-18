import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_shadows.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';
import 'package:sejong_catch_frontend/core/widgets/chips/app_chip.dart';
import 'package:sejong_catch_frontend/core/widgets/badges/app_badge.dart';
import 'package:sejong_catch_frontend/features/feed/data/models/response/feed_item.dart';

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
  late FeedItem _feedItem;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // TODO: 실제로는 Provider에서 ID로 데이터 조회
    // 현재는 더미 데이터 사용
    _feedItem = _getDummyData(widget.id);
    _isBookmarked = _feedItem.isBookmarked;
  }

  /// 더미 데이터 생성 (ID 기반)
  FeedItem _getDummyData(String id) {
    // feed_page.dart의 더미 데이터와 매칭
    final dummyMap = {
      '1': FeedItem.dummy(
        id: '1',
        title: '2024 캡스톤 디자인 경진대회',
        description: '우수작 선정 시 상금 300만원 + 창업 지원',
        category: '공모전',
        dDay: 7,
        priority: 'high',
      ),
      '2': FeedItem.dummy(
        id: '2',
        title: '네이버 클라우드 신입 채용',
        description: '백엔드 개발자 채용 (~25.12.31)',
        category: '취업',
        dDay: 23,
        priority: 'mid',
      ),
      '3': FeedItem.dummy(
        id: '3',
        title: '한국정보과학회 논문 공모',
        description: 'AI/빅데이터 분야 우수 논문 모집',
        category: '논문',
        dDay: 15,
        priority: 'mid',
      ),
      '4': FeedItem.dummy(
        id: '4',
        title: '[학교공지] 2025-1학기 수강신청 안내',
        description: '수강신청 기간: 2025.02.10 ~ 02.14',
        category: '학교공지',
        dDay: 45,
        priority: 'high',
      ),
      '5': FeedItem.dummy(
        id: '5',
        title: '세종대 대동제 부스 모집',
        description: '대동제 축제 부스 운영 팀 모집 중!',
        category: '축제',
        dDay: 30,
        priority: 'low',
      ),
    };

    return dummyMap[id] ??
        FeedItem.dummy(
          id: id,
          title: '알 수 없는 피드',
          description: '상세 정보를 찾을 수 없습니다.',
          category: '기타',
          dDay: 0,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = _feedItem.dDay <= 7;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // 🔝 앱바 (뒤로가기, 공유, 북마크)
          _buildAppBar(context),

          // 📰 본문 컨텐츠
          SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📷 썸네일 이미지 (선택사항)
                    if (_feedItem.thumbnailUrl != null) ...[
                      _buildThumbnail(),
                      AppSpacing.verticalSpaceLG,
                    ],

                    // 🏷️ 카테고리 배지
                    AppBadge.category(category: _feedItem.category),

                    AppSpacing.verticalSpaceMD,

                    // 📝 제목
                    Text(_feedItem.title, style: AppTextStyles.headingBold24),

                    AppSpacing.verticalSpaceSM,

                    // 📅 정보 칩 (D-Day, 조회수)
                    Row(
                      children: [
                        AppChip.dDay(
                          daysLeft: _feedItem.dDay,
                          isUrgent: isUrgent,
                        ),
                        AppSpacing.horizontalSpaceSM,
                        AppChip.viewCount(count: _feedItem.viewCount),
                        AppSpacing.horizontalSpaceSM,
                        if (_feedItem.priority != 'low')
                          AppBadge.priority(priority: _feedItem.priority),
                      ],
                    ),

                    AppSpacing.verticalSpace(56),

                    // 구분선
                    AppDivider.medium(),

                    AppSpacing.verticalSpace(40),

                    // 📋 기본 정보
                    _buildInfoSection(),

                    AppSpacing.verticalSpace(40),

                    // 📄 본문 내용
                    _buildContentSection(),

                    AppSpacing.verticalSpace(72),

                    // 🔗 액션 버튼
                    _buildActionButtons(context),

                    AppSpacing.verticalSpaceXXL,
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔝 앱바
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: 24.sp),
        color: AppColors.textPrimary,
        onPressed: () => context.pop(),
      ),
      actions: [
        // 공유 버튼
        IconButton(
          icon: Icon(Icons.share_outlined, size: 24.sp),
          color: AppColors.textSecondary,
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('공유 기능 준비 중! 📤')));
          },
        ),
        // 북마크 버튼
        IconButton(
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 24.sp,
          ),
          color: AppColors.brandCrimson,
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isBookmarked ? '북마크 추가됨! 🔖' : '북마크 제거됨'),
                duration: const Duration(seconds: 1),
              ),
            );
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
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('기본 정보', style: AppTextStyles.headingSemiBold20),
        AppSpacing.verticalSpaceMD,
        _buildInfoRow(
          icon: Icons.business_outlined,
          label: '주최',
          value: _feedItem.organizerName ?? '세종대학교',
        ),
        AppSpacing.verticalSpaceSM,
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          label: '마감일',
          value: _feedItem.deadline != null
              ? '${_feedItem.deadline!.year}.${_feedItem.deadline!.month.toString().padLeft(2, '0')}.${_feedItem.deadline!.day.toString().padLeft(2, '0')}'
              : 'D-${_feedItem.dDay}',
        ),
        AppSpacing.verticalSpaceSM,
        _buildInfoRow(
          icon: Icons.email_outlined,
          label: '문의',
          value: _feedItem.contactEmail ?? 'sejong@example.com',
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
          style: AppTextStyles.bodyRegular14.copyWith(fontWeight: FontWeight.w500),
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
  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상세 내용', style: AppTextStyles.headingSemiBold20),
        AppSpacing.verticalSpaceMD,
        Text(
          _feedItem.content ?? _feedItem.description,
          style: AppTextStyles.bodySemiBold16.copyWith(
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// 🔗 액션 버튼
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 외부 링크 버튼
        if (_feedItem.externalUrl != null)
          _buildActionButton(
            icon: Icons.open_in_new,
            label: '공식 사이트 방문',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('외부 링크: ${_feedItem.externalUrl}')),
              );
            },
          ),

        AppSpacing.verticalSpaceMD,

        // 문의하기 버튼
        _buildActionButton(
          icon: Icons.email_outlined,
          label: '문의하기',
          color: AppColors.brandCrimson,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('문의: ${_feedItem.contactEmail}')),
            );
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
              style: AppTextStyles.buttonSemiBold16.copyWith(color: buttonColor),
            ),
          ],
        ),
      ),
    );
  }
}
