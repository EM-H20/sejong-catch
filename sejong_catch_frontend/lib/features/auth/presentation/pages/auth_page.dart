import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';

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
        AppTextField(
          labelText: '학번',
          hintText: '세종대학교 학번을 입력해주세요',
          prefixIcon: Icons.school_outlined,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // 상태 관리는 추후 Controller에서 처리
          },
        ),

        SizedBox(height: 16.h),

        // 비밀번호 입력
        AppTextField.password(
          labelText: '비밀번호',
          hintText: '세종대학교 포털 비밀번호',
          onChanged: (value) {
            // 상태 관리는 추후 Controller에서 처리
          },
        ),

        if (!_isLoginMode) ...[
          SizedBox(height: 16.h),

          // 이름 입력 (회원가입 시)
          AppTextField(
            labelText: '이름',
            hintText: '실명을 입력해주세요',
            prefixIcon: Icons.person_outline,
            onChanged: (value) {},
          ),

          SizedBox(height: 16.h),

          // 학과 선택 (회원가입 시)
          _buildDropdownField(),
        ],
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
                '기타 학과',
              ].map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
          onChanged: (value) {
            // 상태 관리는 추후 Controller에서 처리
          },
        ),
      ],
    );
  }

  /// 🎯 메인 액션 버튼
  Widget _buildActionButton() {
    return AppButton.primary(
      text: _isLoginMode ? '로그인' : '회원가입',
      isExpanded: true,
      size: AppButtonSize.large,
      onPressed: () {
        _handleAuth();
      },
    );
  }

  /// 🔗 추가 옵션
  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        if (_isLoginMode) ...[
          AppButton.text(
            text: '비밀번호를 잊으셨나요?',
            onPressed: () {
              _showPasswordResetDialog();
            },
          ),
        ],

        // 이용약관 동의 (회원가입 시)
        if (!_isLoginMode) ...[
          Row(
            children: [
              Checkbox(
                value: true, // 상태 관리는 추후 Controller에서 처리
                onChanged: (value) {
                  // 상태 관리는 추후 Controller에서 처리
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
        AppButton.text(
          text: '게스트로 시작하기',
          onPressed: () {
            context.go(AppRoutes.feed);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('게스트 모드로 시작했어요! 학생 인증을 하면 더 많은 기능을 이용할 수 있어요 🚀'),
                backgroundColor: AppColors.brandCrimson,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🔐 인증 처리 로직
  void _handleAuth() {
    context.go(AppRoutes.feed);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLoginMode
              ? '로그인에 성공했어요! 세종 캐치에 오신 것을 환영합니다 🎉'
              : '회원가입이 완료되었어요! 이제 맞춤 정보를 받아보세요 🚀',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 🔒 비밀번호 재설정 다이얼로그
  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '비밀번호 찾기',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('세종대학교 포털에서 비밀번호를 재설정해주세요.'),
            SizedBox(height: 12.h),
            Text(
              '🔗 세종대학교 포털 → 비밀번호 찾기',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          AppButton.primary(
            text: '확인',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
