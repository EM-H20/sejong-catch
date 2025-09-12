/// 이름 입력 단계 위젯
/// 
/// 게스트 로그인을 위한 이름(실명) 입력 단계입니다.
/// 한글 이름 검증과 SMS 인증번호 발송 기능을 제공해요! 👤
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../services/validation_service.dart';

/// 이름 입력 단계 위젯
/// 
/// 한글 실명을 입력받고 SMS 인증번호 발송을 처리하는 단계입니다.
/// 이름 검증과 함께 사용자 친화적인 안내를 제공해요.
class NameStepWidget extends StatefulWidget {
  /// 이름 컨트롤러
  final TextEditingController controller;

  /// 포커스 노드
  final FocusNode focusNode;

  /// 인증번호 받기 버튼 콜백
  final VoidCallback? onSendSMS;

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

  /// 연결된 전화번호 (안내 메시지용)
  final String? phoneNumber;

  const NameStepWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSendSMS,
    this.isLoading = false,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
    this.onChanged,
    this.phoneNumber,
  });

  @override
  State<NameStepWidget> createState() => _NameStepWidgetState();
}

class _NameStepWidgetState extends State<NameStepWidget> {
  String? _errorMessage;
  bool _showValidation = false;

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
    
    // 외부 콜백 호출
    widget.onChanged?.call(text);
    
