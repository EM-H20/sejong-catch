/// 비밀번호 입력 단계 위젯
/// 
/// 세종대 시스템의 비밀번호를 안전하게 입력받는 단계입니다.
/// 보안성과 사용성을 모두 고려한 디자인으로 구성되어 있어요! 🔐
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../services/validation_service.dart';

/// 비밀번호 입력 단계 위젯
/// 
/// 세종대 시스템의 비밀번호를 입력받고, 로그인을 처리하는 단계입니다.
/// 비밀번호 표시/숨김, 로그인 기억하기 등의 기능을 제공해요.
class PasswordStepWidget extends StatefulWidget {
  /// 비밀번호 컨트롤러
  final TextEditingController controller;

  /// 포커스 노드
  final FocusNode focusNode;

  /// 로그인 버튼 콜백
  final VoidCallback? onLogin;

  /// 로딩 상태
  final bool isLoading;

  /// 활성화 상태
  final bool enabled;

  /// 자동 포커스 여부
  final bool autofocus;

  /// 제출 시 콜백 (Enter 키 등)
  final VoidCallback? onSubmitted;

  /// 입력값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 로그인 기억하기 초기값
  final bool initialRememberMe;

  /// 로그인 기억하기 변경 콜백
  final ValueChanged<bool>? onRememberMeChanged;

  /// 비밀번호 찾기 콜백
  final VoidCallback? onForgotPassword;

  const PasswordStepWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onLogin,
    this.isLoading = false,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
    this.onChanged,
    this.initialRememberMe = false,
    this.onRememberMeChanged,
    this.onForgotPassword,
  });

  @override
  State<PasswordStepWidget> createState() => _PasswordStepWidgetState();
}

class _PasswordStepWidgetState extends State<PasswordStepWidget> {
  String? _errorMessage;
  bool _showValidation = false;
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    
    // 초기값 설정
    _rememberMe = widget.initialRememberMe;
    
    // 컨트롤러 리스너 등록
    widget.controller.addListener(_onTextChanged);
    
