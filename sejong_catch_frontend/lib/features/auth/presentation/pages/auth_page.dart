import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../controllers/auth_controller.dart';

/// 🔐 인증 페이지 (로그인/회원가입)
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerStatefulWidget으로 Riverpod 통합
/// ✅ AuthController를 통한 실제 API 호출
/// ✅ 둘러보기 모드는 제약 없이 유지 (요구사항)
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  bool _isStudentLogin = true;

  // 📝 학생 로그인 폼 컨트롤러
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();

  // 📝 게스트 로그인 폼 컨트롤러
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 인증 상태 감시
    final authState = ref.watch(authControllerProvider);

    // 🎯 로그인 성공 시 자동 이동
    ref.listen(authControllerProvider, (previous, next) {
      if (next.isLoggedIn && !next.isLoading) {
        context.go(AppRoutes.feed);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('학생 로그인에 성공했어요! 세종 캐치에 오신 것을 환영합니다 🎉'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // 에러 메시지 표시
      if (next.error != null && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        // 에러 표시 후 초기화
        Future.delayed(const Duration(seconds: 3), () {
          ref.read(authControllerProvider.notifier).clearError();
        });
      }
    });

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
              _buildActionButton(authState.isLoading),

              SizedBox(height: 16.h),

              // 🔗 추가 옵션
              _buildAdditionalOptions(),

              SizedBox(height: 24.h),

              // 📋 게스트 모드 (제약 없이 유지)
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

  /// 🔄 학생/게스트 로그인 모드 토글
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
              onTap: () => setState(() => _isStudentLogin = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: _isStudentLogin
                      ? AppColors.brandCrimson
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '학생 로그인',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: _isStudentLogin ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isStudentLogin = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: !_isStudentLogin
                      ? AppColors.brandCrimson
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '게스트 로그인',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: !_isStudentLogin ? Colors.white : Colors.grey[700],
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
    if (_isStudentLogin) {
      return _buildStudentLoginForm();
    } else {
      return _buildGuestLoginForm();
    }
  }

  /// 🎓 학생 로그인 폼
  Widget _buildStudentLoginForm() {
    return Column(
      children: [
        // 학번 입력
        AppTextField(
          controller: _studentIdController,
          labelText: '학번',
          hintText: '세종대학교 학번을 입력해주세요',
          prefixIcon: Icons.school_outlined,
          keyboardType: TextInputType.number,
        ),

        SizedBox(height: 16.h),

        // 비밀번호 입력
        AppTextField.password(
          controller: _passwordController,
          labelText: '비밀번호',
          hintText: '세종대학교 포털 비밀번호',
        ),
      ],
    );
  }

  /// 👤 게스트 로그인 폼
  Widget _buildGuestLoginForm() {
    return Column(
      children: [
        // 전화번호 입력
        AppTextField(
          controller: _phoneController,
          labelText: '전화번호',
          hintText: '010-1234-5678',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        SizedBox(height: 16.h),

        // 이름 입력
        AppTextField(
          controller: _nameController,
          labelText: '이름',
          hintText: '실명을 입력해주세요',
          prefixIcon: Icons.person_outline,
        ),

        SizedBox(height: 12.h),

        // 게스트 로그인 안내
        Text(
          '게스트로 로그인하면 제한된 정보만 확인할 수 있어요',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 🎯 메인 액션 버튼
  Widget _buildActionButton(bool isLoading) {
    return AppButton.primary(
      text: _isStudentLogin ? '학생 로그인' : '게스트 로그인',
      isExpanded: true,
      size: AppButtonSize.large,
      isLoading: isLoading,
      onPressed: isLoading ? null : _handleAuth,
    );
  }

  /// 🔗 추가 옵션
  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        if (_isStudentLogin) ...[
          AppButton.text(
            text: '비밀번호를 잊으셨나요?',
            onPressed: () {
              _showPasswordResetDialog();
            },
          ),
        ],
      ],
    );
  }

  /// 📋 게스트 모드 (제약 없이 유지 - 요구사항)
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
          text: '둘러보기',
          onPressed: () {
            context.go(AppRoutes.feed);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '둘러보기 모드로 시작했어요! 학생 인증을 하면 더 많은 기능을 이용할 수 있어요 🚀'),
                backgroundColor: AppColors.brandCrimson,
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ],
    );
  }

  /// 🔐 인증 처리 로직 (실제 API 호출!)
  void _handleAuth() {
    if (_isStudentLogin) {
      // 학생 로그인: Controller를 통한 실제 API 호출
      final studentId = _studentIdController.text.trim();
      final password = _passwordController.text.trim();

      if (studentId.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('학번과 비밀번호를 입력해주세요.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // ✅ 실제 API 호출!
      ref.read(authControllerProvider.notifier).login(studentId, password);
    } else {
      // 게스트 로그인: 현재는 Mock (향후 백엔드 연동 시 구현)
      final phone = _phoneController.text.trim();
      final name = _nameController.text.trim();

      if (phone.isEmpty || name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('전화번호와 이름을 입력해주세요.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // TODO: 게스트 로그인 API 연동
      context.go(AppRoutes.feed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게스트 로그인이 완료되었어요! 제한된 정보를 확인해보세요 📱'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 🔒 비밀번호 재설정 다이얼로그
  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '비밀번호 찾기',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('세종대학교 포털에서 비밀번호를 재설정해주세요.'),
            SizedBox(height: 12.h),
            Text(
              '🔗 세종대학교 포털 → 비밀번호 찾기',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
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
