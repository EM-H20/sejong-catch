import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters.dart';

/// 세종 캐치 앱의 표준 정보 카드 위젯
/// 
/// 공모전, 취업, 논문, 공지사항 등 모든 정보를 표시하는
/// 통일된 카드 인터페이스를 제공합니다.
class AppCard extends StatelessWidget {
  /// 카드 제목
  final String title;
  
  /// 카드 부제목 (설명)
  final String? subtitle;
  
  /// 정보 카테고리 (공모전, 취업 등)
  final String? category;
  
  /// 마감일
  final DateTime? deadline;
  
  /// 신뢰도 레벨 (official, academic, press, community)
  final String? trustLevel;
  
  /// 우선순위 레벨 (high, mid, low)
  final String? priority;
  
  /// 출처 로고 URL
  final String? sourceLogoUrl;
  
  /// 출처 도메인명
  final String? sourceDomain;
  
  /// 생성일시
  final DateTime? createdAt;
  
  /// 조회수
  final int? viewCount;
  
  /// 북마크 여부
  final bool isBookmarked;
  
  /// 읽음 여부
  final bool isRead;
  
  /// 만료 여부
  final bool isExpired;
  
  /// 카드 클릭 핸들러
  final VoidCallback? onTap;
  
  /// 북마크 토글 핸들러
  final VoidCallback? onBookmarkTap;
  
  /// 더보기 메뉴 핸들러
  final VoidCallback? onMoreTap;
  
  /// 커스텀 배경색
  final Color? backgroundColor;
  
  /// 카드 엘리베이션
  final double elevation;
  
  /// 카드 마진
  final EdgeInsets? margin;

  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.category,
    this.deadline,
    this.trustLevel,
    this.priority,
    this.sourceLogoUrl,
    this.sourceDomain,
    this.createdAt,
    this.viewCount,
    this.isBookmarked = false,
    this.isRead = false,
    this.isExpired = false,
    this.onTap,
    this.onBookmarkTap,
    this.onMoreTap,
    this.backgroundColor,
    this.elevation = 2,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color: backgroundColor ?? _getCardBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
        elevation: elevation,
        shadowColor: AppColors.shadow.withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 우선순위 바 (상단)
                if (priority != null) _buildPriorityBar(),
                
                // 헤더 (출처 정보 + 북마크)
                _buildHeader(context),
                
                SizedBox(height: 12.h),
                
                // 제목
                _buildTitle(context),
                
                // 부제목
                if (subtitle != null) ...[
                  SizedBox(height: 8.h),
                  _buildSubtitle(context),
                ],
                
                SizedBox(height: 12.h),
                
                // 메타 정보 (카테고리, D-Day, 생성일 등)
                _buildMetaInfo(context),
                
                // 신뢰도 배지 (하단)
                if (trustLevel != null) ...[
                  SizedBox(height: 12.h),
                  _buildTrustBadge(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 카드 배경색 결정
  Color _getCardBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isExpired) {
      return theme.colorScheme.surface.withValues(alpha: 0.6);
    }
    
    if (isRead) {
      return theme.colorScheme.surface;
    }
    
    return theme.colorScheme.surface;
  }
  
