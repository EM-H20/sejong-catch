import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/controllers/auth_controller.dart';
import '../../controllers/login_controller.dart';
import '../../models/login_step.dart';

// 분리된 단계별 위젯들 import
import '../steps/student_id_step.dart';
import '../steps/password_step.dart';
import '../steps/phone_step.dart';
import '../steps/name_step.dart';
import '../steps/verification_step.dart';
import '../steps/loading_and_completed_steps.dart';

/// 로그인 메인 카드 위젯
///
/// 토스 스타일의 단계별 로그인 플로우가 포함된 핵심 카드입니다.
/// 프로그레스 바, 단계별 헤더, 입력 필드들이 매끄럽게 전환되어요! ✨
class LoginCard extends StatelessWidget {
  /// 로그인 후 리다이렉트할 URL (선택사항)
  final String? redirectUrl;

  const LoginCard({super.key, this.redirectUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Consumer2<LoginController, AuthController>(
        builder: (context, loginController, authController, child) {
          return _buildStepBasedLoginForm(
            context,
            loginController,
            authController,
          );
        },
      ),
    );
  }

  /// 토스 스타일 단계별 로그인 폼
  Widget _buildStepBasedLoginForm(
    BuildContext context,
    LoginController loginController,
    AuthController authController,
  ) {
    final isLoading = authController.status == AuthStatus.authenticating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 토스 스타일 프로그레스 바
        _buildProgressBar(loginController),

        SizedBox(height: 32.h),

        // 단계별 제목 영역
        _buildStepHeader(loginController),

        SizedBox(height: 32.h),

        // 단계별 입력 필드 (애니메이션과 함께)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0), // 오른쪽에서 시작
                    end: Offset.zero, // 제자리로
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn, // 토스 스타일 커브
                    ),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _buildCurrentStepWidget(
            context,
            loginController,
            authController,
            isLoading,
          ),
        ),

        SizedBox(height: 24.h),

        // 뒤로가기 버튼 (첫 단계가 아니면 보이기)
        if (loginController.canGoBack()) _buildBackButton(loginController),
      ],
    );
  }

  /// 토스 스타일 프로그레스 바
  Widget _buildProgressBar(LoginController loginController) {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: loginController.getCurrentProgress(),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.brandCrimson, AppColors.brandCrimson],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  /// 단계별 헤더 (제목 + 서브타이틀)
  Widget _buildStepHeader(LoginController loginController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loginController.getCurrentStepTitle(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          loginController.getCurrentStepSubtitle(),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  /// 현재 단계에 맞는 위젯 반환
  Widget _buildCurrentStepWidget(
    BuildContext context,
    LoginController loginController,
    AuthController authController,
    bool isLoading,
  ) {
    // 분리된 위젯들을 사용해서 깔끔하고 간결하게! 🎉
    switch (loginController.currentLoginStep) {
      case LoginStep.studentIdInput:
        return StudentIdStepWidget(
          key: const ValueKey('student-id'),
          controller: loginController.studentIdController,
          focusNode: loginController.studentIdFocusNode,
          onNext: loginController.handleStudentIdInput,
          isLoading: isLoading,
          enabled: !isLoading,
          autofocus: true,
        );

      case LoginStep.passwordInput:
        return PasswordStepWidget(
          key: const ValueKey('password'),
          controller: loginController.passwordController,
          focusNode: loginController.passwordFocusNode,
          onLogin: () => loginController.handlePasswordInput(
            onSuccess: () {
              // 성공 시 스낵바 표시 후 네비게이션
              _showSuccessMessage(context, '환영합니다! 세종 캐치와 함께해요 🎓✨');
              loginController.navigateAfterLogin(
                context,
                redirectUrl: redirectUrl,
              );
            },
            onError: (error) => _showErrorMessage(context, error),
          ),
          isLoading: isLoading,
          enabled: !isLoading,
          autofocus: true,
          initialRememberMe: loginController.rememberMe,
          onRememberMeChanged: loginController.setRememberMe,
        );

      case LoginStep.studentLoginLoading:
        return LoadingStepWidget.studentLogin(
          key: const ValueKey('student-loading'),
        );

      case LoginStep.phoneInput:
        return PhoneStepWidget(
          key: const ValueKey('phone'),
          controller: loginController.phoneController,
          focusNode: loginController.phoneFocusNode,
          onNext: () => loginController.handlePhoneInput(
            onError: (error) => _showErrorMessage(context, error),
          ),
          isLoading: isLoading,
          enabled: !isLoading,
          autofocus: true,
        );

      case LoginStep.nameInput:
        return NameStepWidget(
          key: const ValueKey('name'),
          controller: loginController.nameController,
          focusNode: loginController.nameFocusNode,
          onSendSMS: () => loginController.handleNameInputAndSendSMS(
            onSuccess: () {
              _showSuccessMessage(
                context,
                '📱 ${loginController.phoneController.text}로 인증번호를 발송했어요!',
              );
            },
            onError: (error) => _showErrorMessage(context, error),
          ),
          isLoading: isLoading,
          enabled: !isLoading,
          autofocus: true,
        );

      case LoginStep.verificationSent:
        return LoadingStepWidget(
          key: const ValueKey('verification-sent'),
          message: '인증번호를 발송했어요!',
          subMessage: '${loginController.phoneController.text}로 인증번호를 보냈어요',
          style: LoadingStyle.pulsing,
        );

      case LoginStep.verificationInput:
        return VerificationStepWidget(
          key: const ValueKey('verification'),
          controller: loginController.verificationCodeController,
          focusNode: loginController.verificationFocusNode,
          onVerify: () => loginController.handleVerificationInput(
            onSuccess: () {
              _showSuccessMessage(
                context,
                '🎉 인증이 완료되었습니다! ${loginController.nameController.text}님 환영해요!',
              );
              loginController.navigateAfterLogin(
                context,
                redirectUrl: redirectUrl,
              );
            },
            onError: (error) => _showErrorMessage(context, error),
          ),
          onResend: () => loginController.goToNextStep(LoginStep.nameInput),
          isLoading: isLoading,
          enabled: !isLoading,
          autofocus: true,
          phoneNumber: loginController.phoneController.text,
          remainingSeconds: loginController.remainingSeconds,
        );

      case LoginStep.guestLoginLoading:
        return LoadingStepWidget.guestLogin(
          key: const ValueKey('guest-loading'),
        );

      case LoginStep.completed:
        return loginController.isStudentLogin
            ? CompletedStepWidget.studentLogin(
                key: const ValueKey('completed'),
                onStart: () => loginController.navigateAfterLogin(
                  context,
                  redirectUrl: redirectUrl,
                ),
              )
            : CompletedStepWidget.guestLogin(
                key: const ValueKey('completed'),
                userName: loginController.nameController.text,
                onStart: () => loginController.navigateAfterLogin(
                  context,
                  redirectUrl: redirectUrl,
                ),
              );
    }
  }

  /// 뒤로가기 버튼
  Widget _buildBackButton(LoginController loginController) {
    return Center(
      child: TextButton.icon(
        onPressed: loginController.goToPreviousStep,
        icon: Icon(
          Icons.arrow_back_ios,
          size: 16.w,
          color: AppColors.textSecondary,
        ),
        label: Text(
          '이전 단계',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // === 유틸리티 메서드들 ===

  /// 성공 메시지 표시
  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  /// 에러 메시지 표시
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
