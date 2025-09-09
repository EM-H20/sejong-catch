import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 아바타 및 배지 시스템
/// 세종캐치 앱의 모든 프로필 이미지와 상태 표시를 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppAvatar(
///   imageUrl: "https://example.com/avatar.jpg",
///   name: "홍길동",
///   size: AppAvatarSize.large,
/// )
/// ```

enum AppAvatarSize {
  /// 매우 작은 크기 (16dp)
  tiny,
  
  /// 작은 크기 (24dp)
  small,
  
  /// 중간 크기 (32dp)
  medium,
  
  /// 큰 크기 (48dp)
  large,
  
  /// 매우 큰 크기 (64dp)
  xlarge,
  
  /// 거대한 크기 (96dp)
  xxlarge,
}

enum AppAvatarShape {
  /// 원형
  circle,
  
  /// 둥근 사각형
  rounded,
  
  /// 사각형
  square,
}

/// 기본 아바타 컴포넌트
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppAvatarSize.medium,
    this.shape = AppAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.badge,
    this.borderWidth,
    this.borderColor,
    this.isOnline,
    this.placeholder,
    this.errorWidget,
  });

  /// 이미지 URL
  final String? imageUrl;
  
  /// 이름 (이니셜 표시용)
  final String? name;
  
  /// 아바타 크기
  final AppAvatarSize size;
  
  /// 아바타 모양
  final AppAvatarShape shape;
  
  /// 배경색 (이미지 없을 때)
  final Color? backgroundColor;
  
  /// 전경색 (이니셜 텍스트)
  final Color? foregroundColor;
  
  /// 탭 콜백
  final VoidCallback? onTap;
  
  /// 배지 (알림 개수 등)
  final Widget? badge;
  
  /// 테두리 두께
  final double? borderWidth;
  
  /// 테두리 색상
  final Color? borderColor;
  
  /// 온라인 상태 표시
  final bool? isOnline;
  
  /// 플레이스홀더 위젯
  final Widget? placeholder;
  
  /// 에러 위젯
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final diameter = _getDiameter();
    
    Widget avatarWidget = Container(
      width: diameter,
      height: diameter,
      decoration: _getDecoration(context),
      child: ClipRRect(
        borderRadius: _getBorderRadius(diameter),
        child: _buildContent(context),
      ),
    );

    // 온라인 상태 표시
    if (isOnline != null) {
      avatarWidget = Stack(
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: diameter * 0.3,
              height: diameter * 0.3,
              decoration: BoxDecoration(
                color: isOnline! ? AppColors.success : AppColors.textTertiary(context),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceContainer(context),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 배지 추가
    if (badge != null) {
      avatarWidget = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarWidget,
          Positioned(
            right: -4.w,
            top: -4.h,
            child: badge!,
          ),
        ],
      );
    }

    // 탭 가능하게 만들기
    if (onTap != null) {
      avatarWidget = InkWell(
        onTap: onTap,
        borderRadius: _getBorderRadius(diameter),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildContent(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: _getDiameter(),
        height: _getDiameter(),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildInitials(context);
        },
      );
    }

    return _buildInitials(context);
  }

  Widget _buildInitials(BuildContext context) {
    final initials = _getInitials();
    
    return Container(
      width: _getDiameter(),
      height: _getDiameter(),
      color: backgroundColor ?? _getDefaultBackgroundColor(context),
      child: Center(
        child: Text(
          initials,
          style: _getTextStyle().copyWith(
            color: foregroundColor ?? _getDefaultForegroundColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: _getDiameter(),
      height: _getDiameter(),
      color: AppColors.surfaceVariant(context),
      child: Icon(
        Icons.person,
        size: _getDiameter() * 0.6,
        color: AppColors.textTertiary(context),
      ),
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return "?";
    
    final words = name!.trim().split(' ');
    if (words.isEmpty) return "?";
    
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return "${words[0].substring(0, 1)}${words[1].substring(0, 1)}".toUpperCase();
    }
  }

  double _getDiameter() {
    switch (size) {
      case AppAvatarSize.tiny:
        return 16.w;
      case AppAvatarSize.small:
        return 24.w;
      case AppAvatarSize.medium:
        return 32.w;
      case AppAvatarSize.large:
        return 48.w;
      case AppAvatarSize.xlarge:
        return 64.w;
      case AppAvatarSize.xxlarge:
        return 96.w;
    }
  }

  BorderRadius _getBorderRadius(double diameter) {
    switch (shape) {
      case AppAvatarShape.circle:
        return BorderRadius.circular(diameter / 2);
      case AppAvatarShape.rounded:
        return BorderRadius.circular(diameter * 0.15);
      case AppAvatarShape.square:
        return BorderRadius.zero;
    }
  }

  BoxDecoration _getDecoration(BuildContext context) {
    return BoxDecoration(
      shape: shape == AppAvatarShape.circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: shape != AppAvatarShape.circle ? _getBorderRadius(_getDiameter()) : null,
      border: borderWidth != null && borderWidth! > 0
          ? Border.all(
              color: borderColor ?? AppColors.border(context),
              width: borderWidth!,
            )
          : null,
    );
  }

  Color _getDefaultBackgroundColor(BuildContext context) {
    if (name == null) return AppColors.surfaceVariant(context);
    
    // 이름을 해시해서 일관된 색상 생성
    final hash = name.hashCode;
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.info,
      AppColors.warning,
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF795548), // Brown
    ];
    
    return colors[hash.abs() % colors.length];
  }

  Color _getDefaultForegroundColor(BuildContext context) {
    return AppColors.skyWhite;
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppAvatarSize.tiny:
        return AppTextStyles.tinyBold;
      case AppAvatarSize.small:
        return AppTextStyles.tinyBold;
      case AppAvatarSize.medium:
        return AppTextStyles.smallBold;
      case AppAvatarSize.large:
        return AppTextStyles.regularBold;
      case AppAvatarSize.xlarge:
        return AppTextStyles.largeBold;
      case AppAvatarSize.xxlarge:
        return AppTextStyles.title3;
    }
  }
}

