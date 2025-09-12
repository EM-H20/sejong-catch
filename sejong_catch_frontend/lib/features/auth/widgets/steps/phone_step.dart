/// 전화번호 입력 단계 위젯
/// 
/// 게스트 로그인을 위한 전화번호 입력 단계입니다.
/// 한국 전화번호 형식을 자동으로 포맷팅하고 검증하는 기능을 제공해요! 📱
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../services/validation_service.dart';

/// 전화번호 입력 단계 위젯
/// 
/// 한국 전화번호 (010-0000-0000) 형식으로 입력받는 단계입니다.
/// 자동 포맷팅과 실시간 검증을 제공해요.
class PhoneStepWidget extends StatefulWidget {
  /// 전화번호 컨트롤러
  final TextEditingController controller;

  /// 포커스 노드
  final FocusNode focusNode;

  /// 다음 단계 콜백
  final VoidCallback? onNext;

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

  /// 자동 포맷팅 적용 여부
  final bool autoFormat;

  const PhoneStepWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onNext,
    this.isLoading = false,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
    this.onChanged,
    this.autoFormat = true,
  });

  @override
  State<PhoneStepWidget> createState() => _PhoneStepWidgetState();
}

class _PhoneStepWidgetState extends State<PhoneStepWidget> {
  String? _errorMessage;
  bool _showValidation = false;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    
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
    
    // 자동 포맷팅 적용
    if (widget.autoFormat) {
      _applyAutoFormatting(text);
    }
    
    // 외부 콜백 호출
    widget.onChanged?.call(widget.controller.text);
    
