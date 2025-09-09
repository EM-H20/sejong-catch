import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 선택 컴포넌트 시스템
/// 세종캐치 앱의 모든 선택 인터랙션을 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppRadioGroup<String>(
///   options: ["옵션1", "옵션2", "옵션3"],
///   value: selectedOption,
///   onChanged: (value) => setState(() => selectedOption = value),
/// )
/// ```

enum AppSelectionSize {
  /// 작은 크기
  small,
  
  /// 중간 크기 (기본)
  medium,
  
  /// 큰 크기
  large,
}

// ============================================================================
// CHECKBOX COMPONENTS
// ============================================================================

/// 기본 체크박스
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.checkColor,
    this.isDisabled = false,
  });

  /// 체크 상태 (null = indeterminate)
  final bool? value;
  
  /// 상태 변경 콜백
  final ValueChanged<bool?>? onChanged;
  
  /// 체크박스 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 체크 마크 색상
  final Color? checkColor;
  
  /// 비활성화 여부
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _getScale(),
      child: Checkbox(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeColor: activeColor ?? AppColors.primary,
        checkColor: checkColor ?? AppColors.skyWhite,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.surfaceVariant(context);
          }
          if (states.contains(WidgetState.selected)) {
            return activeColor ?? AppColors.primary;
          }
          return AppColors.surfaceContainer(context);
        }),
        side: BorderSide(
          color: AppColors.border(context),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  double _getScale() {
    switch (size) {
      case AppSelectionSize.small:
        return 0.8;
      case AppSelectionSize.medium:
        return 1.0;
      case AppSelectionSize.large:
        return 1.2;
    }
  }
}

/// 라벨이 있는 체크박스
class AppLabeledCheckbox extends StatelessWidget {
  const AppLabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.checkColor,
    this.isDisabled = false,
    this.contentPadding,
  });

  /// 라벨 텍스트
  final String label;
  
  /// 체크 상태
  final bool? value;
  
  /// 상태 변경 콜백
  final ValueChanged<bool?>? onChanged;
  
  /// 부제목
  final String? subtitle;
  
  /// 체크박스 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 체크 마크 색상
  final Color? checkColor;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 내부 패딩
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => onChanged?.call(!(value ?? false)),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCheckbox(
              value: value,
              onChanged: onChanged,
              size: size,
              activeColor: activeColor,
              checkColor: checkColor,
              isDisabled: isDisabled,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h), // 체크박스와 텍스트 정렬
                  Text(
                    label,
                    style: _getLabelStyle().copyWith(
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
          ],
        ),
      ),
    );
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case AppSelectionSize.small:
        return AppTextStyles.smallMedium;
      case AppSelectionSize.medium:
        return AppTextStyles.regularMedium;
      case AppSelectionSize.large:
        return AppTextStyles.largeMedium;
    }
  }
}

/// 체크박스 그룹
class AppCheckboxGroup<T> extends StatelessWidget {
  const AppCheckboxGroup({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.title,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.checkColor,
    this.isDisabled = false,
    this.spacing = 8.0,
  });

  /// 선택 옵션들
  final List<AppSelectionOption<T>> options;
  
  /// 현재 선택된 값들
  final Set<T> selectedValues;
  
  /// 선택 변경 콜백
  final ValueChanged<Set<T>>? onChanged;
  
  /// 그룹 제목
  final String? title;
  
  /// 체크박스 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 체크 마크 색상
  final Color? checkColor;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 아이템 간 간격
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.regularBold.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        ...options.map((option) {
          final isSelected = selectedValues.contains(option.value);
          
          return Padding(
            padding: EdgeInsets.only(bottom: spacing.h),
            child: AppLabeledCheckbox(
              label: option.label,
              subtitle: option.subtitle,
              value: isSelected,
              onChanged: (value) => _handleChanged(option.value, value == true),
              size: size,
              activeColor: activeColor,
              checkColor: checkColor,
              isDisabled: isDisabled,
            ),
          );
        }),
      ],
    );
  }

  void _handleChanged(T value, bool isSelected) {
    if (isDisabled) return;
    
    final newSelection = Set<T>.from(selectedValues);
    if (isSelected) {
      newSelection.add(value);
    } else {
      newSelection.remove(value);
    }
    onChanged?.call(newSelection);
  }
}

// ============================================================================
// RADIO COMPONENTS
// ============================================================================

