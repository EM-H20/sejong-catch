import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Nucleus UI 기반 통합 텍스트 입력 필드
/// 세종캐치 앱의 모든 텍스트 입력을 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppTextField(
///   label: "이메일",
///   hintText: "your@email.com",
///   onChanged: (value) => setState(() => email = value),
/// )
/// ```
enum AppTextFieldType {
  /// 기본 텍스트 입력
  text,
  
  /// 이메일 입력
  email,
  
  /// 비밀번호 입력
  password,
  
  /// 숫자 입력
  number,
  
  /// 전화번호 입력
  phone,
  
  /// 검색 입력
  search,
  
  /// 여러 줄 입력
  multiline,
  
  /// URL 입력
  url,
}

enum AppTextFieldVariant {
  /// 기본 스타일 (배경 채움)
  filled,
  
  /// 테두리만 있는 스타일
  outlined,
  
  /// 밑줄만 있는 스타일
  underlined,
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.type = AppTextFieldType.text,
    this.variant = AppTextFieldVariant.filled,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.isRequired = false,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.obscureText,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onFocusChanged,
    this.focusNode,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  /// 텍스트 컨트롤러
  final TextEditingController? controller;
  
  /// 초기값 (controller 없을 때 사용)
  final String? initialValue;
  
  /// 입력 필드 타입
  final AppTextFieldType type;
  
  /// 스타일 변형
  final AppTextFieldVariant variant;
  
  /// 라벨 텍스트
  final String? label;
  
  /// 힌트 텍스트 (플레이스홀더)
  final String? hintText;
  
  /// 도움말 텍스트
  final String? helperText;
  
  /// 에러 텍스트
  final String? errorText;
  
  /// 앞쪽 아이콘
  final IconData? prefixIcon;
  
  /// 뒤쪽 아이콘
  final IconData? suffixIcon;
  
  /// 앞쪽 텍스트 (화폐 기호 등)
  final String? prefixText;
  
  /// 뒤쪽 텍스트 (단위 등)
  final String? suffixText;
  
  /// 최대 글자 수
  final int? maxLength;
  
  /// 최대 줄 수
  final int? maxLines;
  
  /// 최소 줄 수
  final int? minLines;
  
  /// 필수 입력 여부
  final bool isRequired;
  
  /// 읽기 전용 여부
  final bool isReadOnly;
  
  /// 활성화 여부
  final bool isEnabled;
  
  /// 텍스트 숨김 여부 (비밀번호용)
  final bool? obscureText;
  
  /// 대소문자 자동 변환
  final TextCapitalization textCapitalization;
  
  /// 키보드 타입 (타입에서 자동 결정되지만 오버라이드 가능)
  final TextInputType? keyboardType;
  
  /// 텍스트 입력 액션
  final TextInputAction? textInputAction;
  
  /// 입력 포맷터들
  final List<TextInputFormatter>? inputFormatters;
  
  /// 유효성 검사 함수
  final String? Function(String?)? validator;
  
  /// 텍스트 변경 콜백
  final ValueChanged<String>? onChanged;
  
  /// 텍스트 제출 콜백
  final ValueChanged<String>? onSubmitted;
  
  /// 탭 콜백
  final VoidCallback? onTap;
  
  /// 포커스 변경 콜백
  final ValueChanged<bool>? onFocusChanged;
  
  /// 포커스 노드
  final FocusNode? focusNode;
  
  /// 자동 포커스 여부
  final bool autofocus;
  
  /// 자동 교정 여부
  final bool autocorrect;
  
