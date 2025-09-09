import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/app_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../chips/trust_badge.dart';
import '../buttons/cta_button.dart';

/// Data model for information items displayed in cards
class InfoItem {
  final String id;
  final String title;
  final String source;
  final String? sourceLogo;
  final TrustLevel trustLevel;
  final PriorityLevel priority;
  final String category;
  final DateTime createdAt;
  final DateTime? deadline;
  final String? summary;
  final String? url;
  final bool isBookmarked;
  final bool isRead;
  final bool isExpired;
  final int duplicateCount;
  final List<StatusChipType> statusChips;

  const InfoItem({
    required this.id,
    required this.title,
    required this.source,
    this.sourceLogo,
    required this.trustLevel,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.deadline,
    this.summary,
    this.url,
    this.isBookmarked = false,
    this.isRead = false,
    this.isExpired = false,
    this.duplicateCount = 0,
    this.statusChips = const [],
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${createdAt.month}월 ${createdAt.day}일';
    }
  }

  String get deadlineText {
    if (deadline == null) return '';
    
    final now = DateTime.now();
    final daysLeft = deadline!.difference(now).inDays;
    
    if (daysLeft < 0) {
      return '마감됨';
    } else if (daysLeft == 0) {
      return '오늘 마감';
    } else if (daysLeft == 1) {
      return '내일 마감';
    } else {
      return 'D-$daysLeft';
    }
  }

  bool get isDeadlineSoon => deadline != null && 
      deadline!.difference(DateTime.now()).inDays <= 3;
}

class AppCard extends StatelessWidget {
  final InfoItem item;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;
  final bool showActions;
  final bool isCompact;

  const AppCard({
    super.key,
    required this.item,
    this.onTap,
    this.onBookmarkTap,
    this.onShareTap,
    this.showActions = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        child: Column(
          children: [
            // Priority bar at the top
            PriorityBar(priority: item.priority),
            
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with source info and bookmark button
                  _buildHeader(context),
                  
                  SizedBox(height: 12.h),
                  
                  // Title and status chips
                  _buildTitle(context),
                  
                  SizedBox(height: 8.h),
                  
                  // Category, deadline, and time info
                  _buildMetadata(context),
                  
                  // Summary (if not compact and available)
                  if (!isCompact && item.summary != null) ...[
                    SizedBox(height: 12.h),
                    _buildSummary(context),
                  ],
                  
                  // Duplicate indicator
                  if (item.duplicateCount > 0) ...[
                    SizedBox(height: 12.h),
                    _buildDuplicateIndicator(context),
                  ],
                  
                  // Action buttons
                  if (showActions && !isCompact) ...[
                    SizedBox(height: 16.h),
                    _buildActions(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Source logo or placeholder
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: item.sourceLogo != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.network(
                    item.sourceLogo!,
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.business, size: 16.w),
                  ),
                )
              : Icon(Icons.business, size: 16.w),
        ),
        
        SizedBox(width: 8.w),
        
        // Source name
        Text(
          item.source,
          style: AppTextStyles.cardSubtitle.copyWith(
            color: item.isRead ? AppColors.textSecondaryLight : null,
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // Trust badge
        TrustBadge(
          trustLevel: item.trustLevel,
          isCompact: true,
        ),
        
        const Spacer(),
        
        // Bookmark button
        IconButton(
          onPressed: onBookmarkTap,
          icon: Icon(
            item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: item.isBookmarked ? AppColors.crimson : AppColors.textSecondaryLight,
          ),
          iconSize: 20.w,
          padding: EdgeInsets.all(4.w),
          constraints: BoxConstraints(
            minWidth: 32.w,
            minHeight: 32.w,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Expanded(
          child: Text(
            item.title,
            style: AppTextStyles.cardTitle.copyWith(
              color: item.isRead 
                  ? AppColors.textSecondaryLight 
                  : AppColors.textPrimaryLight,
            ),
            maxLines: isCompact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Status chips
        if (item.statusChips.isNotEmpty) ...[
          SizedBox(width: 8.w),
          Column(
            children: item.statusChips
                .take(2) // Limit to 2 chips to avoid crowding
                .map((chip) => Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: StatusChip(
                        type: chip,
                        isAnimated: chip == StatusChipType.hot,
                      ),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        // Category
        Icon(
          _getCategoryIcon(item.category),
          size: 14.w,
          color: AppColors.textSecondaryLight,
        ),
        SizedBox(width: 4.w),
        Text(
          item.category,
          style: AppTextStyles.cardSubtitle,
        ),
        
        // Dot separator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            width: 2.w,
            height: 2.w,
            decoration: const BoxDecoration(
              color: AppColors.textSecondaryLight,
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Deadline or created time
        if (item.deadline != null) ...[
          Icon(
            Icons.schedule,
            size: 14.w,
            color: item.isDeadlineSoon ? AppColors.error : AppColors.textSecondaryLight,
          ),
          SizedBox(width: 4.w),
          Text(
            item.deadlineText,
            style: AppTextStyles.cardSubtitle.copyWith(
              color: item.isDeadlineSoon ? AppColors.error : null,
              fontWeight: item.isDeadlineSoon ? FontWeight.w600 : null,
            ),
          ),
        ] else ...[
          Text(
            item.timeAgo,
            style: AppTextStyles.cardSubtitle,
          ),
        ],
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Text(
      item.summary!,
      style: AppTextStyles.bodySmall.copyWith(
        color: item.isRead 
            ? AppColors.textSecondaryLight 
            : AppColors.textPrimaryLight,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDuplicateIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.crimsonLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.layers,
            size: 12.w,
            color: AppColors.crimson,
          ),
          SizedBox(width: 4.w),
          Text(
            '유사 ${item.duplicateCount}건 통합',
            style: AppTextStyles.badgeText.copyWith(
              color: AppColors.crimson,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Open source link button
        if (item.url != null)
          CTAButton.outline(
            text: '출처 열기',
            size: CTAButtonSize.small,
            leadingIcon: Icons.open_in_new,
            onPressed: () {
              // TODO: Open URL
            },
          ),
        
        const Spacer(),
        
        // Share button
        IconButton(
          onPressed: onShareTap,
          icon: const Icon(Icons.share),
          iconSize: 18.w,
          color: AppColors.textSecondaryLight,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '공모전':
        return Icons.emoji_events;
      case '취업정보':
        return Icons.work;
      case '논문/학술':
        return Icons.school;
      case '공지사항':
        return Icons.announcement;
      default:
        return Icons.info;
    }
  }
}