import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/services/onboarding_service.dart';
import '../../../../core/config/app_router.dart';
import '../controllers/login_controller.dart';

/// 세종 캐치 로그인 화면
///
/// Crimson Red 디자인 시스템 적용
/// AppSpacing, AppTextStyles 100% 사용
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 🔥 세션 만료 메시지 확인 및 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionExpiredMessage();
    });
  }

  /// 🔥 세션 만료 시 스낵바로 메시지 표시
  void _checkSessionExpiredMessage() {
    final authNotifier = AppRouter.authNotifier;
    if (authNotifier != null && authNotifier.sessionExpired) {
      final message = authNotifier.sessionExpiredMessage ?? '세션이 만료되었습니다.';

      // 스낵바 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.white, size: 20.sp),
                AppSpacing.horizontalSpaceSM,
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            margin: AppSpacing.screenPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }

      // 플래그 초기화 (다시 표시되지 않도록)
      authNotifier.clearSessionExpired();
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);

    // 🎯 로그인 성공 시 온보딩 체크 후 네비게이션
    ref.listen(loginControllerProvider, (previous, next) async {
      if (next.isLoggedIn && !next.isLoading) {
        // 로그인 성공! 온보딩 체크
        final onboardingService = ref.read(onboardingServiceProvider);
        final hasSeenOnboarding = await onboardingService.hasSeenOnboarding();

        if (!mounted) return;

        // BuildContext.mounted 체크 (Flutter 3.7+)
        final route = hasSeenOnboarding ? '/feed' : '/onboarding';
        if (context.mounted) {
          context.go(route);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🎯 상단 여백
                AppSpacing.verticalSpaceHuge,

                // 🎓 로고 & 타이틀
                Center(
                  child: Column(
                    children: [
                      // 세종대 로고
                      Image.asset(
                        'assets/sejong-logo.png',
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.contain,
                      ),
                      AppSpacing.verticalSpaceLG,

                      // 앱 이름
                      Text(
                        '세종 캐치',
                        style: AppTextStyles.displayBold36.copyWith(
                          color: AppColors.brandCrimson,
                        ),
                      ),
                      AppSpacing.verticalSpaceSM,

                      // 서브 타이틀
                      Text(
                        '세종인을 위한 정보 허브',
                        style: AppTextStyles.bodySemiBold16.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.verticalSpaceHuge,

                // 📝 학번 입력
                AppTextField(
                  controller: _studentIdController,
                  labelText: '학번',
                  hintText: '예: 20241234',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.person_outline,
                  onChanged: controller.updateStudentId,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '학번을 입력해주세요';
                    }
                    return null;
                  },
                ),

                AppSpacing.verticalSpaceLG,

                // 🔒 비밀번호 입력
                AppTextField.password(
                  controller: _passwordController,
                  labelText: '비밀번호',
                  hintText: '세종대 포털 비밀번호',
                  onChanged: controller.updatePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                ),

                // ⚠️ 에러 메시지
                if (loginState.error != null) ...[
                  AppSpacing.verticalSpaceMD,
                  Container(
                    padding: AppSpacing.cardPaddingSmall,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.error, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20.sp,
                        ),
                        AppSpacing.horizontalSpaceSM,
                        Expanded(
                          child: Text(
                            loginState.error!,
                            style: AppTextStyles.bodyRegular12.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                AppSpacing.verticalSpaceHuge,

                // 🚀 로그인 버튼
                AppButton.primary(
                  size: AppButtonSize.large,
                  text: '로그인',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.login();
                    }
                  },
                  isLoading: loginState.isLoading,
                ),

                AppSpacing.verticalSpaceLG,

                // 💡 안내 문구
                Center(
                  child: Text(
                    '세종대학교 포털 계정으로 로그인해요',
                    style: AppTextStyles.captionRegular10.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