  /// 추천 단어 사용 여부
  final bool enableSuggestions;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    
    // 포커스 노드 초기화
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    
    // 컨트롤러 초기화
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    
    // 비밀번호 타입인 경우 obscure 설정
    _obscureText = widget.obscureText ?? (widget.type == AppTextFieldType.password);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    widget.onFocusChanged?.call(_isFocused);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) _buildLabel(context),
        if (widget.label != null) SizedBox(height: 8.h),
        _buildTextField(context),
        if (widget.helperText != null || widget.errorText != null)
          SizedBox(height: 4.h),
        if (widget.helperText != null || widget.errorText != null)
          _buildHelperText(context),
      ],
    );
  }

  Widget _buildLabel(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.label!,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textPrimary(context),
        ),
        children: [
          if (widget.isRequired)
            TextSpan(
              text: ' *',
              style: AppTextStyles.label.copyWith(
                color: AppColors.error,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    switch (widget.variant) {
      case AppTextFieldVariant.filled:
        return _buildFilledTextField(context);
      case AppTextFieldVariant.outlined:
        return _buildOutlinedTextField(context);
      case AppTextFieldVariant.underlined:
        return _buildUnderlinedTextField(context);
    }
  }

  Widget _buildFilledTextField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isEnabled
            ? AppColors.surfaceVariant(context)
            : AppColors.surfaceVariant(context).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _getBorderColor(context),
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,
        obscureText: _obscureText,
        autofocus: widget.autofocus,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        textCapitalization: widget.textCapitalization,
        keyboardType: _getKeyboardType(),
        textInputAction: widget.textInputAction ?? _getDefaultTextInputAction(),
        inputFormatters: widget.inputFormatters ?? _getDefaultInputFormatters(),
        maxLength: widget.maxLength,
        maxLines: _getMaxLines(),
        minLines: widget.minLines,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        style: AppTextStyles.regularRegular.copyWith(
          color: widget.isEnabled
              ? AppColors.textPrimary(context)
              : AppColors.textTertiary(context),
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.hint.copyWith(
            color: AppColors.textTertiary(context),
          ),
          prefixIcon: _buildPrefixIcon(context),
          suffixIcon: _buildSuffixIcon(context),
          prefixText: widget.prefixText,
          suffixText: widget.suffixText,
          prefixStyle: AppTextStyles.regularRegular.copyWith(
            color: AppColors.textSecondary(context),
          ),
          suffixStyle: AppTextStyles.regularRegular.copyWith(
            color: AppColors.textSecondary(context),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          counterStyle: AppTextStyles.tinyRegular.copyWith(
            color: AppColors.textTertiary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedTextField(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      obscureText: _obscureText,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      textCapitalization: widget.textCapitalization,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction ?? _getDefaultTextInputAction(),
      inputFormatters: widget.inputFormatters ?? _getDefaultInputFormatters(),
      maxLength: widget.maxLength,
      maxLines: _getMaxLines(),
      minLines: widget.minLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style: AppTextStyles.regularRegular.copyWith(
        color: widget.isEnabled
            ? AppColors.textPrimary(context)
            : AppColors.textTertiary(context),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.hint.copyWith(
          color: AppColors.textTertiary(context),
        ),
        prefixIcon: _buildPrefixIcon(context),
        suffixIcon: _buildSuffixIcon(context),
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        prefixStyle: AppTextStyles.regularRegular.copyWith(
          color: AppColors.textSecondary(context),
        ),
        suffixStyle: AppTextStyles.regularRegular.copyWith(
          color: AppColors.textSecondary(context),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.border(context),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.border(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.5),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        counterStyle: AppTextStyles.tinyRegular.copyWith(
          color: AppColors.textTertiary(context),
        ),
      ),
    );
  }

  Widget _buildUnderlinedTextField(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      enabled: widget.isEnabled,
      readOnly: widget.isReadOnly,
      obscureText: _obscureText,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      textCapitalization: widget.textCapitalization,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction ?? _getDefaultTextInputAction(),
      inputFormatters: widget.inputFormatters ?? _getDefaultInputFormatters(),
      maxLength: widget.maxLength,
      maxLines: _getMaxLines(),
      minLines: widget.minLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style: AppTextStyles.regularRegular.copyWith(
        color: widget.isEnabled
            ? AppColors.textPrimary(context)
            : AppColors.textTertiary(context),
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.hint.copyWith(
          color: AppColors.textTertiary(context),
        ),
        prefixIcon: _buildPrefixIcon(context),
        suffixIcon: _buildSuffixIcon(context),
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        prefixStyle: AppTextStyles.regularRegular.copyWith(
          color: AppColors.textSecondary(context),
        ),
        suffixStyle: AppTextStyles.regularRegular.copyWith(
          color: AppColors.textSecondary(context),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.border(context),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.border(context),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.5),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0.w,
          vertical: 8.h,
        ),
        counterStyle: AppTextStyles.tinyRegular.copyWith(
          color: AppColors.textTertiary(context),
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon(BuildContext context) {
    if (widget.prefixIcon == null) return null;
    
    return Icon(
      widget.prefixIcon,
      size: 20.w,
      color: _isFocused
          ? AppColors.primary
          : AppColors.textSecondary(context),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    // 비밀번호 타입인 경우 보기/숨기기 버튼 표시
    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          size: 20.w,
          color: AppColors.textSecondary(context),
        ),
        splashRadius: 20,
      );
    }
    
    // 검색 타입인 경우 검색 버튼 또는 클리어 버튼
    if (widget.type == AppTextFieldType.search) {
      if (_controller.text.isNotEmpty) {
        return IconButton(
          onPressed: () {
            _controller.clear();
            widget.onChanged?.call('');
          },
          icon: Icon(
            Icons.clear,
            size: 20.w,
            color: AppColors.textSecondary(context),
          ),
          splashRadius: 20,
        );
      } else {
        return Icon(
          Icons.search,
          size: 20.w,
          color: AppColors.textSecondary(context),
        );
      }
    }
    
    // 커스텀 아이콘이 있는 경우
    if (widget.suffixIcon != null) {
      return Icon(
        widget.suffixIcon,
        size: 20.w,
        color: _isFocused
            ? AppColors.primary
            : AppColors.textSecondary(context),
      );
    }
    
    return null;
  }

  Widget _buildHelperText(BuildContext context) {
    final hasError = widget.errorText != null;
    final text = hasError ? widget.errorText! : widget.helperText!;
    final color = hasError
        ? AppColors.error
        : AppColors.textTertiary(context);
    
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 4.h),
      child: Row(
        children: [
          if (hasError)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Icon(
                Icons.error_outline,
                size: 16.w,
                color: color,
              ),
            ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.tinyRegular.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(BuildContext context) {
    if (widget.errorText != null) {
      return AppColors.error;
    }
    if (_isFocused) {
      return AppColors.primary;
    }
    return AppColors.border(context);
  }

  TextInputType _getKeyboardType() {
    if (widget.keyboardType != null) return widget.keyboardType!;
    
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.password:
        return TextInputType.visiblePassword;
      case AppTextFieldType.number:
        return TextInputType.number;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.url:
        return TextInputType.url;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.text:
      case AppTextFieldType.search:
        return TextInputType.text;
    }
  }

  TextInputAction _getDefaultTextInputAction() {
    if (widget.type == AppTextFieldType.multiline) {
      return TextInputAction.newline;
    }
    if (widget.type == AppTextFieldType.search) {
      return TextInputAction.search;
    }
    return TextInputAction.done;
  }

  List<TextInputFormatter>? _getDefaultInputFormatters() {
    switch (widget.type) {
      case AppTextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case AppTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          PhoneNumberFormatter(),
        ];
      case AppTextFieldType.email:
        return [FilteringTextInputFormatter.deny(RegExp(r'\s'))]; // 공백 제거
      default:
        return null;
    }
  }

  int? _getMaxLines() {
    if (widget.type == AppTextFieldType.multiline) {
      return widget.maxLines ?? 4;
    }
    return widget.maxLines ?? 1;
  }
}

/// 전화번호 포맷터 (010-1234-5678 형식)
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (text.length <= 3) {
      return newValue.copyWith(text: text);
    } else if (text.length <= 7) {
      return newValue.copyWith(
        text: '${text.substring(0, 3)}-${text.substring(3)}',
      );
    } else if (text.length <= 11) {
      return newValue.copyWith(
        text: '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}',
      );
    } else {
      return oldValue;
    }
  }
}

// ============================================================================
// 편의성 생성자들 - 자주 쓰는 패턴들
// ============================================================================

/// 검색 입력 필드
class AppSearchField extends AppTextField {
  const AppSearchField({
    super.key,
    super.controller,
    super.hintText = "검색어를 입력하세요",
    super.onChanged,
    super.onSubmitted,
  }) : super(
         type: AppTextFieldType.search,
         variant: AppTextFieldVariant.filled,
         prefixIcon: Icons.search,
       );
}

/// 이메일 입력 필드
class AppEmailField extends AppTextField {
  const AppEmailField({
    super.key,
    super.controller,
    super.label = "이메일",
    super.hintText = "your@email.com",
    super.onChanged,
    super.validator,
    super.isRequired = false,
  }) : super(
         type: AppTextFieldType.email,
         prefixIcon: Icons.email_outlined,
         keyboardType: TextInputType.emailAddress,
         autocorrect: false,
       );
}

/// 비밀번호 입력 필드
class AppPasswordField extends AppTextField {
  const AppPasswordField({
    super.key,
    super.controller,
    super.label = "비밀번호",
    super.hintText = "비밀번호를 입력하세요",
    super.onChanged,
    super.validator,
    super.isRequired = false,
  }) : super(
         type: AppTextFieldType.password,
         prefixIcon: Icons.lock_outline,
         obscureText: true,
       );
}

/// 전화번호 입력 필드
class AppPhoneField extends AppTextField {
  const AppPhoneField({
    super.key,
    super.controller,
    super.label = "전화번호",
    super.hintText = "010-1234-5678",
    super.onChanged,
    super.validator,
    super.isRequired = false,
  }) : super(
         type: AppTextFieldType.phone,
         prefixIcon: Icons.phone_outlined,
         keyboardType: TextInputType.phone,
       );
}

/// 여러 줄 텍스트 입력 필드
class AppTextArea extends AppTextField {
  const AppTextArea({
    super.key,
    super.controller,
    super.label,
    super.hintText = "내용을 입력하세요",
    super.onChanged,
    super.validator,
    super.maxLines = 4,
    super.minLines = 3,
    super.maxLength,
  }) : super(
         type: AppTextFieldType.multiline,
         variant: AppTextFieldVariant.outlined,
       );
}