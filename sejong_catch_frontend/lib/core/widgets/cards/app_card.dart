import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 통합 카드 시스템
/// 세종캐치 앱의 모든 정보 표시를 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppCard(
///   child: Text("카드 내용"),
///   onTap: () => navigate(),
/// )
/// ```
enum AppCardVariant {
  /// 기본 카드 (elevation 있음)
  elevated,
  
  /// 플랫 카드 (경계선만)
  outlined,
  
  /// 채워진 카드 (배경색 있음)
  filled,
  
  /// 이미지 카드 (이미지가 메인)
  image,
}

enum AppCardSize {
  /// 작은 카드
  small,
  
  /// 중간 카드
  medium,
  
  /// 큰 카드
  large,
  
  /// 전체 너비 카드
  full,
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.size = AppCardSize.medium,
    this.onTap,
    this.onLongPress,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.isSelected = false,
    this.isDisabled = false,
    this.clipBehavior = Clip.antiAlias,
  });

  /// 카드 내용
  final Widget child;
  
  /// 카드 스타일 변형
  final AppCardVariant variant;
  
  /// 카드 크기
  final AppCardSize size;
  
  /// 탭 콜백
  final VoidCallback? onTap;
  
  /// 길게 누르기 콜백
  final VoidCallback? onLongPress;
  
  /// 외부 여백
  final EdgeInsets? margin;
  
  /// 내부 패딩
  final EdgeInsets? padding;
  
  /// 고정 너비
  final double? width;
  
  /// 고정 높이
  final double? height;
  
  /// 배경색 (오버라이드)
  final Color? backgroundColor;
  
  /// 테두리 색상
  final Color? borderColor;
  
  /// 테두리 너비
  final double? borderWidth;
  
  /// 모서리 둥글기
  final BorderRadius? borderRadius;
  
  /// 그림자 높이
  final double? elevation;
  
  /// 그림자 색상
  final Color? shadowColor;
  
  /// 선택 상태 여부
  final bool isSelected;
  
  /// 비활성화 상태 여부
  final bool isDisabled;
  
  /// 클립 동작
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final isInteractive = onTap != null || onLongPress != null;
    
    return Container(
      width: width ?? _getWidth(),
      height: height,
      margin: margin ?? _getMargin(),
      child: Material(
        color: _getBackgroundColor(context),
        elevation: _getElevation(),
        shadowColor: shadowColor ?? _getShadowColor(context),
        borderRadius: borderRadius ?? _getBorderRadius(),
        clipBehavior: clipBehavior,
        child: Container(
          decoration: _getDecoration(context),
          child: isInteractive && !isDisabled
              ? InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  borderRadius: borderRadius ?? _getBorderRadius(),
                  child: _buildContent(context),
                )
              : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getPadding(),
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: child,
      ),
    );
  }

  // ============================================================================
  // STYLE CALCULATIONS
  // ============================================================================

  double? _getWidth() {
    switch (size) {
      case AppCardSize.small:
        return 120.w;
      case AppCardSize.medium:
        return 200.w;
      case AppCardSize.large:
        return 280.w;
      case AppCardSize.full:
        return double.infinity;
    }
  }

  EdgeInsets _getMargin() {
    switch (size) {
      case AppCardSize.small:
        return EdgeInsets.all(4.w);
      case AppCardSize.medium:
        return EdgeInsets.all(6.w);
      case AppCardSize.large:
        return EdgeInsets.all(8.w);
      case AppCardSize.full:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppCardSize.small:
        return EdgeInsets.all(12.w);
      case AppCardSize.medium:
        return EdgeInsets.all(16.w);
      case AppCardSize.large:
        return EdgeInsets.all(20.w);
      case AppCardSize.full:
        return EdgeInsets.all(16.w);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppCardSize.small:
        return BorderRadius.circular(8.r);
      case AppCardSize.medium:
        return BorderRadius.circular(12.r);
      case AppCardSize.large:
        return BorderRadius.circular(16.r);
      case AppCardSize.full:
        return BorderRadius.circular(12.r);
    }
  }

  double _getElevation() {
    if (elevation != null) return elevation!;
    
    switch (variant) {
      case AppCardVariant.elevated:
        return isSelected ? 8 : 4;
      case AppCardVariant.outlined:
      case AppCardVariant.filled:
      case AppCardVariant.image:
        return 0;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    
    if (isSelected) {
      return AppColors.primaryLightest;
    }
    
    switch (variant) {
      case AppCardVariant.elevated:
      case AppCardVariant.outlined:
      case AppCardVariant.image:
        return AppColors.surfaceContainer(context);
      case AppCardVariant.filled:
        return AppColors.surfaceVariant(context);
    }
  }

  Color _getShadowColor(BuildContext context) {
    return AppColors.inkDarkest.withValues(alpha: 0.1);
  }

  BoxDecoration? _getDecoration(BuildContext context) {
    final needsBorder = variant == AppCardVariant.outlined || 
                       borderColor != null || 
                       isSelected;
    
    if (!needsBorder) return null;
    
    return BoxDecoration(
      border: Border.all(
        color: _getBorderColor(context),
        width: borderWidth ?? (isSelected ? 2 : 1),
      ),
      borderRadius: borderRadius ?? _getBorderRadius(),
    );
  }

  Color _getBorderColor(BuildContext context) {
    if (borderColor != null) return borderColor!;
    
    if (isSelected) {
      return AppColors.themePrimary(context);
    }
    
    return AppColors.border(context);
  }
}

