import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 로그인 페이지 헤더 위젯
/// 
/// 세종대학교 로고, 앱 타이틀, 서브타이틀을 포함하는 깔끔한 헤더입니다.
/// 브랜딩이 느껴지는 토스 스타일로 구성되어 있어요! 🎓✨
class LoginHeader extends StatelessWidget {
  /// 현재 로그인 모드 (true: 학번 로그인, false: 게스트 로그인)
  final bool isStudentLogin;

  const LoginHeader({
    super.key,
    required this.isStudentLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 세종대학교 공식 로고
        // 가장 간결한 형태 (정사각)
        Image.asset(
          'assets/sejong-logo.png',
          width: 80.w,
          height: 80.w, // 정사각 유지
          fit: BoxFit.contain,
          // 에러 처리: 로고 파일이 없는 경우 대체 아이콘
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.brandCrimsonLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                size: 40.w,
                color: AppColors.brandCrimson,
              ),
            );
          },
        ),

        SizedBox(height: 20.h),

        // 앱 타이틀 - 임팩트 있는 브랜딩
        Text(
          '세종 캐치',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.brandCrimson,
            height: 1.2,
          ),
        ),

        SizedBox(height: 8.h),

        // 서브 타이틀 - 모드에 따라 다른 메시지
        Text(
          isStudentLogin 
            ? '학번과 비밀번호로 로그인하세요' 
            : '전화번호로 간편하게 시작하세요',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}