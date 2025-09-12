/// 로그인 단계에서 사용되는 뒤로가기 버튼 위젯
/// 
/// 토스 스타일의 세련된 뒤로가기 버튼으로, 사용자가 이전 단계로 쉽게 돌아갈 수 있게 해줍니다.
/// 접근성과 사용성을 모두 고려한 디자인이에요! ⬅️
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 로그인 단계용 뒤로가기 버튼
/// 
/// 이전 단계로 돌아가는 기능을 제공하는 버튼입니다.
/// 여러 가지 스타일과 크기를 지원해요.
class LoginBackButton extends StatelessWidget {
  /// 뒤로가기 콜백 함수
  final VoidCallback? onPressed;

  /// 버튼 텍스트 (기본값: "이전 단계")
  final String? text;

  /// 아이콘 (기본값: Icons.arrow_back_ios)
  final IconData? icon;

  /// 버튼 스타일 (기본값: text)
  final LoginBackButtonStyle style;

  /// 버튼 크기 (기본값: medium)
  final LoginBackButtonSize size;

  /// 활성화 상태
  final bool enabled;

  /// 로딩 상태
  final bool isLoading;

  /// 커스텀 색상
  final Color? color;

  /// 커스텀 배경색 (filled 스타일에서만 사용)
  final Color? backgroundColor;

  const LoginBackButton({
    super.key,
    this.onPressed,
    this.text,
    this.icon,
    this.style = LoginBackButtonStyle.text,
    this.size = LoginBackButtonSize.medium,
    this.enabled = true,
    this.isLoading = false,
    this.color,
    this.backgroundColor,
  });

  /// 텍스트 버튼 스타일
  factory LoginBackButton.text({
    Key? key,
    VoidCallback? onPressed,
    String? text,
    IconData? icon,
    LoginBackButtonSize size = LoginBackButtonSize.medium,
    bool enabled = true,
    bool isLoading = false,
    Color? color,
  }) {
    return LoginBackButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      style: LoginBackButtonStyle.text,
      size: size,
      enabled: enabled,
      isLoading: isLoading,
      color: color,
    );
  }

  /// 아웃라인 버튼 스타일
  factory LoginBackButton.outlined({
    Key? key,
    VoidCallback? onPressed,
    String? text,
    IconData? icon,
    LoginBackButtonSize size = LoginBackButtonSize.medium,
    bool enabled = true,
    bool isLoading = false,
    Color? color,
  }) {
    return LoginBackButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      style: LoginBackButtonStyle.outlined,
      size: size,
      enabled: enabled,
      isLoading: isLoading,
      color: color,
    );
  }

  /// 채워진 버튼 스타일
  factory LoginBackButton.filled({
    Key? key,
    VoidCallback? onPressed,
    String? text,
    IconData? icon,
    LoginBackButtonSize size = LoginBackButtonSize.medium,
    bool enabled = true,
    bool isLoading = false,
    Color? color,
    Color? backgroundColor,
  }) {
    return LoginBackButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      style: LoginBackButtonStyle.filled,
      size: size,
      enabled: enabled,
      isLoading: isLoading,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  /// 아이콘만 있는 버튼
  factory LoginBackButton.iconOnly({
    Key? key,
    VoidCallback? onPressed,
    IconData? icon,
    LoginBackButtonSize size = LoginBackButtonSize.medium,
    bool enabled = true,
    bool isLoading = false,
    Color? color,
    Color? backgroundColor,
  }) {
    return LoginBackButton(
      key: key,
      onPressed: onPressed,
      icon: icon,
      style: LoginBackButtonStyle.iconOnly,
      size: size,
      enabled: enabled,
      isLoading: isLoading,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled && !isLoading;
    final VoidCallback? effectiveOnPressed = isEnabled ? onPressed : null;

    switch (style) {
      case LoginBackButtonStyle.text:
        return _buildTextButton(effectiveOnPressed);

      case LoginBackButtonStyle.outlined:
        return _buildOutlinedButton(effectiveOnPressed);

      case LoginBackButtonStyle.filled:
        return _buildFilledButton(effectiveOnPressed);

      case LoginBackButtonStyle.iconOnly:
        return _buildIconButton(effectiveOnPressed);
    }
  }

  /// 텍스트 버튼 빌드
  Widget _buildTextButton(VoidCallback? onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: TextButton.styleFrom(
        foregroundColor: _getEffectiveColor(),
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        textStyle: _getTextStyle(),
      ),
    );
  }

  /// 아웃라인 버튼 빌드
  Widget _buildOutlinedButton(VoidCallback? onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: OutlinedButton.styleFrom(
        foregroundColor: _getEffectiveColor(),
        side: BorderSide(
          color: _getEffectiveColor().withValues(alpha: 0.3),
          width: 1.5.w,
        ),
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        textStyle: _getTextStyle(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
    );
  }

  /// 채워진 버튼 빌드
  Widget _buildFilledButton(VoidCallback? onPressed) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: _buildIcon(),
      label: _buildLabel(),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? _getEffectiveColor(),
        foregroundColor: color ?? Colors.white,
        padding: _getPadding(),
        minimumSize: _getMinimumSize(),
        textStyle: _getTextStyle(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ),
    );
  }

  /// 아이콘 버튼 빌드
  Widget _buildIconButton(VoidCallback? onPressed) {
    final iconSize = _getIconSize();
    final buttonSize = iconSize * 1.8;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: style == LoginBackButtonStyle.outlined
            ? Border.all(
                color: _getEffectiveColor().withValues(alpha: 0.3),
                width: 1.5.w,
              )
            : null,
        borderRadius: BorderRadius.circular(buttonSize / 2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: _buildIcon(),
        iconSize: iconSize,
        color: _getEffectiveColor(),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// 아이콘 위젯 빌드
  Widget _buildIcon() {
    final effectiveIcon = icon ?? Icons.arrow_back_ios;
    
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          valueColor: AlwaysStoppedAnimation(_getEffectiveColor()),
        ),
      );
    }

    return Icon(
      effectiveIcon,
      size: _getIconSize(),
    );
  }

  /// 라벨 위젯 빌드
  Widget _buildLabel() {
    final effectiveText = text ?? '이전 단계';
    
    return Text(effectiveText);
  }

  /// 효과적인 색상 계산
  Color _getEffectiveColor() {
    if (!enabled) {
      return AppColors.textSecondary.withValues(alpha: 0.5);
    }
    
    return color ?? AppColors.textSecondary;
  }

  /// 크기별 패딩 계산
  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case LoginBackButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
      case LoginBackButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case LoginBackButtonSize.large:
        return EdgeInsets.symmetric(horizontal:20.w, vertical: 12.h);
    }
  }

  /// 크기별 최소 크기 계산
  Size _getMinimumSize() {
    switch (size) {
      case LoginBackButtonSize.small:
        return Size(0, 32.h);
      case LoginBackButtonSize.medium:
        return Size(0, 40.h);
      case LoginBackButtonSize.large:
        return Size(0, 48.h);
    }
  }

  /// 크기별 아이콘 크기 계산
  double _getIconSize() {
    switch (size) {
      case LoginBackButtonSize.small:
        return 16.w;
      case LoginBackButtonSize.medium:
        return 18.w;
      case LoginBackButtonSize.large:
        return 20.w;
    }
  }

  /// 크기별 텍스트 스타일 계산
  TextStyle _getTextStyle() {
    switch (size) {
      case LoginBackButtonSize.small:
        return TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500);
      case LoginBackButtonSize.medium:
        return TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
      case LoginBackButtonSize.large:
        return TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);
    }
  }

  /// 크기별 테두리 반지름 계산
  double _getBorderRadius() {
    switch (size) {
      case LoginBackButtonSize.small:
        return 8.r;
      case LoginBackButtonSize.medium:
        return 10.r;
      case LoginBackButtonSize.large:
        return 12.r;
    }
  }
}