    // 실시간 검증 (입력 중일 때는 부드럽게)
    if (_showValidation) {
      _validateInput(text, showError: text.length >= 2); // 2글자부터 실시간 검증
    }
  }

  /// 입력값 검증
  bool _validateInput(String value, {bool showError = true}) {
    final errorMessage = ValidationService.validateKoreanName(value);
    
    if (mounted) {
      setState(() {
        _errorMessage = showError ? errorMessage : null;
      });
    }
    
    return errorMessage == null;
  }

  /// SMS 발송 처리
  void _handleSendSMS() {
    setState(() {
      _showValidation = true;
    });
    
    if (_validateInput(widget.controller.text)) {
      widget.onSendSMS?.call();
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
      _handleSendSMS();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 이름 입력 필드
        AppTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !widget.isLoading,
          labelText: '이름',
          hintText: '홍길동',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          errorText: _errorMessage,
          onSubmitted: (_) => _handleSubmitted(),
          inputFormatters: [
            // 한글만 허용
            FilteringTextInputFormatter.allow(RegExp(r'[가-힣]')),
            // 최대 4글자 제한
            LengthLimitingTextInputFormatter(4),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // 이름 입력 가이드
        _buildNameGuide(),
        
        SizedBox(height: 24.h),
        
        // 인증번호 받기 버튼
        AppButton.primary(
          text: _getButtonText(),
          onPressed: widget.enabled && !widget.isLoading ? _handleSendSMS : null,
          isLoading: widget.isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
        ),
        
        SizedBox(height: 16.h),
        
        // SMS 발송 안내
        _buildSMSNotice(),
      ],
    );
  }

  /// 버튼 텍스트 결정
  String _getButtonText() {
    if (widget.phoneNumber != null) {
      return '${widget.phoneNumber}로 인증번호 받기';
    }
    return '인증번호 받기';
  }

  /// 이름 입력 가이드 위젯
  Widget _buildNameGuide() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.person_pin,
            size: 16.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '실명 입력 안내',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandCrimson,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '• 한글 이름만 입력 가능합니다 (2~4글자)\n'
                  '• 실명을 정확히 입력해주세요\n'
                  '• 공백이나 특수문자는 사용할 수 없습니다',
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

  /// SMS 발송 안내 위젯
  Widget _buildSMSNotice() {
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
            Icons.sms_outlined,
            size: 16.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMS 인증 안내',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.phoneNumber != null
                      ? '${widget.phoneNumber}로 6자리 인증번호를 발송합니다.\n'
                        '인증번호는 3분간 유효하며, 통신료가 발생할 수 있습니다.'
                      : '등록하신 전화번호로 6자리 인증번호를 발송합니다.\n'
                        '인증번호는 3분간 유효하며, 통신료가 발생할 수 있습니다.',
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

/// 이름 입력 도우미 위젯
/// 
/// 자주 사용되는 테스트용 이름을 빠르게 입력할 수 있는 도우미입니다.
/// 개발/테스트 환경에서만 표시되어요.
class NameInputHelper extends StatelessWidget {
  /// 이름 선택 콜백
  final ValueChanged<String>? onNameSelected;

  /// 표시 여부
  final bool show;

  /// 개발 모드에서만 표시 여부
  final bool devModeOnly;

  const NameInputHelper({
    super.key,
    this.onNameSelected,
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
            '테스트용 이름 (개발 환경)',
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
            children: _testNames.map((name) {
              return _buildNameChip(name);
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 이름 선택 칩
  Widget _buildNameChip(String name) {
    return Material(
      color: AppColors.brandCrimsonLight,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => onNameSelected?.call(name),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Text(
            name,
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

  /// 테스트용 이름 목록
  static const List<String> _testNames = [
    '홍길동',
    '김철수',
    '박영희',
    '이민수',
    '정수연',
  ];
}

/// 이름 유효성 실시간 표시 위젯
/// 
/// 사용자가 입력하는 이름의 유효성을 실시간으로 시각적으로 표시합니다.
class NameValidityIndicator extends StatelessWidget {
  /// 이름 텍스트
  final String name;

  /// 표시 여부
  final bool show;

  const NameValidityIndicator({
    super.key,
    required this.name,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || name.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final isValid = ValidationService.validateKoreanName(name) == null;
    final issues = _analyzeNameIssues(name);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isValid 
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isValid ? AppColors.success : AppColors.warning,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            size: 16.w,
            color: isValid ? AppColors.success : AppColors.warning,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isValid ? '올바른 이름 형식입니다 ✓' : '이름을 확인해주세요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isValid ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isValid && issues.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  ...issues.map((issue) => Text(
                    '• $issue',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.warning,
                      height: 1.2,
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 이름 문제점 분석
  List<String> _analyzeNameIssues(String name) {
    final issues = <String>[];

    if (name.length < 2) {
      issues.add('최소 2글자 이상 입력해주세요');
    } else if (name.length > 4) {
      issues.add('최대 4글자까지 입력 가능합니다');
    }

    if (!RegExp(r'^[가-힣]*$').hasMatch(name)) {
      issues.add('한글만 입력 가능합니다');
    }

    // 같은 글자 반복 체크
    if (name.length >= 3) {
      bool hasRepeat = false;
      for (int i = 0; i <= name.length - 3; i++) {
        if (name[i] == name[i + 1] && name[i + 1] == name[i + 2]) {
          hasRepeat = true;
          break;
        }
      }
      if (hasRepeat) {
        issues.add('올바른 이름을 입력해주세요');
      }
    }

    return issues;
  }
}

/// 이름 자동 완성 위젯 (향후 확장용)
/// 
/// 자주 사용되는 성씨나 이름 패턴을 제안하는 위젯입니다.
/// 현재는 기본적인 성씨 제안만 제공해요.
class NameAutoComplete extends StatelessWidget {
  /// 현재 입력값
  final String currentInput;

  /// 제안 선택 콜백
  final ValueChanged<String>? onSuggestionSelected;

  /// 표시 여부
  final bool show;

  const NameAutoComplete({
    super.key,
    required this.currentInput,
    this.onSuggestionSelected,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final suggestions = _generateSuggestions(currentInput);
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '추천 이름',
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: suggestions.map((suggestion) {
              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  onTap: () => onSuggestionSelected?.call(suggestion),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 자동완성 제안 생성
  List<String> _generateSuggestions(String input) {
    if (input.isEmpty) return [];

    // 첫 글자(성)를 기반으로 일반적인 이름 제안
    final suggestions = <String>[];
    final firstName = input[0];

    final commonNames = _getCommonNamesForSurname(firstName);
    for (final name in commonNames) {
      if (name.startsWith(input) && name != input) {
        suggestions.add(name);
      }
    }

    return suggestions.take(3).toList(); // 최대 3개만 제안
  }

  /// 성씨별 일반적인 이름 목록
  List<String> _getCommonNamesForSurname(String surname) {
    switch (surname) {
      case '김':
        return ['김철수', '김영희', '김민수', '김지연'];
      case '이':
        return ['이민호', '이수진', '이영수', '이하늘'];
      case '박':
        return ['박지민', '박서연', '박준혁', '박하은'];
      case '최':
        return ['최민준', '최서윤', '최지훈', '최예은'];
      case '정':
        return ['정우진', '정수연', '정현우', '정다은'];
      case '강':
        return ['강동원', '강소영', '강준서', '강예린'];
      case '조':
        return ['조민기', '조은별', '조현준', '조윤서'];
      default:
        return [];
    }
  }
}