/// 아바타 그룹 (여러 명이 겹쳐진 형태)
class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 3,
    this.size = AppAvatarSize.medium,
    this.spacing = -8.0,
    this.showCount = true,
    this.onTap,
  });

  /// 아바타 목록
  final List<AppAvatarData> avatars;
  
  /// 최대 표시 개수
  final int maxVisible;
  
  /// 아바타 크기
  final AppAvatarSize size;
  
  /// 겹침 정도 (음수값)
  final double spacing;
  
  /// 개수 표시 여부
  final bool showCount;
  
  /// 탭 콜백
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final visibleAvatars = avatars.take(maxVisible).toList();
    final remainingCount = avatars.length - maxVisible;
    
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: _getGroupWidth(),
        height: _getAvatarDiameter(),
        child: Stack(
          children: [
            // 표시될 아바타들
            ...visibleAvatars.asMap().entries.map((entry) {
              final index = entry.key;
              final avatarData = entry.value;
              
              return Positioned(
                left: index * (_getAvatarDiameter() + spacing),
                child: AppAvatar(
                  imageUrl: avatarData.imageUrl,
                  name: avatarData.name,
                  size: size,
                  borderWidth: 2,
                  borderColor: AppColors.surfaceContainer(context),
                ),
              );
            }),
            
            // 추가 개수 표시
            if (remainingCount > 0 && showCount)
              Positioned(
                left: visibleAvatars.length * (_getAvatarDiameter() + spacing),
                child: Container(
                  width: _getAvatarDiameter(),
                  height: _getAvatarDiameter(),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant(context),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.surfaceContainer(context),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "+$remainingCount",
                      style: _getTextStyle().copyWith(
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getAvatarDiameter() {
    switch (size) {
      case AppAvatarSize.tiny:
        return 16.w;
      case AppAvatarSize.small:
        return 24.w;
      case AppAvatarSize.medium:
        return 32.w;
      case AppAvatarSize.large:
        return 48.w;
      case AppAvatarSize.xlarge:
        return 64.w;
      case AppAvatarSize.xxlarge:
        return 96.w;
    }
  }

  double _getGroupWidth() {
    final visibleCount = avatars.length > maxVisible ? maxVisible : avatars.length;
    final extraCount = avatars.length > maxVisible && showCount ? 1 : 0;
    
    return (visibleCount + extraCount - 1) * (_getAvatarDiameter() + spacing) + _getAvatarDiameter();
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppAvatarSize.tiny:
        return AppTextStyles.tinyBold.copyWith(fontSize: 8.sp);
      case AppAvatarSize.small:
        return AppTextStyles.tinyBold.copyWith(fontSize: 10.sp);
      case AppAvatarSize.medium:
        return AppTextStyles.tinyBold;
      case AppAvatarSize.large:
        return AppTextStyles.smallBold;
      case AppAvatarSize.xlarge:
        return AppTextStyles.regularBold;
      case AppAvatarSize.xxlarge:
        return AppTextStyles.largeBold;
    }
  }
}

// ============================================================================
// BADGE COMPONENTS
// ============================================================================

enum AppBadgeType {
  /// 숫자 배지 (알림 개수)
  number,
  
  /// 점 배지 (새로운 알림 존재)
  dot,
  
  /// 텍스트 배지
  text,
  
  /// 상태 배지
  status,
}

enum AppBadgeStatus {
  /// 성공/활성
  success,
  
  /// 경고
  warning,
  
  /// 에러/중요
  error,
  
  /// 정보
  info,
  
  /// 중성
  neutral,
}

/// 기본 배지 컴포넌트
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    this.text,
    this.count,
    this.type = AppBadgeType.number,
    this.status = AppBadgeStatus.error,
    this.backgroundColor,
    this.textColor,
    this.maxCount = 99,
    this.showZero = false,
  });

  /// 텍스트 내용
  final String? text;
  
  /// 숫자 개수
  final int? count;
  
  /// 배지 타입
  final AppBadgeType type;
  
  /// 배지 상태
  final AppBadgeStatus status;
  
  /// 배경색
  final Color? backgroundColor;
  
  /// 텍스트 색상
  final Color? textColor;
  
  /// 최대 표시 개수
  final int maxCount;
  
  /// 0일 때도 표시할지 여부
  final bool showZero;

  @override
  Widget build(BuildContext context) {
    if (type == AppBadgeType.number && (count == null || (count! <= 0 && !showZero))) {
      return const SizedBox.shrink();
    }

    if (type == AppBadgeType.dot) {
      return _buildDotBadge(context);
    }

    return _buildTextBadge(context);
  }

  Widget _buildDotBadge(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: backgroundColor ?? _getStatusColor(context),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTextBadge(BuildContext context) {
    String displayText = "";
    
    switch (type) {
      case AppBadgeType.number:
        displayText = count! > maxCount ? "$maxCount+" : count.toString();
        break;
      case AppBadgeType.text:
        displayText = text ?? "";
        break;
      case AppBadgeType.status:
        displayText = text ?? _getStatusText();
        break;
      case AppBadgeType.dot:
        // 이미 위에서 처리됨
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: type == AppBadgeType.number ? 6.w : 8.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? _getStatusColor(context),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        displayText,
        style: AppTextStyles.tinyBold.copyWith(
          color: textColor ?? AppColors.skyWhite,
          fontSize: 10.sp,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    switch (status) {
      case AppBadgeStatus.success:
        return AppColors.success;
      case AppBadgeStatus.warning:
        return AppColors.warning;
      case AppBadgeStatus.error:
        return AppColors.error;
      case AppBadgeStatus.info:
        return AppColors.info;
      case AppBadgeStatus.neutral:
        return AppColors.textSecondary(context);
    }
  }

  String _getStatusText() {
    switch (status) {
      case AppBadgeStatus.success:
        return "NEW";
      case AppBadgeStatus.warning:
        return "HOT";
      case AppBadgeStatus.error:
        return "!";
      case AppBadgeStatus.info:
        return "i";
      case AppBadgeStatus.neutral:
        return "•";
    }
  }
}

/// 배지가 있는 래퍼 위젯
class AppBadgedWidget extends StatelessWidget {
  const AppBadgedWidget({
    super.key,
    required this.child,
    required this.badge,
    this.position = AppBadgePosition.topRight,
    this.offset,
  });

  /// 메인 위젯
  final Widget child;
  
  /// 배지 위젯
  final Widget badge;
  
  /// 배지 위치
  final AppBadgePosition position;
  
  /// 오프셋 조정
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: _getTop(),
          right: _getRight(),
          bottom: _getBottom(),
          left: _getLeft(),
          child: Transform.translate(
            offset: offset ?? Offset.zero,
            child: badge,
          ),
        ),
      ],
    );
  }

  double? _getTop() {
    switch (position) {
      case AppBadgePosition.topRight:
      case AppBadgePosition.topLeft:
        return -4.h;
      case AppBadgePosition.bottomRight:
      case AppBadgePosition.bottomLeft:
        return null;
    }
  }

  double? _getRight() {
    switch (position) {
      case AppBadgePosition.topRight:
      case AppBadgePosition.bottomRight:
        return -4.w;
      case AppBadgePosition.topLeft:
      case AppBadgePosition.bottomLeft:
        return null;
    }
  }

  double? _getBottom() {
    switch (position) {
      case AppBadgePosition.topRight:
      case AppBadgePosition.topLeft:
        return null;
      case AppBadgePosition.bottomRight:
      case AppBadgePosition.bottomLeft:
        return -4.h;
    }
  }

  double? _getLeft() {
    switch (position) {
      case AppBadgePosition.topRight:
      case AppBadgePosition.bottomRight:
        return null;
      case AppBadgePosition.topLeft:
      case AppBadgePosition.bottomLeft:
        return -4.w;
    }
  }
}