  /// 우선순위 바 (카드 상단에 표시되는 색상 바)
  Widget _buildPriorityBar() {
    Color? barColor;
    
    switch (priority?.toLowerCase()) {
      case 'high':
        barColor = AppColors.priorityHigh;
        break;
      case 'mid':
      case 'medium':
        barColor = AppColors.priorityMid;
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      height: 3.h,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
  
  /// 헤더 (출처 로고, 도메인, 신뢰도, 북마크 버튼)
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // 출처 로고
        _buildSourceLogo(),
        
        SizedBox(width: 8.w),
        
        // 출처 도메인
        Expanded(
          child: Text(
            sourceDomain ?? '알 수 없음',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // 액션 버튼들
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 북마크 버튼
            if (onBookmarkTap != null)
              _buildIconButton(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? AppColors.brandCrimson : AppColors.textSecondary,
                onTap: onBookmarkTap!,
              ),
            
            // 더보기 버튼
            if (onMoreTap != null)
              _buildIconButton(
                icon: Icons.more_vert,
                color: AppColors.textSecondary,
                onTap: onMoreTap!,
              ),
          ],
        ),
      ],
    );
  }
  
  /// 출처 로고 (원형 아바타)
  Widget _buildSourceLogo() {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.brandCrimsonLight,
        border: Border.all(
          color: AppColors.brandCrimson.withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: sourceLogoUrl != null
          ? ClipOval(
              child: Image.network(
                sourceLogoUrl!,
                width: 24.w,
                height: 24.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
              ),
            )
          : _buildDefaultLogo(),
    );
  }
  
  /// 기본 로고 (이미지 로드 실패 시)
  Widget _buildDefaultLogo() {
    return Icon(
      _getCategoryIcon(),
      size: 14.w,
      color: AppColors.brandCrimson,
    );
  }
  
  /// 카테고리별 아이콘
  IconData _getCategoryIcon() {
    switch (category?.toLowerCase()) {
      case 'contest':
      case '공모전':
        return Icons.emoji_events;
      case 'job':
      case '취업':
        return Icons.work;
      case 'paper':
      case '논문':
        return Icons.article;
      case 'notice':
      case '공지':
        return Icons.announcement;
      default:
        return Icons.info;
    }
  }
  
  /// 아이콘 버튼 (북마크, 더보기 등)
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Icon(
          icon,
          size: 20.w,
          color: color,
        ),
      ),
    );
  }
  
  /// 제목
  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isExpired 
            ? AppColors.textSecondary 
            : AppColors.textPrimary,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// 부제목
  Widget _buildSubtitle(BuildContext context) {
    return Text(
      subtitle!,
      style: TextStyle(
        fontSize: 14.sp,
        color: isExpired 
            ? AppColors.textSecondary.withValues(alpha: 0.7)
            : AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  /// 메타 정보 (카테고리, D-Day, 생성일, 조회수)
  Widget _buildMetaInfo(BuildContext context) {
    final metaItems = <Widget>[];
    
    // 카테고리
    if (category != null) {
      metaItems.add(_buildMetaItem(
        icon: _getCategoryIcon(),
        text: category!,
        color: AppColors.brandCrimson,
      ));
    }
    
    // D-Day (마감일)
    if (deadline != null) {
      final ddayText = AppFormatters.formatDday(deadline!);
      final ddayStyle = AppFormatters.getDdayStyle(deadline!);
      
      Color ddayColor;
      switch (ddayStyle) {
        case 'expired':
          ddayColor = AppColors.textSecondary;
          break;
        case 'urgent':
          ddayColor = AppColors.error;
          break;
        case 'warning':
          ddayColor = AppColors.warning;
          break;
        default:
          ddayColor = AppColors.textSecondary;
      }
      
      metaItems.add(_buildMetaItem(
        icon: Icons.schedule,
        text: ddayText,
        color: ddayColor,
      ));
    }
    
    // 생성일 (상대적 시간)
    if (createdAt != null) {
      metaItems.add(_buildMetaItem(
        icon: Icons.access_time,
        text: AppFormatters.formatRelativeTime(createdAt!),
        color: AppColors.textSecondary,
      ));
    }
    
    // 조회수
    if (viewCount != null && viewCount! > 0) {
      metaItems.add(_buildMetaItem(
        icon: Icons.visibility,
        text: AppFormatters.formatCompactNumber(viewCount!),
        color: AppColors.textSecondary,
      ));
    }
    
    // 점으로 구분해서 나열
    return Wrap(
      children: _buildSeparatedItems(metaItems, _buildDot()),
    );
  }
  
  /// 메타 정보 아이템 (아이콘 + 텍스트)
  Widget _buildMetaItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.w,
          color: color,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  /// 구분점 (•)
  Widget _buildDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        '•',
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
  
  /// 리스트 아이템들을 구분자로 분리해서 배치
  List<Widget> _buildSeparatedItems(List<Widget> items, Widget separator) {
    final result = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      result.add(items[i]);
      
      // 마지막 아이템이 아니면 구분자 추가
      if (i < items.length - 1) {
        result.add(separator);
      }
    }
    
    return result;
  }
  
  /// 신뢰도 배지
  Widget _buildTrustBadge(BuildContext context) {
    if (trustLevel == null) return const SizedBox.shrink();
    
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;
    
    switch (trustLevel!.toLowerCase()) {
      case 'official':
        badgeColor = AppColors.trustOfficial;
        badgeIcon = Icons.verified;
        badgeText = '공식';
        break;
      case 'academic':
        badgeColor = AppColors.trustAcademic;
        badgeIcon = Icons.school;
        badgeText = '학술';
        break;
      case 'press':
        badgeColor = AppColors.trustPress;
        badgeIcon = Icons.article;
        badgeText = '언론';
        break;
      case 'community':
        badgeColor = AppColors.trustCommunity;
        badgeIcon = Icons.group;
        badgeText = '커뮤니티';
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 12.w,
            color: badgeColor,
          ),
          SizedBox(width: 4.w),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 10.sp,
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}