import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/ui_utils.dart';

/// 로그인 페이지 푸터 위젯
/// 
/// 회원가입 안내, 둘러보기 기능 등이 포함된 친근한 푸터입니다.
/// 사용자에게 다양한 선택지를 제공해요! 👋
class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 회원가입 안내
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            children: [
              const TextSpan(text: '아직 계정이 없으신가요? '),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // TODO: 회원가입 페이지로 이동
                    UiUtils.showErrorSnackBar(
                      context,
                      '회원가입 기능은 곧 추가될 예정입니다! 🚧',
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.brandCrimson,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.brandCrimson,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // 게스트 모드 안내 카드
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.visibility, 
                size: 20.w, 
                color: AppColors.brandCrimson,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '가입 없이 공개 정보를 둘러볼 수 있어요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // 둘러보기로 피드 페이지 이동
                  context.go(AppRoutes.feed);
                },
                child: Text(
                  '둘러보기',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.brandCrimson,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}