    // 실시간 검증 (입력 중일 때는 너무 엄격하지 않게)
    if (_showValidation) {
      _validateInput(widget.controller.text, showError: false);
    }
  }

  /// 자동 포맷팅 적용
  void _applyAutoFormatting(String input) {
    // 무한 루프 방지
    if (input == _previousText) return;

    final formatted = _formatPhoneNumber(input);
    
    if (formatted != input) {
      final cursorPosition = _calculateCursorPosition(input, formatted);
      
      widget.controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: cursorPosition),
      );
    }
    
    _previousText = formatted;
  }

  /// 전화번호 포맷팅 (010-0000-0000 형식)
  String _formatPhoneNumber(String input) {
    // 숫자만 추출
    final digitsOnly = input.replaceAll(RegExp(r'[^\d]'), '');
    
    // 010으로 시작하지 않는 경우 처리
    if (digitsOnly.isNotEmpty && !digitsOnly.startsWith('010')) {
      // 첫 번째 자리가 0이 아니면 010으로 시작하도록 유도
      if (digitsOnly[0] != '0') {
        return '010$digitsOnly';
      }
    }
    
    // 길이에 따라 포맷팅
    if (digitsOnly.length <= 3) {
      return digitsOnly;
    } else if (digitsOnly.length <= 7) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    } else {
      final end = digitsOnly.length > 11 ? 11 : digitsOnly.length;
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7, end)}';
    }
  }

  /// 커서 위치 계산 (포맷팅 후)
  int _calculateCursorPosition(String original, String formatted) {
    int position = widget.controller.selection.baseOffset;
    
    // 하이픈이 추가된 만큼 위치 조정
    final originalDigits = original.replaceAll(RegExp(r'[^\d]'), '').length;
    final formattedDigits = formatted.replaceAll(RegExp(r'[^\d]'), '').length;
    
    if (originalDigits == formattedDigits) {
      // 숫자 개수가 같으면 하이픈 때문에 위치가 밀릴 수 있음
      int hyphensBefore = 0;
      for (int i = 0; i < position && i < formatted.length; i++) {
        if (formatted[i] == '-') hyphensBefore++;
      }
      position += hyphensBefore;
    }
    
    // 범위 체크
    if (position > formatted.length) position = formatted.length;
    if (position < 0) position = 0;
    
    return position;
  }

  /// 입력값 검증
  bool _validateInput(String value, {bool showError = true}) {
    final errorMessage = ValidationService.validatePhoneNumber(value);
    
    if (mounted) {
      setState(() {
        _errorMessage = showError ? errorMessage : null;
      });
    }
    
    return errorMessage == null;
  }

  /// 다음 단계 처리
  void _handleNext() {
    setState(() {
      _showValidation = true;
    });
    
    if (_validateInput(widget.controller.text)) {
      widget.onNext?.call();
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
      _handleNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 전화번호 입력 필드
        AppTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !widget.isLoading,
          labelText: '전화번호',
          hintText: '010-0000-0000',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          errorText: _errorMessage,
          onSubmitted: (_) => _handleSubmitted(),
          inputFormatters: [
            // 숫자와 하이픈만 허용
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            // 최대 길이 제한 (000-0000-0000)
            LengthLimitingTextInputFormatter(13),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // 입력 도움말
        _buildHelpText(),
        
        SizedBox(height: 24.h),
        
        // 다음 버튼
        AppButton.primary(
          text: '다음',
          onPressed: widget.enabled && !widget.isLoading ? _handleNext : null,
          isLoading: widget.isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
        ),
      ],
    );
  }

  /// 도움말 텍스트 위젯
  Widget _buildHelpText() {
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
            Icons.info_outline,
            size: 16.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '전화번호 입력 안내',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandCrimson,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '• 010으로 시작하는 번호만 입력 가능합니다\n'
                  '• 하이픈은 자동으로 추가됩니다\n'
                  '• SMS 인증을 위해 정확한 번호를 입력해주세요',
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

/// 전화번호 입력 도우미 위젯
/// 
/// 자주 사용되는 전화번호를 빠르게 입력할 수 있는 도우미 기능입니다.
/// 개발/테스트 환경에서 유용해요.
class PhoneNumberHelper extends StatelessWidget {
  /// 전화번호 선택 콜백
  final ValueChanged<String>? onPhoneSelected;

  /// 표시 여부
  final bool show;

  /// 개발 모드에서만 표시 여부
  final bool devModeOnly;

  const PhoneNumberHelper({
    super.key,
    this.onPhoneSelected,
    this.show = true,
    this.devModeOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    // 개발 모드에서만 표시하는 경우 체크
    if (devModeOnly && !_isDebugMode()) {
      return const SizedBox.shrink();
    }

    if (!show) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '테스트용 번호 (개발 환경)',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _testPhoneNumbers.map((phone) {
              return _buildPhoneChip(phone);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 전화번호 선택 칩
  Widget _buildPhoneChip(String phoneNumber) {
    return Material(
      color: AppColors.brandCrimsonLight,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => onPhoneSelected?.call(phoneNumber),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Text(
            phoneNumber,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.brandCrimson,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /// 개발 모드 체크
  bool _isDebugMode() {
    bool debugMode = false;
    assert(debugMode = true); // assert는 debug 모드에서만 실행됨
    return debugMode;
  }

  /// 테스트용 전화번호 목록
  static const List<String> _testPhoneNumbers = [
    '010-1234-5678',
    '010-9876-5432',
    '010-1111-2222',
  ];
}

/// 전화번호 유효성 실시간 표시 위젯
/// 
/// 사용자가 입력하는 전화번호의 유효성을 실시간으로 시각적으로 표시합니다.
class PhoneValidityIndicator extends StatelessWidget {
  /// 전화번호 텍스트
  final String phoneNumber;

  /// 표시 여부
  final bool show;

  const PhoneValidityIndicator({
    super.key,
    required this.phoneNumber,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || phoneNumber.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final isValid = ValidationService.validatePhoneNumber(phoneNumber) == null;
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isValid ? AppColors.success.withValues(alpha: 0.1) : 
               AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isValid ? AppColors.success : AppColors.warning,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.info,
            size: 16.w,
            color: isValid ? AppColors.success : AppColors.warning,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _getStatusMessage(cleanPhone, isValid),
              style: TextStyle(
                fontSize: 12.sp,
                color: isValid ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 상태 메시지 생성
  String _getStatusMessage(String cleanPhone, bool isValid) {
    if (isValid) {
      return '올바른 전화번호 형식입니다 ✓';
    }

    if (cleanPhone.length < 11) {
      return '${11 - cleanPhone.length}자리 더 입력해주세요';
    }

    if (!cleanPhone.startsWith('010')) {
      return '010으로 시작하는 번호만 사용 가능합니다';
    }

    return '올바른 전화번호 형식을 확인해주세요';
  }
}

/// 국가 코드 선택 위젯 (향후 확장용)
/// 
/// 현재는 한국(+82)만 지원하지만, 향후 다른 국가 지원 시 사용할 수 있습니다.
class CountryCodeSelector extends StatelessWidget {
  /// 선택된 국가 코드
  final String selectedCountryCode;

  /// 국가 코드 변경 콜백
  final ValueChanged<String>? onCountryCodeChanged;

  /// 활성화 상태
  final bool enabled;

  const CountryCodeSelector({
    super.key,
    this.selectedCountryCode = '+82',
    this.onCountryCodeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🇰🇷', // 한국 국기 이모지
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(width: 4.w),
          Text(
            selectedCountryCode,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          if (enabled) ...[
            SizedBox(width: 4.w),
            Icon(
              Icons.arrow_drop_down,
              size: 16.w,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}