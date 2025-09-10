import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 스위치 및 토글 컨트롤 시스템
/// 세종캐치 앱의 모든 on/off 설정을 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppSwitch(
///   value: isDarkMode,
///   onChanged: (value) => setState(() => isDarkMode = value),
/// )
/// ```

enum AppSwitchStyle {
  /// iOS 스타일 스위치 (둥근 토글)
  ios,
  
  /// Material 스타일 스위치
  material,
  
  /// 커스텀 스타일 (Nucleus UI)
  custom,
}

enum AppSwitchSize {
  /// 작은 크기
  small,
  
  /// 중간 크기 (기본)
  medium,
  
  /// 큰 크기  
  large,
}

/// 기본 스위치 컴포넌트
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.style = AppSwitchStyle.custom,
    this.size = AppSwitchSize.medium,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.isDisabled = false,
  });

  /// 스위치 상태 (on/off)
  final bool value;
  
  /// 상태 변경 콜백
  final ValueChanged<bool>? onChanged;
  
  /// 스위치 스타일
  final AppSwitchStyle style;
  
  /// 스위치 크기
  final AppSwitchSize size;
  
  /// 활성화 상태 색상
  final Color? activeColor;
  
  /// 비활성화 상태 색상
  final Color? inactiveColor;
  
  /// 썸 색상
  final Color? thumbColor;
  
  /// 비활성화 여부
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case AppSwitchStyle.ios:
        return _buildIOSSwitch(context);
      case AppSwitchStyle.material:
        return _buildMaterialSwitch(context);
      case AppSwitchStyle.custom:
        return _buildCustomSwitch(context);
    }
  }

  // ============================================================================
  // IOS STYLE SWITCH
  // ============================================================================
  
  Widget _buildIOSSwitch(BuildContext context) {
    return Transform.scale(
      scale: _getIOSScale(),
      child: Switch.adaptive(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeColor: thumbColor ?? AppColors.skyWhite,
        activeTrackColor: activeColor ?? AppColors.themePrimary(context),
        inactiveThumbColor: thumbColor ?? AppColors.skyWhite,
        inactiveTrackColor: inactiveColor ?? AppColors.surfaceVariant(context),
      ),
    );
  }

  // ============================================================================
  // MATERIAL STYLE SWITCH
  // ============================================================================
  
  Widget _buildMaterialSwitch(BuildContext context) {
    return Transform.scale(
      scale: _getMaterialScale(),
      child: Switch(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeColor: thumbColor ?? AppColors.skyWhite,
        activeTrackColor: activeColor ?? AppColors.themePrimary(context),
        inactiveThumbColor: thumbColor ?? AppColors.surfaceVariant(context),
        inactiveTrackColor: inactiveColor ?? AppColors.border(context),
      ),
    );
  }

  // ============================================================================
  // CUSTOM STYLE SWITCH (Nucleus UI)
  // ============================================================================
  
  Widget _buildCustomSwitch(BuildContext context) {
    final trackWidth = _getTrackWidth();
    final trackHeight = _getTrackHeight();
    final thumbSize = _getThumbSize();
    
    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: trackWidth,
        height: trackHeight,
        decoration: BoxDecoration(
          color: value 
              ? (activeColor ?? AppColors.themePrimary(context))
              : (inactiveColor ?? AppColors.surfaceVariant(context)),
          borderRadius: BorderRadius.circular(trackHeight / 2),
          border: value ? null : Border.all(
            color: AppColors.border(context),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value 
                  ? trackWidth - thumbSize - 2.w 
                  : 2.w,
              top: 2.h,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: thumbColor ?? AppColors.skyWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.inkDarkest.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // SIZE CALCULATIONS
  // ============================================================================

  double _getIOSScale() {
    switch (size) {
      case AppSwitchSize.small:
        return 0.8;
      case AppSwitchSize.medium:
        return 1.0;
      case AppSwitchSize.large:
        return 1.2;
    }
  }

  double _getMaterialScale() {
    switch (size) {
      case AppSwitchSize.small:
        return 0.8;
      case AppSwitchSize.medium:
        return 1.0;
      case AppSwitchSize.large:
        return 1.2;
    }
  }

  double _getTrackWidth() {
    switch (size) {
      case AppSwitchSize.small:
        return 40.w;
      case AppSwitchSize.medium:
        return 48.w;
      case AppSwitchSize.large:
        return 56.w;
    }
  }

  double _getTrackHeight() {
    switch (size) {
      case AppSwitchSize.small:
        return 24.h;
      case AppSwitchSize.medium:
        return 28.h;
      case AppSwitchSize.large:
        return 32.h;
    }
  }

  double _getThumbSize() {
    switch (size) {
      case AppSwitchSize.small:
        return 20.w;
      case AppSwitchSize.medium:
        return 24.w;
      case AppSwitchSize.large:
        return 28.w;
    }
  }
}

/// 라벨이 있는 스위치 (ListTile 스타일)
class AppLabeledSwitch extends StatelessWidget {
  const AppLabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.style = AppSwitchStyle.custom,
    this.size = AppSwitchSize.medium,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.isDisabled = false,
    this.contentPadding,
  });

  /// 메인 라벨
  final String label;
  
  /// 스위치 상태
  final bool value;
  
  /// 상태 변경 콜백
  final ValueChanged<bool>? onChanged;
  
  /// 부제목 (설명)
  final String? subtitle;
  
  /// 스위치 스타일
  final AppSwitchStyle style;
  
  /// 스위치 크기
  final AppSwitchSize size;
  
  /// 활성화 상태 색상
  final Color? activeColor;
  
  /// 비활성화 상태 색상
  final Color? inactiveColor;
  
  /// 썸 색상
  final Color? thumbColor;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 내부 패딩
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.regularMedium.copyWith(
                      color: isDisabled
                          ? AppColors.textTertiary(context)
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.smallRegular.copyWith(
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 16.w),
            AppSwitch(
              value: value,
              onChanged: onChanged,
              style: style,
              size: size,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              thumbColor: thumbColor,
              isDisabled: isDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

/// 토글 버튼 (on/off 텍스트가 있는 버튼)
class AppToggleButton extends StatelessWidget {
  const AppToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.onText = "ON",
    this.offText = "OFF",
    this.size = AppSwitchSize.medium,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.isDisabled = false,
  });

  /// 토글 상태
  final bool value;
  
  /// 상태 변경 콜백
  final ValueChanged<bool>? onChanged;
  
  /// ON 상태 텍스트
  final String onText;
  
  /// OFF 상태 텍스트
  final String offText;
  
  /// 토글 크기
  final AppSwitchSize size;
  
  /// 활성화 상태 색상
  final Color? activeColor;
  
  /// 비활성화 상태 색상
  final Color? inactiveColor;
  
  /// 활성화 상태 텍스트 색상
  final Color? activeTextColor;
  
  /// 비활성화 상태 텍스트 색상
  final Color? inactiveTextColor;
  
  /// 비활성화 여부
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: value
              ? (activeColor ?? AppColors.themePrimary(context))
              : (inactiveColor ?? AppColors.surfaceVariant(context)),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: value ? null : Border.all(
            color: AppColors.border(context),
            width: 1,
          ),
        ),
        child: Text(
          value ? onText : offText,
          style: _getTextStyle().copyWith(
            color: value
                ? (activeTextColor ?? AppColors.skyWhite)
                : (inactiveTextColor ?? AppColors.textSecondary(context)),
          ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppSwitchSize.small:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
      case AppSwitchSize.medium:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case AppSwitchSize.large:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppSwitchSize.small:
        return 6.r;
      case AppSwitchSize.medium:
        return 8.r;
      case AppSwitchSize.large:
        return 10.r;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppSwitchSize.small:
        return AppTextStyles.tinyBold;
      case AppSwitchSize.medium:
        return AppTextStyles.smallBold;
      case AppSwitchSize.large:
        return AppTextStyles.regularBold;
    }
  }
}

