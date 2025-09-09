import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/app_config.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum CTAButtonSize {
  small,
  medium,
  large,
}

enum CTAButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

class CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CTAButtonSize size;
  final CTAButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const CTAButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CTAButtonSize.medium,
    this.variant = CTAButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
  });

  // Factory constructors for common use cases
  const CTAButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CTAButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
  }) : variant = CTAButtonVariant.primary;

  const CTAButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CTAButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
  }) : variant = CTAButtonVariant.secondary;

  const CTAButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CTAButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
  }) : variant = CTAButtonVariant.outline;

  const CTAButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = CTAButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
  }) : variant = CTAButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final child = _buildButtonChild();

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: _buildButton(buttonStyle, child),
      );
    }

    return _buildButton(buttonStyle, child);
  }

  Widget _buildButton(ButtonStyle style, Widget child) {
    if (variant == CTAButtonVariant.text) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      );
    } else if (variant == CTAButtonVariant.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      );
    } else {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: child,
      );
    }
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == CTAButtonVariant.primary
                ? AppColors.white
                : AppColors.crimson,
          ),
        ),
      );
    }

    // Icon-only button
    if (icon != null) {
      return Icon(icon, size: _getIconSize());
    }

    // Text with leading/trailing icons
    final List<Widget> children = [];

    if (leadingIcon != null) {
      children.add(Icon(leadingIcon, size: _getIconSize()));
      children.add(SizedBox(width: 8.w));
    }

    children.add(
      Text(
        text,
        style: _getTextStyle(),
        textAlign: TextAlign.center,
      ),
    );

    if (trailingIcon != null) {
      children.add(SizedBox(width: 8.w));
      children.add(Icon(trailingIcon, size: _getIconSize()));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  ButtonStyle _getButtonStyle() {
    final colorScheme = _getColorScheme();
    final padding = _getPadding();
    final minimumSize = _getMinimumSize();

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme['disabledBackground'];
        }
        if (states.contains(WidgetState.pressed)) {
          return colorScheme['pressedBackground'];
        }
        return colorScheme['background'];
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme['disabledForeground'];
        }
        return colorScheme['foreground'];
      }),
      overlayColor: WidgetStateProperty.all(
        colorScheme['foreground']?.withValues(alpha: 0.1),
      ),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (variant == CTAButtonVariant.primary) {
          return states.contains(WidgetState.pressed) ? 1.0 : 2.0;
        }
        return 0.0;
      }),
      shadowColor: WidgetStateProperty.all(
        variant == CTAButtonVariant.primary
            ? AppColors.crimson.withValues(alpha: 0.3)
            : Colors.transparent,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          side: _getBorderSide(colorScheme),
        ),
      ),
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(minimumSize),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  BorderSide _getBorderSide(Map<String, Color?> colorScheme) {
    if (variant == CTAButtonVariant.outline) {
      return BorderSide(color: colorScheme['foreground'] ?? AppColors.crimson);
    }
    return BorderSide.none;
  }

  Map<String, Color?> _getColorScheme() {
    switch (variant) {
      case CTAButtonVariant.primary:
        return {
          'background': AppColors.crimson,
          'foreground': AppColors.white,
          'pressedBackground': AppColors.crimsonDark,
          'disabledBackground': AppColors.buttonDisabled,
          'disabledForeground': AppColors.white,
        };
      case CTAButtonVariant.secondary:
        return {
          'background': AppColors.crimsonLight,
          'foreground': AppColors.crimson,
          'pressedBackground': AppColors.lighten(AppColors.crimsonLight, 0.1),
          'disabledBackground': AppColors.buttonDisabled,
          'disabledForeground': AppColors.white,
        };
      case CTAButtonVariant.outline:
        return {
          'background': Colors.transparent,
          'foreground': AppColors.crimson,
          'pressedBackground': AppColors.crimsonLight.withValues(alpha: 0.1),
          'disabledBackground': Colors.transparent,
          'disabledForeground': AppColors.buttonDisabled,
        };
      case CTAButtonVariant.text:
        return {
          'background': Colors.transparent,
          'foreground': AppColors.crimson,
          'pressedBackground': AppColors.crimsonLight.withValues(alpha: 0.1),
          'disabledBackground': Colors.transparent,
          'disabledForeground': AppColors.buttonDisabled,
        };
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case CTAButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case CTAButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
      case CTAButtonSize.large:
        return EdgeInsets.symmetric(horizontal:20.w, vertical: 16.h);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case CTAButtonSize.small:
        return Size(64.w, 36.h);
      case CTAButtonSize.medium:
        return Size(88.w, AppConfig.minTouchTarget.h);
      case CTAButtonSize.large:
        return Size(120.w, 52.h);
    }
  }

  double _getIconSize() {
    switch (size) {
      case CTAButtonSize.small:
        return 16.w;
      case CTAButtonSize.medium:
        return 18.w;
      case CTAButtonSize.large:
        return 20.w;
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = AppTextStyles.buttonText;
    
    switch (size) {
      case CTAButtonSize.small:
        return baseStyle.copyWith(fontSize: 14.sp);
      case CTAButtonSize.medium:
        return baseStyle.copyWith(fontSize: 16.sp);
      case CTAButtonSize.large:
        return baseStyle.copyWith(fontSize: 18.sp);
    }
  }
}