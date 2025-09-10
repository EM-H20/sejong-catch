import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 통합 버튼 시스템
/// 세종캐치 앱의 모든 버튼 인터랙션을 담당하는 핵심 컴포넌트
/// 
/// 사용법:
/// ```dart
/// AppButton(
///   text: "로그인하기",
///   type: AppButtonType.primary,
///   onPressed: () => login(),
/// )
/// ```
enum AppButtonType {
  /// 주요 액션 (로그인, 가입, 제출 등)
  primary,
  
  /// 보조 액션 (취소, 뒤로가기 등)  
  secondary,
  
  /// 텍스트만 있는 버튼 (링크, 부가 액션)
  text,
  
  /// 아이콘만 있는 버튼 (좋아요, 공유 등)
  icon,
  
  /// 위험한 액션 (삭제, 로그아웃 등)
  danger,
  
  /// 성공 액션 (완료, 확인 등)
  success,
}

enum AppButtonSize {
  /// 큰 버튼 (메인 CTA)
  large,
  
  /// 중간 버튼 (일반적)
  medium,
  
  /// 작은 버튼 (좁은 공간용)
  small,
  
  /// 매우 작은 버튼 (칩, 태그 등)
  tiny,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = AppButtonIconPosition.leading,
    this.fullWidth = false,
    this.customWidth,
    this.customHeight,
  });

  /// 버튼 텍스트
  final String text;
  
  /// 버튼 클릭 콜백
  final VoidCallback? onPressed;
  
  /// 버튼 타입 (색상과 스타일 결정)
  final AppButtonType type;
  
  /// 버튼 크기
  final AppButtonSize size;
  
  /// 로딩 상태 (로딩 시 스피너 표시)
  final bool isLoading;
  
  /// 비활성화 상태
  final bool isDisabled;
  
  /// 아이콘 (선택사항)
  final IconData? icon;
  
  /// 아이콘 위치
  final AppButtonIconPosition iconPosition;
  
  /// 전체 너비 사용 여부
  final bool fullWidth;
  
  /// 커스텀 너비 (fullWidth보다 우선)
  final double? customWidth;
  
  /// 커스텀 높이 (size보다 우선)
  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;
    
    return SizedBox(
      width: customWidth ?? (fullWidth ? double.infinity : null),
      height: customHeight ?? _getHeight(),
      child: _buildButton(context, isEnabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isEnabled) {
    switch (type) {
      case AppButtonType.primary:
        return _buildPrimaryButton(context, isEnabled);
      case AppButtonType.secondary:
        return _buildSecondaryButton(context, isEnabled);
      case AppButtonType.text:
        return _buildTextButton(context, isEnabled);
      case AppButtonType.icon:
        return _buildIconButton(context, isEnabled);
      case AppButtonType.danger:
        return _buildDangerButton(context, isEnabled);
      case AppButtonType.success:
        return _buildSuccessButton(context, isEnabled);
    }
  }

  // ============================================================================
  // PRIMARY BUTTON - 메인 CTA용
  // ============================================================================
  Widget _buildPrimaryButton(BuildContext context, bool isEnabled) {
    return FilledButton(
      onPressed: isEnabled ? _handlePress : null,
      style: FilledButton.styleFrom(
        backgroundColor: isEnabled ? AppColors.themePrimary(context) : AppColors.buttonDisabled(context),
        foregroundColor: isEnabled ? AppColors.skyWhite : AppColors.textTertiary(context),
        disabledBackgroundColor: AppColors.buttonDisabled(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
        minimumSize: Size(_getMinWidth(), _getHeight()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 0,
        // 눌렸을 때 효과
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.themePrimaryDark(context).withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.themePrimaryLight(context).withValues(alpha: 0.1);
          }
          return null;
        }),
      ),
      child: _buildButtonContent(context),
    );
  }

  // ============================================================================
  // SECONDARY BUTTON - 보조 액션용
  // ============================================================================
  Widget _buildSecondaryButton(BuildContext context, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? _handlePress : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: isEnabled ? AppColors.primary : AppColors.textTertiary(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
        minimumSize: Size(_getMinWidth(), _getHeight()),
        side: BorderSide(
          color: isEnabled ? AppColors.primary : AppColors.border(context),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primary.withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
      child: _buildButtonContent(context),
    );
  }

  // ============================================================================
  // TEXT BUTTON - 링크 스타일용
  // ============================================================================
  Widget _buildTextButton(BuildContext context, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? _handlePress : null,
      style: TextButton.styleFrom(
        foregroundColor: isEnabled ? AppColors.themePrimary(context) : AppColors.textTertiary(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        textStyle: _getTextStyle().copyWith(
          decoration: TextDecoration.underline,
          decorationColor: isEnabled ? AppColors.themePrimary(context) : AppColors.textTertiary(context),
        ),
        padding: _getPadding(),
        minimumSize: Size(_getMinWidth(), _getHeight()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.themePrimary(context).withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.themePrimary(context).withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
      child: _buildButtonContent(context),
    );
  }

  // ============================================================================
  // ICON BUTTON - 아이콘만 있는 버튼
  // ============================================================================
  Widget _buildIconButton(BuildContext context, bool isEnabled) {
    return IconButton(
      onPressed: isEnabled ? _handlePress : null,
      icon: isLoading ? _buildLoadingSpinner(context) : Icon(icon ?? Icons.star),
      iconSize: _getIconSize(),
      style: IconButton.styleFrom(
        foregroundColor: isEnabled ? AppColors.themePrimary(context) : AppColors.textTertiary(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        minimumSize: Size(_getHeight(), _getHeight()), // 정사각형
        padding: EdgeInsets.all(_getIconPadding()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.themePrimary(context).withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.themePrimary(context).withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
    );
  }

  // ============================================================================
  // DANGER BUTTON - 위험한 액션용
  // ============================================================================
  Widget _buildDangerButton(BuildContext context, bool isEnabled) {
    return FilledButton(
      onPressed: isEnabled ? _handlePress : null,
      style: FilledButton.styleFrom(
        backgroundColor: isEnabled ? AppColors.error : AppColors.buttonDisabled(context),
        foregroundColor: AppColors.skyWhite,
        disabledBackgroundColor: AppColors.buttonDisabled(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
        minimumSize: Size(_getMinWidth(), _getHeight()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 0,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.errorDarkest.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.errorLight.withValues(alpha: 0.1);
          }
          return null;
        }),
      ),
      child: _buildButtonContent(context),
    );
  }

  // ============================================================================
  // SUCCESS BUTTON - 성공 액션용
  // ============================================================================
  Widget _buildSuccessButton(BuildContext context, bool isEnabled) {
    return FilledButton(
      onPressed: isEnabled ? _handlePress : null,
      style: FilledButton.styleFrom(
        backgroundColor: isEnabled ? AppColors.success : AppColors.buttonDisabled(context),
        foregroundColor: AppColors.skyWhite,
        disabledBackgroundColor: AppColors.buttonDisabled(context),
        disabledForegroundColor: AppColors.textTertiary(context),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
        minimumSize: Size(_getMinWidth(), _getHeight()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 0,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.successDarkest.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppColors.successLight.withValues(alpha: 0.1);
          }
          return null;
        }),
      ),
      child: _buildButtonContent(context),
    );
  }

  // ============================================================================
  // BUTTON CONTENT BUILDERS
  // ============================================================================
  
  Widget _buildButtonContent(BuildContext context) {
    if (type == AppButtonType.icon) {
      return isLoading ? _buildLoadingSpinner(context) : Icon(icon ?? Icons.star);
    }

    if (isLoading) {
      return _buildLoadingContent(context);
    }

    if (icon == null) {
      return Text(text);
    }

    // 아이콘이 있는 경우
    return _buildIconTextContent(context);
  }

  Widget _buildIconTextContent(BuildContext context) {
    final iconWidget = Icon(icon, size: _getIconSize());
    final textWidget = Text(text);
    final gap = SizedBox(width: _getIconTextGap());

    switch (iconPosition) {
      case AppButtonIconPosition.leading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [iconWidget, gap, textWidget],
        );
      case AppButtonIconPosition.trailing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [textWidget, gap, iconWidget],
        );
    }
  }

  Widget _buildLoadingContent(BuildContext context) {
    final spinner = _buildLoadingSpinner(context);
    
    if (type == AppButtonType.icon || text.isEmpty) {
      return spinner;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        spinner,
        SizedBox(width: _getIconTextGap()),
        Text(text),
      ],
    );
  }

  Widget _buildLoadingSpinner(BuildContext context) {
    final color = _getLoadingSpinnerColor(context);
    return SizedBox(
      width: _getSpinnerSize(),
      height: _getSpinnerSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  // ============================================================================
  // SIZE & STYLE CALCULATIONS
  // ============================================================================

  double _getHeight() {
    switch (size) {
      case AppButtonSize.large:
        return 56.h;
      case AppButtonSize.medium:
        return 48.h;
      case AppButtonSize.small:
        return 40.h;
      case AppButtonSize.tiny:
        return 32.h;
    }
  }

  double _getMinWidth() {
    switch (size) {
      case AppButtonSize.large:
        return 120.w;
      case AppButtonSize.medium:
        return 96.w;
      case AppButtonSize.small:
        return 80.w;
      case AppButtonSize.tiny:
        return 64.w;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case AppButtonSize.tiny:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppButtonSize.large:
        return 12.r;
      case AppButtonSize.medium:
        return 10.r;
      case AppButtonSize.small:
        return 8.r;
      case AppButtonSize.tiny:
        return 6.r;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.large:
        return AppTextStyles.regularBoldNone;
      case AppButtonSize.medium:
        return AppTextStyles.smallBoldNone;
      case AppButtonSize.small:
        return AppTextStyles.tinyBoldNone;
      case AppButtonSize.tiny:
        return AppTextStyles.tinyBoldNone.copyWith(fontSize: 11.sp);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.large:
        return 24.w;
      case AppButtonSize.medium:
        return 20.w;
      case AppButtonSize.small:
        return 18.w;
      case AppButtonSize.tiny:
        return 16.w;
    }
  }

  double _getIconPadding() {
    switch (size) {
      case AppButtonSize.large:
        return 16.w;
      case AppButtonSize.medium:
        return 14.w;
      case AppButtonSize.small:
        return 12.w;
      case AppButtonSize.tiny:
        return 8.w;
    }
  }

  double _getIconTextGap() {
    switch (size) {
      case AppButtonSize.large:
        return 12.w;
      case AppButtonSize.medium:
        return 10.w;
      case AppButtonSize.small:
        return 8.w;
      case AppButtonSize.tiny:
        return 6.w;
    }
  }

  double _getSpinnerSize() {
    switch (size) {
      case AppButtonSize.large:
        return 20.w;
      case AppButtonSize.medium:
        return 18.w;
      case AppButtonSize.small:
        return 16.w;
      case AppButtonSize.tiny:
        return 14.w;
    }
  }

  Color _getLoadingSpinnerColor(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
      case AppButtonType.success:
        return AppColors.skyWhite;
      case AppButtonType.secondary:
      case AppButtonType.text:
      case AppButtonType.icon:
        return AppColors.primary;
    }
  }

  // ============================================================================
  // EVENT HANDLERS
  // ============================================================================

  void _handlePress() {
    if (!isLoading && !isDisabled && onPressed != null) {
      onPressed!();
    }
  }
}