/// 기본 라디오 버튼
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.isDisabled = false,
  });

  /// 이 라디오의 값
  final T value;
  
  /// 현재 그룹에서 선택된 값
  final T? groupValue;
  
  /// 선택 변경 콜백
  final ValueChanged<T?>? onChanged;
  
  /// 라디오 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 비활성화 여부
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _getScale(),
      child: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: isDisabled ? null : onChanged,
        activeColor: activeColor ?? AppColors.primary,
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.textTertiary(context);
          }
          if (states.contains(WidgetState.selected)) {
            return activeColor ?? AppColors.primary;
          }
          return AppColors.border(context);
        }),
      ),
    );
  }

  double _getScale() {
    switch (size) {
      case AppSelectionSize.small:
        return 0.8;
      case AppSelectionSize.medium:
        return 1.0;
      case AppSelectionSize.large:
        return 1.2;
    }
  }
}

/// 라벨이 있는 라디오 버튼
class AppLabeledRadio<T> extends StatelessWidget {
  const AppLabeledRadio({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.subtitle,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.isDisabled = false,
    this.contentPadding,
  });

  /// 라벨 텍스트
  final String label;
  
  /// 이 라디오의 값
  final T value;
  
  /// 현재 그룹에서 선택된 값
  final T? groupValue;
  
  /// 선택 변경 콜백
  final ValueChanged<T?>? onChanged;
  
  /// 부제목
  final String? subtitle;
  
  /// 라디오 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 내부 패딩
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => onChanged?.call(value),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: contentPadding ?? EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppRadio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              size: size,
              activeColor: activeColor,
              isDisabled: isDisabled,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h), // 라디오와 텍스트 정렬
                  Text(
                    label,
                    style: _getLabelStyle().copyWith(
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
          ],
        ),
      ),
    );
  }

  TextStyle _getLabelStyle() {
    switch (size) {
      case AppSelectionSize.small:
        return AppTextStyles.smallMedium;
      case AppSelectionSize.medium:
        return AppTextStyles.regularMedium;
      case AppSelectionSize.large:
        return AppTextStyles.largeMedium;
    }
  }
}

/// 라디오 그룹
class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.title,
    this.size = AppSelectionSize.medium,
    this.activeColor,
    this.isDisabled = false,
    this.spacing = 8.0,
  });

  /// 선택 옵션들
  final List<AppSelectionOption<T>> options;
  
  /// 현재 선택된 값
  final T? value;
  
  /// 선택 변경 콜백
  final ValueChanged<T?>? onChanged;
  
  /// 그룹 제목
  final String? title;
  
  /// 라디오 크기
  final AppSelectionSize size;
  
  /// 활성화 색상
  final Color? activeColor;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 아이템 간 간격
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.regularBold.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        ...options.map((option) {
          return Padding(
            padding: EdgeInsets.only(bottom: spacing.h),
            child: AppLabeledRadio<T>(
              label: option.label,
              subtitle: option.subtitle,
              value: option.value,
              groupValue: value,
              onChanged: onChanged,
              size: size,
              activeColor: activeColor,
              isDisabled: isDisabled,
            ),
          );
        }),
      ],
    );
  }
}

// ============================================================================
// DROPDOWN COMPONENTS
// ============================================================================

