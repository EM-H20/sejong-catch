import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/app_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TrustBadge extends StatelessWidget {
  final TrustLevel trustLevel;
  final bool isCompact;

  const TrustBadge({
    super.key,
    required this.trustLevel,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getTrustConfig(trustLevel);
    
    return Container(
      padding: isCompact 
          ? EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h)
          : EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: config['color'] as Color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(isCompact ? 8.r : 10.r),
        color: (config['color'] as Color).withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config['icon'] as IconData,
            size: isCompact ? 10.w : 12.w,
            color: config['color'] as Color,
          ),
          if (!isCompact) ...[
            SizedBox(width: 4.w),
            Text(
              config['label'] as String,
              style: AppTextStyles.badgeText.copyWith(
                fontSize: isCompact ? 8.sp : 10.sp,
                color: config['color'] as Color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Map<String, dynamic> _getTrustConfig(TrustLevel level) {
    switch (level) {
      case TrustLevel.official:
        return {
          'icon': Icons.verified_outlined,
          'label': '공식',
          'color': AppColors.trustOfficial,
        };
      case TrustLevel.academic:
        return {
          'icon': Icons.school_outlined,
          'label': '학술',
          'color': AppColors.trustAcademic,
        };
      case TrustLevel.press:
        return {
          'icon': Icons.article_outlined,
          'label': '언론',
          'color': AppColors.trustPress,
        };
      case TrustLevel.community:
        return {
          'icon': Icons.people_outline,
          'label': '커뮤니티',
          'color': AppColors.trustCommunity,
        };
    }
  }
}

/// Priority indicator bar that appears at the top of cards
class PriorityBar extends StatelessWidget {
  final PriorityLevel priority;
  final double height;

  const PriorityBar({
    super.key,
    required this.priority,
    this.height = 3,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority);
    
    if (priority == PriorityLevel.low) {
      return const SizedBox.shrink(); // Don't show bar for low priority
    }

    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConfig.borderRadius.r),
        ),
      ),
    );
  }

  Color _getPriorityColor(PriorityLevel level) {
    switch (level) {
      case PriorityLevel.high:
        return AppColors.priorityHigh;
      case PriorityLevel.medium:
        return AppColors.priorityMedium;
      case PriorityLevel.low:
        return AppColors.priorityLow;
    }
  }
}

/// Status chips for special indicators like HOT, TREND, etc.
class StatusChip extends StatelessWidget {
  final StatusChipType type;
  final bool isAnimated;

  const StatusChip({
    super.key,
    required this.type,
    this.isAnimated = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(type);
    
    Widget chip = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config['backgroundColor'] as Color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: (config['backgroundColor'] as Color).withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        config['label'] as String,
        style: AppTextStyles.badgeText.copyWith(
          fontSize: 9.sp,
          color: config['textColor'] as Color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (isAnimated && type == StatusChipType.hot) {
      return _buildAnimatedChip(chip);
    }

    return chip;
  }

  Widget _buildAnimatedChip(Widget chip) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: chip,
        );
      },
    );
  }

  Map<String, dynamic> _getStatusConfig(StatusChipType type) {
    switch (type) {
      case StatusChipType.hot:
        return {
          'label': 'HOT',
          'backgroundColor': AppColors.error,
          'textColor': AppColors.white,
        };
      case StatusChipType.trend:
        return {
          'label': 'TREND',
          'backgroundColor': AppColors.warning,
          'textColor': AppColors.white,
        };
      case StatusChipType.recommended:
        return {
          'label': '추천',
          'backgroundColor': AppColors.crimson,
          'textColor': AppColors.white,
        };
      case StatusChipType.new_:
        return {
          'label': 'NEW',
          'backgroundColor': AppColors.success,
          'textColor': AppColors.white,
        };
      case StatusChipType.deadline:
        return {
          'label': '마감임박',
          'backgroundColor': AppColors.error,
          'textColor': AppColors.white,
        };
    }
  }
}

enum StatusChipType {
  hot,
  trend,
  recommended,
  new_,
  deadline,
}