/// 세종대 계정 입력 단계 위젯
/// 
/// 학번, 이메일, 아이디 등 다양한 형식의 세종대 계정을 입력받는 단계입니다.
/// 토스처럼 유연하고 사용자 친화적인 입력 방식을 제공해요! 🎓
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../services/validation_service.dart';

/// 세종대 계정 입력 단계 위젯
/// 
/// 학번, 이메일, 아이디 등 자유로운 형식으로 계정을 입력할 수 있습니다.
/// 실제 인증은 서버에서 처리하므로, 여기서는 관대한 검증을 적용해요.
class StudentIdStepWidget extends StatefulWidget {
  /// 텍스트 컨트롤러
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

  const StudentIdStepWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onNext,
    this.isLoading = false,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<StudentIdStepWidget> createState() => _StudentIdStepWidgetState();
}

class _StudentIdStepWidgetState extends State<StudentIdStepWidget> {
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
    
    // 실시간 검증 (입력 중일 때는 너무 엄격하지 않게)
    if (_showValidation) {
      _validateInput(text, showError: false);
    }
  }

  /// 입력값 검증
  bool _validateInput(String value, {bool showError = true}) {
    final errorMessage = ValidationService.validateStudentAccount(value);
    
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
        // 계정 입력 필드
        AppTextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled && !widget.isLoading,
          labelText: '세종대 계정',
          hintText: _getHintText(),
          prefixIcon: Icons.account_circle,
          keyboardType: TextInputType.text, // 숫자, 문자, 이메일 모두 가능
          textInputAction: TextInputAction.next,
          errorText: _errorMessage,
          onSubmitted: (_) => _handleSubmitted(),
          onChanged: (value) {
            // 실시간 검증은 _onTextChanged에서 처리됨
          },
        ),
        
        SizedBox(height: 16.h),
        
        // 도움말 텍스트
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

  /// 힌트 텍스트 생성
  String _getHintText() {
    return '학번, 이메일, 아이디 등';
  }

  /// 도움말 텍스트 위젯
  Widget _buildHelpText() {
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
            Icons.lightbulb_outline,
            size: 16.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '입력 가능한 형식',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandCrimson,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '• 학번: 20210001\n'
                  '• 이메일: student@sejong.ac.kr\n'
                  '• 아이디: myid@sejong.ac.kr (전체 입력)',
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

/// 계정 타입 표시 칩
/// 
/// 입력된 계정의 타입을 시각적으로 표시하는 위젯입니다.
/// 사용자가 입력한 내용이 어떤 형식으로 인식되는지 보여줘요.
class AccountTypeChip extends StatelessWidget {
  /// 계정 텍스트
  final String account;

  /// 표시 여부
  final bool show;

  const AccountTypeChip({
    super.key,
    required this.account,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || account.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final accountType = _detectAccountType(account.trim());
    
    return AnimatedOpacity(
      opacity: show ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: _getTypeColor(accountType).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getTypeColor(accountType).withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getTypeIcon(accountType),
              size: 12.w,
              color: _getTypeColor(accountType),
            ),
            SizedBox(width: 4.w),
            Text(
              _getTypeLabel(accountType),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: _getTypeColor(accountType),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 계정 타입 감지
  String _detectAccountType(String account) {
    if (account.contains('@')) {
      return 'email';
    } else if (RegExp(r'^[0-9]{8}$').hasMatch(account)) {
      return 'student_id';
    } else {
      return 'username';
    }
  }

  /// 타입별 색상
  Color _getTypeColor(String type) {
    switch (type) {
      case 'email':
        return Colors.blue;
      case 'student_id':
        return Colors.green;
      case 'username':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  /// 타입별 아이콘
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'email':
        return Icons.email_outlined;
      case 'student_id':
        return Icons.badge_outlined;
      case 'username':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }

  /// 타입별 라벨
  String _getTypeLabel(String type) {
    switch (type) {
      case 'email':
        return '이메일';
      case 'student_id':
        return '학번';
      case 'username':
        return '아이디';
      default:
        return '알 수 없음';
    }
  }
}

/// 자동 완성 제안 위젯
/// 
/// 사용자가 입력할 때 도메인 자동 완성을 제안하는 위젯입니다.
/// 예를 들어 "student"를 입력하면 "@sejong.ac.kr"을 제안해요.
class AutoCompleteSuggestion extends StatelessWidget {
  /// 현재 입력값
  final String currentValue;

  /// 제안 선택 콜백
  final ValueChanged<String>? onSuggestionSelected;

  /// 표시 여부
  final bool show;

  const AutoCompleteSuggestion({
    super.key,
    required this.currentValue,
    this.onSuggestionSelected,
    this.show = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final suggestion = _generateSuggestion(currentValue.trim());
    if (suggestion == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: 8.h),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: () => onSuggestionSelected?.call(suggestion),
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.auto_fix_high,
                  size: 16.w,
                  color: AppColors.brandCrimson,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        TextSpan(text: currentValue),
                        TextSpan(
                          text: suggestion.substring(currentValue.length),
                          style: TextStyle(
                            color: AppColors.brandCrimson,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.w,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 자동완성 제안 생성 - 비활성화됨
  String? _generateSuggestion(String input) {
    // 자동완성 제안 기능을 비활성화하여 사용자가 직접 입력하도록 함
    return null;
  }
}