// ============================================================================
// DATA CLASSES & ENUMS
// ============================================================================

/// 아바타 데이터
class AppAvatarData {
  const AppAvatarData({
    this.imageUrl,
    this.name,
  });

  final String? imageUrl;
  final String? name;
}

/// 배지 위치
enum AppBadgePosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

// ============================================================================
// 편의성 생성자들 - 세종캐치 특화
// ============================================================================

/// 사용자 프로필 아바타
class AppUserAvatar extends AppAvatar {
  const AppUserAvatar({
    super.key,
    super.imageUrl,
    super.name,
    super.size = AppAvatarSize.medium,
    super.onTap,
    super.isOnline,
  });
}

/// 출처 로고 아바타 (정사각형)
class AppSourceAvatar extends AppAvatar {
  const AppSourceAvatar({
    super.key,
    required super.imageUrl,
    super.size = AppAvatarSize.small,
    super.shape = AppAvatarShape.rounded,
  });
}

/// 알림 배지
class AppNotificationBadge extends AppBadge {
  const AppNotificationBadge({
    super.key,
    super.count,
  }) : super(
         type: AppBadgeType.number,
         status: AppBadgeStatus.error,
       );
}

/// HOT 배지
class AppHotBadge extends AppBadge {
  const AppHotBadge({super.key})
      : super(
          text: "HOT",
          type: AppBadgeType.status,
          status: AppBadgeStatus.warning,
        );
}

/// NEW 배지
class AppNewBadge extends AppBadge {
  const AppNewBadge({super.key})
      : super(
          text: "NEW",
          type: AppBadgeType.status,
          status: AppBadgeStatus.success,
        );
}