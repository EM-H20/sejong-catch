/// 인증번호 입력 단계 위젯
/// 
/// SMS로 받은 6자리 인증번호를 입력하고 검증하는 단계입니다.
/// 타이머, 재전송, 자동 포맷팅 등의 기능을 제공해요! 🔢
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../services/validation_service.dart';

/// 인증번호 입력 단계 위젯
class VerificationStepWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onVerify;
  final VoidCallback? onResend;
  final bool isLoading;
  final bool enabled;
  final bool autofocus;
  final String? phoneNumber;
  final int remainingSeconds;

  const VerificationStepWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onVerify,
    this.onResend,
    this.isLoading = false,
    this.enabled = true,
    this.autofocus = false,
    this.phoneNumber,
    this.remainingSeconds = 180,
  });

  @override
  State<VerificationStepWidget> createState() => _VerificationStepWidgetState();
}

class _VerificationStepWidgetState extends State<VerificationStepWidget> {
  String? _errorMessage;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    
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

  void _onTextChanged() {
    final text = widget.controller.text;
    
    if (_showValidation) {
      _validateInput(text, showError: false);
    }
    
    // 6자리 입력되면 자동 검증
    if (text.length == 6) {
      _handleVerify();
    }
  }

  bool _validateInput(String value, {bool showError = true}) {
    final errorMessage = ValidationService.validateVerificationCode(value);
    
    if (mounted) {
      setState(() {
        _errorMessage = showError ? errorMessage : null;
      });
    }
    
    return errorMessage == null;
  }

  void _handleVerify() {
    setState(() {
      _showValidation = true;
    });
    
    if (_validateInput(widget.controller.text)) {
      widget.onVerify?.call();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 인증번호 입력 필드
        AppTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !widget.isLoading,
          labelText: '인증번호',
          hintText: '6자리 숫자',
          prefixIcon: Icons.lock_outline,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          errorText: _errorMessage,
          maxLength: 6,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onSubmitted: (_) => _handleVerify(),
        ),
        
        SizedBox(height: 16.h),
        
        // 타이머 표시
        if (widget.remainingSeconds > 0)
          Center(
            child: Text(
              '남은 시간: ${_formatTime(widget.remainingSeconds)}',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        
        SizedBox(height: 24.h),
        
        // 인증 완료 버튼
        AppButton.primary(
          text: '인증 완료',
          onPressed: widget.enabled && !widget.isLoading ? _handleVerify : null,
          isLoading: widget.isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
        ),
        
        SizedBox(height: 16.h),
        
        // 재전송 버튼
        Center(
          child: TextButton(
            onPressed: widget.remainingSeconds == 0 ? widget.onResend : null,
            child: Text(
              widget.remainingSeconds > 0 ? '인증번호가 오지 않았나요?' : '인증번호 재전송',
              style: TextStyle(
                fontSize: 14.sp,
                color: widget.remainingSeconds == 0
                    ? AppColors.brandCrimson
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}