/// 분할된 토글 버튼 (좌/우 선택)
class AppSegmentedToggle<T> extends StatelessWidget {
  const AppSegmentedToggle({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.size = AppSwitchSize.medium,
    this.activeColor,
    this.inactiveColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.isDisabled = false,
  });

  /// 선택 옵션들
  final List<AppToggleOption<T>> options;
  
  /// 현재 선택된 값
  final T selectedValue;
  
  /// 선택 변경 콜백
  final ValueChanged<T>? onChanged;
  
  /// 토글 크기
  final AppSwitchSize size;
  
  /// 활성화 상태 색상
  final Color? activeColor;
  
  /// 비활성화 상태 색상
  final Color? inactiveColor;
  
  /// 활성화 상태 텍스트 색상
  final Color? activeTextColor;
  
  /// 비활성화 상태 텍스트 색상
  final Color? inactiveTextColor;
  
  /// 비활성화 여부
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: inactiveColor ?? AppColors.surfaceVariant(context),
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        border: Border.all(
          color: AppColors.border(context),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == selectedValue;
          final isFirst = options.first == option;
          final isLast = options.last == option;
          
          return Expanded(
            child: GestureDetector(
              onTap: isDisabled ? null : () => onChanged?.call(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: _getPadding(),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (activeColor ?? AppColors.themePrimary(context))
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isFirst ? _getBorderRadius() : 0),
                    bottomLeft: Radius.circular(isFirst ? _getBorderRadius() : 0),
                    topRight: Radius.circular(isLast ? _getBorderRadius() : 0),
                    bottomRight: Radius.circular(isLast ? _getBorderRadius() : 0),
                  ),
                ),
                child: Text(
                  option.label,
                  style: _getTextStyle().copyWith(
                    color: isSelected
                        ? (activeTextColor ?? AppColors.skyWhite)
                        : (inactiveTextColor ?? AppColors.textSecondary(context)),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppSwitchSize.small:
        return EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h);
      case AppSwitchSize.medium:
        return EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
      case AppSwitchSize.large:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppSwitchSize.small:
        return 6.r;
      case AppSwitchSize.medium:
        return 8.r;
      case AppSwitchSize.large:
        return 10.r;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppSwitchSize.small:
        return AppTextStyles.tinyMedium;
      case AppSwitchSize.medium:
        return AppTextStyles.smallMedium;
      case AppSwitchSize.large:
        return AppTextStyles.regularMedium;
    }
  }
}

