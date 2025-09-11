import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

/// 세종 캐치 앱의 표준 텍스트 입력 필드
/// 
/// 통일된 디자인과 검증 기능을 제공하며,
/// 접근성과 사용성을 보장합니다.
class AppTextField extends StatefulWidget {
  /// 텍스트 컨트롤러
  final TextEditingController? controller;
  
  /// 라벨 텍스트
  final String? labelText;
  
  /// 힌트 텍스트
  final String? hintText;
  
  /// 헬퍼 텍스트 (도움말)
  final String? helperText;
  
  /// 에러 텍스트
  final String? errorText;
  
  /// 유효성 검증 함수
  final String? Function(String?)? validator;
  
  /// 텍스트 변경 콜백
  final ValueChanged<String>? onChanged;
  
  /// 포커스 상실 콜백
  final VoidCallback? onEditingComplete;
  
  /// 엔터키 누름 콜백
  final ValueChanged<String>? onSubmitted;
  
  /// 최대 글자 수
  final int? maxLength;
  
  /// 최대 줄 수 (null이면 한 줄)
  final int? maxLines;
  
  /// 최소 줄 수
  final int? minLines;
  
  /// 비밀번호 필드 여부
  final bool obscureText;
  
  /// 읽기 전용 여부
  final bool readOnly;
  
  /// 활성화 여부
  final bool enabled;
  
  /// 자동 포커스 여부
  final bool autofocus;
  
  /// 키보드 타입
  final TextInputType keyboardType;
  
  /// 텍스트 입력 액션
  final TextInputAction textInputAction;
  
  /// 텍스트 정렬
  final TextAlign textAlign;
  
  /// 텍스트 방향
  final TextDirection? textDirection;
  
  /// 입력 포맷터
  final List<TextInputFormatter>? inputFormatters;
  
  /// 자동 완성 힌트
  final Iterable<String>? autofillHints;
  
  /// 접두사 아이콘
  final IconData? prefixIcon;
  
  /// 접미사 아이콘
  final IconData? suffixIcon;
  
  /// 접미사 아이콘 클릭 콜백
  final VoidCallback? onSuffixIconTap;
  
  /// 필드 스타일
  final AppTextFieldStyle style;
  
  /// 커스텀 배경색
  final Color? backgroundColor;
  
  /// 커스텀 테두리 색상
  final Color? borderColor;
  