/// 아이콘 위치 열거형
enum AppButtonIconPosition {
  /// 텍스트 앞에 아이콘
  leading,
  
  /// 텍스트 뒤에 아이콘
  trailing,
}

// ============================================================================
// 편의성 생성자들 - 자주 쓰는 패턴들
// ============================================================================

/// 메인 CTA 버튼 (큰 크기, Primary 스타일)
class AppPrimaryButton extends AppButton {
  const AppPrimaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.iconPosition = AppButtonIconPosition.leading,
    super.fullWidth = false,
    super.customWidth,
    super.customHeight,
  }) : super(
         type: AppButtonType.primary,
         size: AppButtonSize.large,
       );
}

/// 보조 버튼 (중간 크기, Secondary 스타일) 
class AppSecondaryButton extends AppButton {
  const AppSecondaryButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.iconPosition = AppButtonIconPosition.leading,
    super.fullWidth = false,
    super.customWidth,
    super.customHeight,
  }) : super(
         type: AppButtonType.secondary,
         size: AppButtonSize.medium,
       );
}

/// 텍스트 링크 버튼
class AppTextButton extends AppButton {
  const AppTextButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.iconPosition = AppButtonIconPosition.leading,
  }) : super(
         type: AppButtonType.text,
         size: AppButtonSize.small,
       );
}

/// 아이콘 버튼 (정사각형)
class AppIconButton extends AppButton {
  const AppIconButton({
    super.key,
    required IconData super.icon,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.size = AppButtonSize.medium,
  }) : super(
         text: '',
         type: AppButtonType.icon,
       );
}

/// 위험한 액션 버튼 (삭제, 로그아웃 등)
class AppDangerButton extends AppButton {
  const AppDangerButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.iconPosition = AppButtonIconPosition.leading,
    super.fullWidth = false,
  }) : super(
         type: AppButtonType.danger,
         size: AppButtonSize.medium,
       );
}

/// 성공 액션 버튼 (완료, 저장 등)
class AppSuccessButton extends AppButton {
  const AppSuccessButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.isLoading = false,
    super.isDisabled = false,
    super.icon,
    super.iconPosition = AppButtonIconPosition.leading,
    super.fullWidth = false,
  }) : super(
         type: AppButtonType.success,
         size: AppButtonSize.medium,
       );
}