/// 기본 드롭다운
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.hint,
    this.label,
    this.helperText,
    this.errorText,
    this.size = AppSelectionSize.medium,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  /// 선택 옵션들
  final List<AppSelectionOption<T>> options;
  
  /// 현재 선택된 값
  final T? value;
  
  /// 선택 변경 콜백
  final ValueChanged<T?>? onChanged;
  
  /// 힌트 텍스트
  final String? hint;
  
  /// 라벨
  final String? label;
  
  /// 도움말 텍스트
  final String? helperText;
  
  /// 에러 텍스트
  final String? errorText;
  
  /// 드롭다운 크기
  final AppSelectionSize size;
  
  /// 비활성화 여부
  final bool isDisabled;
  
  /// 앞쪽 아이콘
  final IconData? prefixIcon;
  
  /// 뒤쪽 아이콘
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDisabled
                ? AppColors.surfaceVariant(context).withValues(alpha: 0.5)
                : AppColors.surfaceVariant(context),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.border(context),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              onChanged: isDisabled ? null : onChanged,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: _getHintStyle().copyWith(
                        color: AppColors.textTertiary(context),
                      ),
                    )
                  : null,
              icon: Icon(
                suffixIcon ?? Icons.keyboard_arrow_down,
                color: AppColors.textSecondary(context),
              ),
              style: _getValueStyle().copyWith(
                color: isDisabled
                    ? AppColors.textTertiary(context)
                    : AppColors.textPrimary(context),
              ),
              dropdownColor: AppColors.surfaceContainer(context),
              borderRadius: BorderRadius.circular(8.r),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              items: options.map((option) {
                return DropdownMenuItem<T>(
                  value: option.value,
                  child: Row(
                    children: [
                      if (prefixIcon != null) ...[
                        Icon(
                          prefixIcon,
                          size: 20.w,
                          color: AppColors.textSecondary(context),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              option.label,
                              style: _getValueStyle().copyWith(
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            if (option.subtitle != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                option.subtitle!,
                                style: AppTextStyles.smallRegular.copyWith(
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                if (errorText != null) ...[
                  Icon(
                    Icons.error_outline,
                    size: 16.w,
                    color: AppColors.error,
                  ),
                  SizedBox(width: 4.w),
                ],
                Expanded(
                  child: Text(
                    errorText ?? helperText!,
                    style: AppTextStyles.tinyRegular.copyWith(
                      color: errorText != null
                          ? AppColors.error
                          : AppColors.textTertiary(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  TextStyle _getHintStyle() {
    switch (size) {
      case AppSelectionSize.small:
        return AppTextStyles.smallRegular;
      case AppSelectionSize.medium:
        return AppTextStyles.regularRegular;
      case AppSelectionSize.large:
        return AppTextStyles.largeRegular;
    }
  }

  TextStyle _getValueStyle() {
    switch (size) {
      case AppSelectionSize.small:
        return AppTextStyles.smallMedium;
      case AppSelectionSize.medium:
        return AppTextStyles.regularMedium;
      case AppSelectionSize.large:
        return AppTextStyles.largeMedium;
    }
  }
}

// ============================================================================
// DATA CLASSES
// ============================================================================

/// 선택 옵션 아이템
class AppSelectionOption<T> {
  const AppSelectionOption({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
  });

  /// 표시될 라벨
  final String label;
  
  /// 실제 값
  final T value;
  
  /// 부제목 (설명)
  final String? subtitle;
  
  /// 아이콘
  final IconData? icon;
}

// ============================================================================
// 편의성 생성자들 - 세종캐치 특화
// ============================================================================

/// 학과 선택 드롭다운
class AppDepartmentDropdown extends AppDropdown<String> {
  AppDepartmentDropdown({
    super.key,
    required super.value,
    required super.onChanged,
  }) : super(
         label: "학과",
         hint: "학과를 선택하세요",
         prefixIcon: Icons.school,
         options: const [
           AppSelectionOption(label: "컴퓨터공학과", value: "computer"),
           AppSelectionOption(label: "소프트웨어학과", value: "software"),
           AppSelectionOption(label: "데이터사이언스학과", value: "datascience"),
           AppSelectionOption(label: "경영학부", value: "business"),
           AppSelectionOption(label: "경제학과", value: "economics"),
           AppSelectionOption(label: "기타", value: "other"),
         ],
       );
}

/// 관심 분야 체크박스 그룹
class AppInterestCheckboxGroup extends AppCheckboxGroup<String> {
  AppInterestCheckboxGroup({
    super.key,
    required super.selectedValues,
    required super.onChanged,
  }) : super(
         title: "관심 분야",
         options: const [
           AppSelectionOption(
             label: "창업/스타트업",
             value: "startup",
             subtitle: "창업 관련 정보",
           ),
           AppSelectionOption(
             label: "취업/인턴",
             value: "job",
             subtitle: "채용 및 인턴십 정보",
           ),
           AppSelectionOption(
             label: "공모전/대회",
             value: "contest",
             subtitle: "각종 공모전 및 경진대회",
           ),
           AppSelectionOption(
             label: "학술/연구",
             value: "research",
             subtitle: "논문, 연구 관련 정보",
           ),
           AppSelectionOption(
             label: "장학금/지원금",
             value: "scholarship",
             subtitle: "장학금 및 각종 지원 정보",
           ),
         ],
       );
}

/// 정렬 방식 라디오 그룹
class AppSortRadioGroup extends AppRadioGroup<String> {
  AppSortRadioGroup({
    super.key,
    required super.value,
    required super.onChanged,
  }) : super(
         title: "정렬 방식",
         options: const [
           AppSelectionOption(label: "추천순", value: "recommended"),
           AppSelectionOption(label: "최신순", value: "latest"),
           AppSelectionOption(label: "마감임박순", value: "deadline"),
           AppSelectionOption(label: "신뢰도순", value: "trust"),
         ],
       );
}