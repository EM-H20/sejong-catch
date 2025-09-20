import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/buttons/app_button.dart';

/// 👤 사용자 프로필 카드 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 UI 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    this.userName = '홍길동',
    this.department = '컴퓨터공학과',
    this.grade = '3학년',
    this.userRole = 'Student',
    this.onEditProfile,
  });

  final String userName;
  final String department;
  final String grade;
  final String userRole;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // 프로필 이미지
            CircleAvatar(
              radius: 40.r,
              backgroundColor: AppColors.brandCrimsonLight,
              child: Icon(
                Icons.person,
                size: 40.r,
                color: AppColors.brandCrimson,
              ),
            ),

            SizedBox(height: 16.h),

            // 사용자 이름
            Text(
              userName,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 4.h),

            // 학과/전공
            Text(
              '$department • $grade',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),

            SizedBox(height: 8.h),

            // 권한 배지
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.brandCrimson,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                userRole,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 프로필 편집 버튼
            AppButton.outline(
              text: '프로필 편집',
              isExpanded: true,
              onPressed: onEditProfile,
            ),
          ],
        ),
      ),
    );
  }
}