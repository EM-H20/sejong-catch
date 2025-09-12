import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 로그인 방식 전환 토글 위젯
/// 
/// 학번 로그인과 게스트 로그인 사이를 매끄럽게 전환할 수 있는 토스 스타일 토글입니다.
/// 세련된 애니메이션과 함께 사용자 경험을 향상시켜요! 🔄
class LoginModeToggle extends StatelessWidget {
  /// 현재 로그인 모드 (true: 학번 로그인, false: 게스트 로그인)
  final bool isStudentLogin;
  
  /// 모드 변경 콜백
  final VoidCallback? onToggle;
  
  /// 활성화 상태 (로딩 중일 때 비활성화)
  final bool enabled;

  const LoginModeToggle({
    super.key,
    required this.isStudentLogin,
    this.onToggle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            text: '세종대 로그인',
            icon: Icons.person,
            isSelected: isStudentLogin,
            onTap: enabled && !isStudentLogin ? onToggle : null,
          ),
          _buildToggleButton(
            text: '게스트 로그인',
            icon: Icons.phone,
            isSelected: !isStudentLogin,
            onTap: enabled && isStudentLogin ? onToggle : null,
          ),
        ],
      ),
    );
  }

  /// 토글 버튼 개별 요소
  Widget _buildToggleButton({
    required String text,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandCrimson : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}