  /// 포커스 노드
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.style = AppTextFieldStyle.filled,
    this.backgroundColor,
    this.borderColor,
    this.focusNode,
  });

  /// 이메일 입력 필드 생성자
  const AppTextField.email({
    super.key,
    this.controller,
    this.labelText = '이메일',
    this.hintText = '이메일을 입력하세요',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.style = AppTextFieldStyle.filled,
    this.backgroundColor,
    this.borderColor,
    this.focusNode,
  }) : 
    maxLines = 1,
    minLines = null,
    obscureText = false,
    keyboardType = TextInputType.emailAddress,
    textInputAction = TextInputAction.next,
    autofillHints = const [AutofillHints.email],
    prefixIcon = Icons.email,
    suffixIcon = null,
    onSuffixIconTap = null;

  /// 비밀번호 입력 필드 생성자
  const AppTextField.password({
    super.key,
    this.controller,
    this.labelText = '비밀번호',
    this.hintText = '비밀번호를 입력하세요',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.style = AppTextFieldStyle.filled,
    this.backgroundColor,
    this.borderColor,
    this.focusNode,
    bool showPasswordToggle = true,
  }) : 
    maxLines = 1,
    minLines = null,
    obscureText = true,
    keyboardType = TextInputType.visiblePassword,
    textInputAction = TextInputAction.done,
    autofillHints = const [AutofillHints.password],
    prefixIcon = Icons.lock,
    suffixIcon = showPasswordToggle ? Icons.visibility : null,
    onSuffixIconTap = null; // 실제로는 상태 관리가 필요

  /// 검색 입력 필드 생성자
  const AppTextField.search({
    super.key,
    this.controller,
    this.labelText,
    this.hintText = '검색어를 입력하세요',
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.backgroundColor,
    this.borderColor,
    this.focusNode,
  }) : 
    maxLines = 1,
    minLines = null,
    obscureText = false,
    keyboardType = TextInputType.text,
    textInputAction = TextInputAction.search,
    autofillHints = null,
    prefixIcon = Icons.search,
    suffixIcon = Icons.clear,
    onSuffixIconTap = null,
    style = AppTextFieldStyle.outlined;

  /// 다중 줄 텍스트 입력 필드 생성자
  const AppTextField.multiline({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.maxLines = 5,
    this.minLines = 3,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.style = AppTextFieldStyle.filled,
    this.backgroundColor,
    this.borderColor,
    this.focusNode,
  }) : 
    obscureText = false,
    keyboardType = TextInputType.multiline,
    textInputAction = TextInputAction.newline;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    widget.controller?.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 (filled 스타일일 때만 외부에 표시)
        if (widget.labelText != null && widget.style == AppTextFieldStyle.filled) ...[
          Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        
        // 텍스트 필드
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onSubmitted,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          style: TextStyle(
            fontSize: 16.sp,
            color: widget.enabled ? AppColors.textPrimary : AppColors.textSecondary,
            height: 1.4,
          ),
          decoration: _buildInputDecoration(),
        ),
        
        // 헬퍼 텍스트
        if (widget.helperText != null) ...[
          SizedBox(height: 4.h),
          Text(
            widget.helperText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final hasError = widget.errorText != null;
    
    return InputDecoration(
      labelText: widget.style == AppTextFieldStyle.outlined ? widget.labelText : null,
      hintText: widget.hintText,
      errorText: widget.errorText,
      
      // 글자 수 카운터 (maxLength가 있을 때만)
      counterText: widget.maxLength != null ? '' : null,
      
      // 아이콘들
      prefixIcon: widget.prefixIcon != null ? _buildPrefixIcon() : null,
      suffixIcon: _buildSuffixIcon(),
      
      // 스타일별 데코레이션
      filled: widget.style == AppTextFieldStyle.filled,
      fillColor: widget.backgroundColor ?? _getFillColor(),
      
      // 테두리 스타일
      border: _getBorder(isError: false, isFocused: false),
      enabledBorder: _getBorder(isError: hasError, isFocused: false),
      focusedBorder: _getBorder(isError: hasError, isFocused: true),
      errorBorder: _getBorder(isError: true, isFocused: false),
      focusedErrorBorder: _getBorder(isError: true, isFocused: true),
      disabledBorder: _getBorder(isError: false, isFocused: false, isDisabled: true),
      
      // 패딩
      contentPadding: _getContentPadding(),
      
      // 라벨 스타일
      labelStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.textSecondary,
      ),
      floatingLabelStyle: TextStyle(
        fontSize: 14.sp,
        color: _isFocused ? AppColors.brandCrimson : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      
      // 힌트 스타일
      hintStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      ),
      
      // 에러 스타일
      errorStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.error,
      ),
      
      // 헬퍼 스타일
      helperStyle: TextStyle(
        fontSize: 12.sp,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildPrefixIcon() {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 8.w),
      child: Icon(
        widget.prefixIcon,
        size: 20.w,
        color: _isFocused ? AppColors.brandCrimson : AppColors.textSecondary,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon == null) return null;
    
    VoidCallback? onTap;
    IconData icon = widget.suffixIcon!;
    
    // 비밀번호 토글 아이콘
    if (widget.obscureText && widget.suffixIcon == Icons.visibility) {
      icon = _obscureText ? Icons.visibility : Icons.visibility_off;
      onTap = _togglePasswordVisibility;
    }
    // 텍스트 클리어 아이콘
    else if (widget.suffixIcon == Icons.clear) {
      final hasText = widget.controller?.text.isNotEmpty ?? false;
      if (!hasText) return null;
      onTap = _clearText;
    }
    // 커스텀 콜백
    else {
      onTap = widget.onSuffixIconTap;
    }
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8.w, right: 16.w),
        child: Icon(
          icon,
          size: 20.w,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Color _getFillColor() {
    if (!widget.enabled) {
      return AppColors.disabled.withValues(alpha: 0.1);
    }
    
    return AppColors.surface;
  }

  EdgeInsets _getContentPadding() {
    switch (widget.style) {
      case AppTextFieldStyle.filled:
        return EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        );
      case AppTextFieldStyle.outlined:
        return EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        );
      case AppTextFieldStyle.underlined:
        return EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 16.h,
        );
    }
  }

  InputBorder _getBorder({
    required bool isError,
    required bool isFocused,
    bool isDisabled = false,
  }) {
    Color borderColor;
    double borderWidth;
    
    if (isError) {
      borderColor = AppColors.error;
      borderWidth = 2.w;
    } else if (isFocused) {
      borderColor = AppColors.brandCrimson;
      borderWidth = 2.w;
    } else if (isDisabled) {
      borderColor = AppColors.disabled;
      borderWidth = 1.w;
    } else {
      borderColor = widget.borderColor ?? AppColors.divider;
      borderWidth = 1.w;
    }
    
    switch (widget.style) {
      case AppTextFieldStyle.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
        
      case AppTextFieldStyle.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
        
      case AppTextFieldStyle.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: borderWidth),
        );
    }
  }
}

// ============================================================================
// 텍스트 필드 스타일 열거형
// ============================================================================

/// 텍스트 필드 스타일 유형
enum AppTextFieldStyle {
  /// 채워진 배경 스타일 (기본값)
  filled,
  
  /// 테두리만 있는 스타일
  outlined,
  
  /// 밑줄만 있는 스타일
  underlined,
}