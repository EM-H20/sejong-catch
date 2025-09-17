import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

/// 🔐 인증 페이지 (로그인/회원가입)
///
/// CLAUDE.md 원칙:
/// ✅ 세종대 SSO 게이트웨이 연동 예정
/// ✅ 독립 페이지 (BottomNavigationBar 없음)
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // 🎯 로고 및 타이틀
              _buildHeader(),

              SizedBox(height: 40.h),

              // 🔄 로그인/회원가입 모드 토글
              _buildModeToggle(),

              SizedBox(height: 24.h),

              // 📝 인증 폼
              _buildAuthForm(),

              SizedBox(height: 24.h),

              // 🎯 메인 액션 버튼
              _buildActionButton(),

              SizedBox(height: 16.h),

              // 🔗 추가 옵션
              _buildAdditionalOptions(),

              SizedBox(height: 24.h),

              // 📋 게스트 모드
              _buildGuestMode(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎯 헤더 (로고 + 타이틀)
  Widget _buildHeader() {
    return Column(
      children: [
        // 로고
        SizedBox(
          width: 80.r,
          height: 80.r,
          child: Image.asset('assets/sejong-logo.png', fit: BoxFit.contain),
        ),

        SizedBox(height: 16.h),

        // 타이틀
        Text(
          '세종 캐치',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.brandCrimson,
          ),
        ),

        SizedBox(height: 8.h),

        // 서브타이틀
        Text(
          '세종인을 위한 단 하나의 정보 허브',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// 🔄 로그인/회원가입 모드 토글
  Widget _buildModeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLoginMode = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: _isLoginMode
                      ? AppColors.brandCrimson
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '로그인',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: _isLoginMode ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLoginMode = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !_isLoginMode
                      ? AppColors.brandCrimson
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '회원가입',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: !_isLoginMode ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 인증 폼
  Widget _buildAuthForm() {
    return Column(
      children: [
        // 학번 입력
        _buildTextField(
          label: '학번',
          hint: '세종대학교 학번을 입력해주세요',
          icon: Icons.school_outlined,
        ),

        SizedBox(height: 16.h),

        // 비밀번호 입력
        _buildTextField(
          label: '비밀번호',
          hint: '세종대학교 포털 비밀번호',
          icon: Icons.lock_outline,
          isPassword: true,
        ),

        if (!_isLoginMode) ...[
          SizedBox(height: 16.h),

          // 이름 입력 (회원가입 시)
          _buildTextField(
            label: '이름',
            hint: '실명을 입력해주세요',
            icon: Icons.person_outline,
          ),

          SizedBox(height: 16.h),

          // 학과 선택 (회원가입 시)
          _buildDropdownField(),
        ],
      ],
    );
  }

  /// 📝 텍스트 필드
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            prefixIcon: Icon(icon, size: 20.r, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.brandCrimson),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ],
    );
  }

  /// 📋 학과 선택 드롭다운
  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '학과',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: '학과를 선택해주세요',
            prefixIcon: Icon(Icons.school, size: 20.r, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.brandCrimson),
            ),
          ),
          items:
              [
                '컴퓨터공학과',
                '소프트웨어학과',
                '정보보호학과',
                '데이터사이언스학과',
                '경영학과',
                '경제학과',
                // TODO: 전체 학과 목록 추가
              ].map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
          onChanged: (value) {
            // TODO: 학과 선택 처리
          },
        ),
      ],
    );
  }

  /// 🎯 메인 액션 버튼
  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: 실제 인증 로직 구현
          // 성공 시 메인 앱으로 이동
          context.go(AppRoutes.feed);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandCrimson,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          _isLoginMode ? '로그인' : '회원가입',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 🔗 추가 옵션
  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        if (_isLoginMode) ...[
          TextButton(
            onPressed: () {
              // TODO: 비밀번호 찾기
            },
            child: Text(
              '비밀번호를 잊으셨나요?',
              style: TextStyle(fontSize: 14.sp, color: AppColors.brandCrimson),
            ),
          ),
        ],

        // 이용약관 동의 (회원가입 시)
        if (!_isLoginMode) ...[
          Row(
            children: [
              Checkbox(
                value: true, // TODO: 실제 체크박스 상태 관리
                onChanged: (value) {
                  // TODO: 약관 동의 처리
                },
                activeColor: AppColors.brandCrimson,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    children: [
                      const TextSpan(text: ''),
                      TextSpan(
                        text: '이용약관',
                        style: TextStyle(
                          color: AppColors.brandCrimson,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' 및 '),
                      TextSpan(
                        text: '개인정보처리방침',
                        style: TextStyle(
                          color: AppColors.brandCrimson,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '에 동의합니다.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 📋 게스트 모드
  Widget _buildGuestMode() {
    return Column(
      children: [
        Divider(color: Colors.grey[300]),
        SizedBox(height: 16.h),
        Text(
          '학생 인증 없이 둘러보기',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 8.h),
        TextButton(
          onPressed: () {
            // TODO: 게스트 모드로 메인 앱 진입
            context.go(AppRoutes.feed);
          },
          child: Text(
            '게스트로 시작하기',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.brandCrimson,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