/// 뒤로가기 버튼 스타일
enum LoginBackButtonStyle {
  /// 텍스트만 있는 버튼
  text,

  /// 테두리가 있는 버튼
  outlined,

  /// 배경이 채워진 버튼
  filled,

  /// 아이콘만 있는 원형 버튼
  iconOnly,
}

/// 뒤로가기 버튼 크기
enum LoginBackButtonSize {
  /// 작은 크기
  small,

  /// 중간 크기 (기본값)
  medium,

  /// 큰 크기
  large,
}

/// 플로팅 뒤로가기 버튼
/// 
/// 화면 상단에 고정되는 플로팅 스타일의 뒤로가기 버튼입니다.
/// 전체 화면 모달이나 풀스크린 플로우에서 유용해요.
class FloatingBackButton extends StatelessWidget {
  /// 뒤로가기 콜백 함수
  final VoidCallback? onPressed;

  /// 위치 (기본값: 왼쪽 상단)
  final AlignmentGeometry alignment;

  /// 마진
  final EdgeInsetsGeometry margin;

  /// 배경색
  final Color? backgroundColor;

  /// 아이콘 색상
  final Color? iconColor;

  /// 그림자 표시 여부
  final bool showShadow;

  const FloatingBackButton({
    super.key,
    this.onPressed,
    this.alignment = Alignment.topLeft,
    this.margin = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.iconColor,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Container(
          margin: margin,
          child: Material(
            color: backgroundColor ?? Colors.white,
            elevation: showShadow ? 4.0 : 0.0,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18.w,
                  color: iconColor ?? AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 단계 내비게이션 바
/// 
/// 이전/다음 단계 버튼이 함께 있는 내비게이션 바입니다.
/// 온보딩이나 여러 단계 프로세스에서 사용해요.
class StepNavigationBar extends StatelessWidget {
  /// 이전 단계 콜백
  final VoidCallback? onPrevious;

  /// 다음 단계 콜백
  final VoidCallback? onNext;

  /// 이전 단계 버튼 텍스트
  final String? previousText;

  /// 다음 단계 버튼 텍스트
  final String? nextText;

  /// 이전 단계 버튼 활성화 상태
  final bool canGoPrevious;

  /// 다음 단계 버튼 활성화 상태
  final bool canGoNext;

  /// 다음 단계 버튼 로딩 상태
  final bool isNextLoading;

  /// 배경색
  final Color? backgroundColor;

  /// 패딩
  final EdgeInsetsGeometry? padding;

  const StepNavigationBar({
    super.key,
    this.onPrevious,
    this.onNext,
    this.previousText,
    this.nextText,
    this.canGoPrevious = true,
    this.canGoNext = true,
    this.isNextLoading = false,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.all(16.w);

    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.white,
      padding: effectivePadding,
      child: SafeArea(
        child: Row(
          children: [
            // 이전 단계 버튼
            if (onPrevious != null && canGoPrevious) ...[
              LoginBackButton.outlined(
                onPressed: onPrevious,
                text: previousText ?? '이전',
                enabled: canGoPrevious,
              ),
              const Spacer(),
            ] else ...[
              const Spacer(),
            ],

            // 다음 단계 버튼
            if (onNext != null) ...[
              Expanded(
                flex: canGoPrevious ? 2 : 1,
                child: FilledButton(
                  onPressed: canGoNext ? onNext : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandCrimson,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: isNextLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.w,
                          ),
                        )
                      : Text(
                          nextText ?? '다음',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}