    // 자동 포커스
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.enabled) {
          widget.focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  /// 텍스트 변경 이벤트 처리
  void _onTextChanged() {
    final text = widget.controller.text;
    
    // 외부 콜백 호출
    widget.onChanged?.call(text);
    
    // 실시간 검증 (비밀번호는 입력 중에는 검증하지 않음)
    if (_showValidation && _errorMessage != null) {
      // 이전에 오류가 있었다면 다시 검증해서 오류 해제
      _validateInput(text, showError: false);
    }
  }

  /// 입력값 검증
  bool _validateInput(String value, {bool showError = true}) {
    final errorMessage = ValidationService.validatePassword(value);
    
    if (mounted) {
      setState(() {
        _errorMessage = showError ? errorMessage : null;
      });
    }
    
    return errorMessage == null;
  }

  /// 로그인 처리
  void _handleLogin() {
    setState(() {
      _showValidation = true;
    });
    
    if (_validateInput(widget.controller.text)) {
      widget.onLogin?.call();
    } else {
      // 검증 실패 시 필드에 포커스
      widget.focusNode.requestFocus();
    }
  }

  /// 제출 처리 (Enter 키 등)
  void _handleSubmitted() {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!();
    } else {
      _handleLogin();
    }
  }

  /// 로그인 기억하기 토글
  void _handleRememberMeChanged(bool? value) {
    if (value != null) {
      setState(() {
        _rememberMe = value;
      });
      widget.onRememberMeChanged?.call(value);
    }
  }

  /// 비밀번호 표시/숨김 토글
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 비밀번호 입력 필드
        AppTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !widget.isLoading,
          labelText: '비밀번호',
          hintText: '비밀번호를 입력하세요',
          errorText: _errorMessage,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          prefixIcon: Icons.lock_outline,
          suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
          onSuffixIconTap: _togglePasswordVisibility,
          onSubmitted: (_) => _handleSubmitted(),
        ),
        
        SizedBox(height: 16.h),
        
        // 로그인 기억하기 체크박스
        _buildRememberMeCheckbox(),
        
        SizedBox(height: 24.h),
        
        // 로그인 버튼
        AppButton.primary(
          text: '로그인',
          onPressed: widget.enabled && !widget.isLoading ? _handleLogin : null,
          isLoading: widget.isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
        ),
        
        SizedBox(height: 16.h),
        
        // 비밀번호 찾기 버튼
        _buildForgotPasswordButton(),
        
        SizedBox(height: 16.h),
        
        // 보안 안내
        _buildSecurityNotice(),
      ],
    );
  }

  /// 로그인 기억하기 체크박스
  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Checkbox(
            value: _rememberMe,
            onChanged: widget.enabled && !widget.isLoading 
                ? _handleRememberMeChanged 
                : null,
            activeColor: AppColors.brandCrimson,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: widget.enabled && !widget.isLoading
                ? () => _handleRememberMeChanged(!_rememberMe)
                : null,
            child: Text(
              '로그인 상태 유지',
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.enabled && !widget.isLoading
                    ? AppColors.textSecondary
                    : AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 비밀번호 찾기 버튼
  Widget _buildForgotPasswordButton() {
    return Center(
      child: TextButton(
        onPressed: widget.onForgotPassword ?? _handleForgotPassword,
        child: Text(
          '비밀번호를 잊으셨나요?',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.brandCrimson,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 기본 비밀번호 찾기 처리
  void _handleForgotPassword() {
    UiUtils.showErrorSnackBar(
      context,
      '비밀번호 찾기 기능은 곧 추가될 예정입니다! 🔧',
    );
  }

  /// 보안 안내 위젯
  Widget _buildSecurityNotice() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.divider,
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.security,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '보안 안내',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '공용 컴퓨터에서는 "로그인 상태 유지"를 체크하지 마세요.\n'
                  '로그인 후 꼭 로그아웃 해주세요.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 비밀번호 강도 표시 위젯
/// 
/// 비밀번호의 보안 강도를 시각적으로 보여주는 위젯입니다.
/// 회원가입이나 비밀번호 변경 시에 유용해요.
class PasswordStrengthIndicator extends StatelessWidget {
  /// 비밀번호 문자열
  final String password;

  /// 표시 여부
  final bool show;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final strength = _calculatePasswordStrength(password);
    final strengthInfo = _getStrengthInfo(strength);

    return AnimatedOpacity(
      opacity: show && password.isNotEmpty ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비밀번호 강도: ${strengthInfo['label']}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: strengthInfo['color'],
              ),
            ),
            SizedBox(height: 4.h),
            _buildStrengthBar(strength, strengthInfo['color']),
          ],
        ),
      ),
    );
  }

  /// 비밀번호 강도 계산 (0-4)
  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // 길이 점수
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // 문자 구성 점수
    if (RegExp(r'[a-z]').hasMatch(password)) score++; // 소문자
    if (RegExp(r'[A-Z]').hasMatch(password)) score++; // 대문자
    if (RegExp(r'[0-9]').hasMatch(password)) score++; // 숫자
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++; // 특수문자

    // 점수 정규화 (최대 4)
    return score > 4 ? 4 : score;
  }

  /// 강도별 정보
  Map<String, dynamic> _getStrengthInfo(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return {'label': '약함', 'color': AppColors.error};
      case 2:
        return {'label': '보통', 'color': Colors.orange};
      case 3:
        return {'label': '강함', 'color': Colors.yellow[700]};
      case 4:
        return {'label': '매우 강함', 'color': AppColors.success};
      default:
        return {'label': '약함', 'color': AppColors.error};
    }
  }

  /// 강도 바 위젯
  Widget _buildStrengthBar(int strength, Color color) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index < strength;
        return Expanded(
          child: Container(
            height: 4.h,
            margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
            decoration: BoxDecoration(
              color: isActive ? color : AppColors.surface,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}

/// 비밀번호 입력 도움말 위젯
/// 
/// 비밀번호 입력 시 필요한 규칙이나 도움말을 표시하는 위젯입니다.
class PasswordHelpText extends StatelessWidget {
  /// 표시 여부
  final bool show;

  /// 커스텀 도움말 텍스트
  final String? customText;

  const PasswordHelpText({
    super.key,
    this.show = true,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.help_outline,
            size: 16.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              customText ?? _getDefaultHelpText(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDefaultHelpText() {
    return '세종대 포털시스템과 동일한 비밀번호를 입력해주세요.\n'
           '비밀번호가 기억나지 않으시면 "비밀번호 찾기"를 이용하세요.';
  }
}