// ============================================================================
// 특화된 카드 컴포넌트들 - 세종캐치용
// ============================================================================

/// 정보 아이템 카드 (공모전, 채용정보 등)
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.source,
    this.subtitle,
    this.description,
    this.imageUrl,
    this.tags,
    this.deadline,
    this.createdAt,
    this.trustLevel,
    this.priority,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkTap,
    this.size = AppCardSize.full,
  });

  final String title;
  final String source;
  final String? subtitle;
  final String? description;
  final String? imageUrl;
  final List<String>? tags;
  final DateTime? deadline;
  final DateTime? createdAt;
  final TrustLevel? trustLevel;
  final Priority? priority;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final AppCardSize size;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      size: size,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 12.h),
          _buildTitle(context),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            _buildSubtitle(context),
          ],
          if (description != null) ...[
            SizedBox(height: 8.h),
            _buildDescription(context),
          ],
          if (tags?.isNotEmpty == true) ...[
            SizedBox(height: 12.h),
            _buildTags(context),
          ],
          SizedBox(height: 12.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // 출처 정보
        Expanded(
          child: Row(
            children: [
              if (imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.network(
                    imageUrl!,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant(context),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 12.w,
                        color: AppColors.textTertiary(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Text(
                  source,
                  style: AppTextStyles.source.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trustLevel != null) ...[
                SizedBox(width: 8.w),
                TrustBadge(level: trustLevel!),
              ],
            ],
          ),
        ),
        // 북마크 버튼
        if (onBookmarkTap != null)
          IconButton(
            onPressed: onBookmarkTap,
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              size: 20.w,
              color: isBookmarked 
                  ? AppColors.themePrimary(context) 
                  : AppColors.textSecondary(context),
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(
              width: 32.w,
              height: 32.w,
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        // 우선순위 바
        if (priority != null)
          Container(
            width: 3.w,
            height: 20.h,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: _getPriorityColor(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary(context),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      subtitle!,
      style: AppTextStyles.subtitle.copyWith(
        color: AppColors.textSecondary(context),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description!,
      style: AppTextStyles.bodyText.copyWith(
        color: AppColors.textSecondary(context),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      children: tags!.take(3).map((tag) => TagChip(text: tag)).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // 마감일 또는 작성일
        Expanded(
          child: Text(
            _getDateText(),
            style: AppTextStyles.timestamp.copyWith(
              color: _getDateColor(context),
            ),
          ),
        ),
        // 상태 칩들
        if (deadline != null && _isDeadlineSoon()) ...[
          SizedBox(width: 8.w),
          StatusChip(
            text: "마감임박",
            type: StatusChipType.warning,
          ),
        ],
      ],
    );
  }

  String _getDateText() {
    if (deadline != null) {
      final now = DateTime.now();
      final difference = deadline!.difference(now).inDays;
      
      if (difference < 0) {
        return "마감됨";
      } else if (difference == 0) {
        return "오늘 마감";
      } else if (difference == 1) {
        return "내일 마감";
      } else {
        return "D-$difference";
      }
    }
    
    if (createdAt != null) {
      final now = DateTime.now();
      final difference = now.difference(createdAt!);
      
      if (difference.inDays > 0) {
        return "${difference.inDays}일 전";
      } else if (difference.inHours > 0) {
        return "${difference.inHours}시간 전";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes}분 전";
      } else {
        return "방금 전";
      }
    }
    
    return "";
  }

  Color _getDateColor(BuildContext context) {
    if (deadline != null) {
      final now = DateTime.now();
      final difference = deadline!.difference(now).inDays;
      
      if (difference < 0) {
        return AppColors.textTertiary(context);
      } else if (difference <= 3) {
        return AppColors.error;
      } else if (difference <= 7) {
        return AppColors.warning;
      }
    }
    
    return AppColors.textTertiary(context);
  }

  Color _getPriorityColor(BuildContext context) {
    switch (priority) {
      case Priority.high:
        return AppColors.priorityHigh(context);
      case Priority.medium:
        return AppColors.priorityMedium(context);
      case Priority.low:
        return AppColors.priorityLow(context);
      case null:
        return AppColors.textTertiary(context);
    }
  }

  bool _isDeadlineSoon() {
    if (deadline == null) return false;
    final now = DateTime.now();
    final difference = deadline!.difference(now).inDays;
    return difference >= 0 && difference <= 3;
  }
}

/// 신뢰도 배지
class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key, required this.level});

  final TrustLevel level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: _getBorderColor(context),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            size: 10.w,
            color: _getTextColor(context),
          ),
          SizedBox(width: 2.w),
          Text(
            _getText(),
            style: AppTextStyles.badge.copyWith(
              color: _getTextColor(context),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (level) {
      case TrustLevel.official:
        return Icons.verified;
      case TrustLevel.academic:
        return Icons.school;
      case TrustLevel.press:
        return Icons.article;
      case TrustLevel.community:
        return Icons.group;
    }
  }

  String _getText() {
    switch (level) {
      case TrustLevel.official:
        return "공식";
      case TrustLevel.academic:
        return "학술";
      case TrustLevel.press:
        return "언론";
      case TrustLevel.community:
        return "커뮤니티";
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (level) {
      case TrustLevel.official:
        return AppColors.primaryLightest;
      case TrustLevel.academic:
        return AppColors.surfaceVariant(context);
      case TrustLevel.press:
        return AppColors.surfaceVariant(context);
      case TrustLevel.community:
        return AppColors.surfaceVariant(context);
    }
  }

  Color _getBorderColor(BuildContext context) {
    switch (level) {
      case TrustLevel.official:
        return AppColors.themePrimary(context);
      case TrustLevel.academic:
        return AppColors.trustAcademic(context);
      case TrustLevel.press:
        return AppColors.trustPress(context);
      case TrustLevel.community:
        return AppColors.trustCommunity(context);
    }
  }

  Color _getTextColor(BuildContext context) {
    return _getBorderColor(context);
  }
}

/// 태그 칩
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant(context),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.badge.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }
}

/// 상태 칩
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.text,
    required this.type,
  });

  final String text;
  final StatusChipType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.badge.copyWith(
          color: _getTextColor(context),
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    switch (type) {
      case StatusChipType.success:
        return AppColors.successLightest;
      case StatusChipType.warning:
        return AppColors.warningLightest;
      case StatusChipType.error:
        return AppColors.errorLightest;
      case StatusChipType.info:
        return AppColors.infoLightest;
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case StatusChipType.success:
        return AppColors.successDarkest;
      case StatusChipType.warning:
        return AppColors.warningDarkest;
      case StatusChipType.error:
        return AppColors.errorDarkest;
      case StatusChipType.info:
        return AppColors.infoDarkest;
    }
  }
}

// ============================================================================
// ENUMS & DATA CLASSES
// ============================================================================

enum TrustLevel {
  official,   // 공식 (대학, 정부)
  academic,   // 학술 (논문, 학술지)
  press,      // 언론 (뉴스, 보도자료)
  community,  // 커뮤니티 (게시판, 사용자)
}

enum Priority {
  high,       // 높음
  medium,     // 중간
  low,        // 낮음
}

enum StatusChipType {
  success,    // 성공/완료
  warning,    // 경고/주의
  error,      // 에러/실패
  info,       // 정보/알림
}