// ============================================================================
// DATA CLASSES
// ============================================================================

/// 토글 옵션 아이템
class AppToggleOption<T> {
  const AppToggleOption({
    required this.label,
    required this.value,
  });

  /// 표시될 라벨
  final String label;
  
  /// 실제 값
  final T value;
}

// ============================================================================
// 편의성 생성자들
// ============================================================================

/// 설정 페이지용 라벨드 스위치
class AppSettingSwitch extends AppLabeledSwitch {
  const AppSettingSwitch({
    super.key,
    required super.label,
    required super.value,
    required super.onChanged,
    super.subtitle,
  }) : super(
         style: AppSwitchStyle.custom,
         size: AppSwitchSize.medium,
       );
}

/// 다크모드 토글
class AppDarkModeToggle extends AppLabeledSwitch {
  const AppDarkModeToggle({
    super.key,
    required super.value,
    required super.onChanged,
  }) : super(
         label: "다크 모드",
         subtitle: "어두운 테마를 사용합니다",
         style: AppSwitchStyle.custom,
         size: AppSwitchSize.medium,
       );
}

/// 알림 설정 토글
class AppNotificationToggle extends AppLabeledSwitch {
  const AppNotificationToggle({
    super.key,
    required super.value,
    required super.onChanged,
    super.subtitle = "새로운 정보가 있을 때 알려드립니다",
  }) : super(
         label: "알림 허용",
         style: AppSwitchStyle.custom,
         size: AppSwitchSize.medium,
       );
}