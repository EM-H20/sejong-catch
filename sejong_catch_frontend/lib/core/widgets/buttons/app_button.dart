import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

/// 세종 캐치 앱의 표준 버튼 위젯
/// 
/// 모든 버튼 스타일을 통일하고, 접근성과 사용성을 보장합니다.
/// ScreenUtil을 활용해서 모든 기기에서 일관된 크기를 제공해요.
class AppButton extends StatelessWidget {
  /// 버튼 텍스트
  final String text;
  
  /// 버튼 클릭 핸들러 (null이면 비활성화)
  final VoidCallback? onPressed;
  
  /// 버튼 스타일 유형
  final AppButtonStyle style;
  
  /// 버튼 크기 유형
  final AppButtonSize size;
  
  /// 커스텀 배경색 (스타일 우선순위 무시)
  final Color? backgroundColor;
  
  /// 커스텀 텍스트 색상 (스타일 우선순위 무시)
  final Color? textColor;
  
  /// 로딩 상태 (스피너 표시)
  final bool isLoading;
  
  /// 전체 너비 차지 여부
  final bool isExpanded;
  
  /// 좌측 아이콘
  final IconData? leftIcon;
  
  /// 우측 아이콘
  final IconData? rightIcon;
  
  /// 커스텀 패딩
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  });

  /// Primary 스타일 버튼 생성자
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  }) : style = AppButtonStyle.primary;

  /// Secondary 스타일 버튼 생성자
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  }) : style = AppButtonStyle.secondary;

  /// Outline 스타일 버튼 생성자
  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  }) : style = AppButtonStyle.outline;

  /// Text 스타일 버튼 생성자
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  }) : style = AppButtonStyle.text;

  /// Danger 스타일 버튼 생성자
  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isExpanded = false,
    this.leftIcon,
    this.rightIcon,
    this.padding,
  }) : style = AppButtonStyle.danger;

  @override
  Widget build(BuildContext context) {
    // 버튼이 활성화된 상태인지 확인
    final isEnabled = onPressed != null && !isLoading;
    
    // 스타일에 따른 색상 계산
    final colors = _getButtonColors(context, isEnabled);
    
    // 크기에 따른 디멘션 계산
    final dimensions = _getButtonDimensions();
    
    // 실제 버튼 위젯 구성
    Widget button = _buildButtonContent(colors, dimensions);
    
    // 전체 너비 차지하는 경우 SizedBox로 감싸기
    if (isExpanded) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }
  
  /// 스타일과 상태에 따른 색상 계산
  _ButtonColors _getButtonColors(BuildContext context, bool isEnabled) {
    final theme = Theme.of(context);
    
    // 커스텀 색상이 지정된 경우 우선 적용
    if (backgroundColor != null || textColor != null) {
      return _ButtonColors(
        background: backgroundColor ?? Colors.transparent,
        foreground: textColor ?? theme.colorScheme.onPrimary,
        border: style == AppButtonStyle.outline ? (backgroundColor ?? AppColors.brandCrimson) : null,
      );
    }
    
    // 비활성화 상태 색상
    if (!isEnabled) {
      return _ButtonColors(
        background: style == AppButtonStyle.text ? Colors.transparent : AppColors.disabled,
        foreground: AppColors.textSecondary,
        border: style == AppButtonStyle.outline ? AppColors.disabled : null,
      );
    }
    
    // 스타일별 색상 정의
    switch (style) {
      case AppButtonStyle.primary:
        return _ButtonColors(
          background: AppColors.brandCrimson,
          foreground: Colors.white,
        );
        
      case AppButtonStyle.secondary:
        return _ButtonColors(
          background: AppColors.brandCrimsonLight,
          foreground: AppColors.brandCrimson,
        );
        
      case AppButtonStyle.outline:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.brandCrimson,
          border: AppColors.brandCrimson,
        );
        
      case AppButtonStyle.text:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.brandCrimson,
        );
        
      case AppButtonStyle.danger:
        return _ButtonColors(
          background: AppColors.error,
          foreground: Colors.white,
        );
    }
  }
  
  /// 크기에 따른 디멘션 계산
  _ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case AppButtonSize.small:
        return _ButtonDimensions(
          height: 36.h,
          horizontalPadding: 16.w,
          fontSize: 12.sp,
          iconSize: 16.w,
        );
        
      case AppButtonSize.medium:
        return _ButtonDimensions(
          height: 44.h,
          horizontalPadding: 20.w,
          fontSize: 14.sp,
          iconSize: 18.w,
        );
        
      case AppButtonSize.large:
        return _ButtonDimensions(
          height: 52.h,
          horizontalPadding: 24.w,
          fontSize: 16.sp,
          iconSize: 20.w,
        );
    }
  }
  
  /// 실제 버튼 콘텐츠 구성
  Widget _buildButtonContent(_ButtonColors colors, _ButtonDimensions dimensions) {
    return Material(
      color: colors.background,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: dimensions.height,
          padding: padding ?? EdgeInsets.symmetric(
            horizontal: dimensions.horizontalPadding,
            vertical: 8.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: colors.border != null ? Border.all(
              color: colors.border!,
              width: 1.5.w,
            ) : null,
          ),
          child: _buildButtonChild(colors, dimensions),
        ),
      ),
    );
  }
  
  /// 버튼 내부 콘텐츠 (텍스트, 아이콘, 로딩 스피너)
  Widget _buildButtonChild(_ButtonColors colors, _ButtonDimensions dimensions) {
    // 로딩 상태일 때는 스피너만 표시
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: dimensions.iconSize,
          height: dimensions.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
          ),
        ),
      );
    }
    
    final children = <Widget>[];
    
    // 좌측 아이콘
    if (leftIcon != null) {
      children.add(Icon(
        leftIcon,
        size: dimensions.iconSize,
        color: colors.foreground,
      ));
      children.add(SizedBox(width: 8.w));
    }
    
    // 텍스트
    children.add(
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            fontSize: dimensions.fontSize,
            fontWeight: FontWeight.w600,
            color: colors.foreground,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    
    // 우측 아이콘
    if (rightIcon != null) {
      children.add(SizedBox(width: 8.w));
      children.add(Icon(
        rightIcon,
        size: dimensions.iconSize,
        color: colors.foreground,
      ));
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

// ============================================================================
// 버튼 스타일 열거형
// ============================================================================

/// 버튼 스타일 유형
enum AppButtonStyle {
  /// 주요 액션 버튼 (크림슨 배경, 흰색 텍스트)
  primary,
  
  /// 보조 액션 버튼 (크림슨 라이트 배경, 크림슨 텍스트)
  secondary,
  
  /// 테두리만 있는 버튼 (투명 배경, 크림슨 테두리)
  outline,
  
  /// 텍스트만 있는 버튼 (투명 배경, 크림슨 텍스트)
  text,
  
  /// 위험한 액션 버튼 (빨간색 배경, 흰색 텍스트)
  danger,
}

/// 버튼 크기 유형
enum AppButtonSize {
  /// 작은 버튼 (36dp 높이)
  small,
  
  /// 중간 버튼 (44dp 높이) - 기본값
  medium,
  
  /// 큰 버튼 (52dp 높이)
  large,
}

// ============================================================================
// 내부 데이터 클래스들
// ============================================================================

/// 버튼 색상 정보
class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;
  
  const _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
  });
}

/// 버튼 크기 정보
class _ButtonDimensions {
  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double iconSize;
  
  const _ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.iconSize,
  });
}