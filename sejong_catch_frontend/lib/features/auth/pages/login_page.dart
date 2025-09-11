import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/buttons/app_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../core/routing/routes.dart';
import '../../../domain/controllers/auth_controller.dart';

/// 세종 캐치의 세련된 로그인 페이지
///
/// 세종대학교 학생들을 위한 특별한 로그인 경험을 제공합니다.
/// 치킨과 야식을 좋아하는 개발자가 만든 페이지예요! 🍗
class LoginPage extends StatefulWidget {
  /// 로그인 후 리다이렉트할 URL (선택사항)
  final String? redirectUrl;

  const LoginPage({super.key, this.redirectUrl});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // 폼 관련 컨트롤러들
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // 애니메이션 컨트롤러들 (세련된 진입 애니메이션용)
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // UI 상태 변수들
  bool _isEmailLogin = true; // true: 이메일 로그인, false: 학생 인증
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startEntryAnimation();
  }

  @override
  void dispose() {
    // 메모리 누수 방지 - 컨트롤러들 정리
    _studentIdController.dispose();
    _passwordController.dispose();
    _studentIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  /// 애니메이션 설정 - 부드러운 진입 효과
  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  /// 페이지 진입 애니메이션 시작
  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _fadeController.forward();
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  /// 학번 로그인 처리 - 세종대생만의 특권! 🎓
  Future<void> _handleStudentIdLogin() async {
    // 폼 검증부터 확인 (기초가 중요하죠!)
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '입력하신 정보를 다시 확인해주세요! 📝');
      return;
    }

    final authController = context.read<AuthController>();

    try {
      // AuthController의 진짜 로그인 메서드 호출 (학번을 이메일 형식으로 변환)
      final studentEmail = '${_studentIdController.text.trim()}@sejong.ac.kr';
      final success = await authController.loginWithEmail(
        studentEmail,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        // 로그인 성공! 🎉 치킨 한 마리 각이다!
        UiUtils.showSuccessSnackBar(context, '환영합니다! 세종 캐치와 함께해요 🎓✨');

        // 적절한 페이지로 리다이렉트
        _navigateAfterLogin();
      } else {
        // 로그인 실패 ㅠㅠ
        UiUtils.showErrorSnackBar(
          context,
          authController.errorMessage ?? '로그인에 실패했습니다. 다시 시도해주세요.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요! 📶');
    }
  }

  /// 세종대 학생 인증 로그인 처리 - 원터치의 마법! ⚡
  Future<void> _handleStudentAuth() async {
    final authController = context.read<AuthController>();

    try {
      final success = await authController.loginWithStudentAuth();

      if (!mounted) return;

      if (success) {
        UiUtils.showSuccessSnackBar(
          context,
          '세종대학교 학생 인증 완료! 🎓 이제 모든 기능을 사용할 수 있어요!',
        );
        _navigateAfterLogin();
      } else {
        UiUtils.showErrorSnackBar(
          context,
          authController.errorMessage ?? '학생 인증에 실패했습니다.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '학생 인증 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  /// 로그인 후 적절한 페이지로 네비게이션
  void _navigateAfterLogin() {
    if (widget.redirectUrl != null && widget.redirectUrl!.isNotEmpty) {
      // 리다이렉트 URL이 있으면 해당 페이지로
      context.go(widget.redirectUrl!);
    } else {
      // 기본적으로 메인 피드로 이동
      context.go(AppRoutes.feed);
    }
  }

  /// 로그인 방식 토글 (학번 ↔ 학생인증)
  void _toggleLoginMode() {
    setState(() {
      _isEmailLogin = !_isEmailLogin;
      // 모드 변경 시 폼 초기화
      _studentIdController.clear();
      _passwordController.clear();
    });

    // 부드러운 전환을 위한 미세 애니메이션
    _slideController.reset();
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          // 그라데이션 배경 - 세종대스럽고 세련되게!
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.brandCrimsonLight, AppColors.white],
                stops: [0.0, 0.4],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(authController),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 메인 콘텐츠 구성
  Widget _buildContent(AuthController authController) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 여백
            SizedBox(height: 40.h),

            // 로고 및 타이틀 섹션
            _buildHeader(),

            // 메인 로그인 카드
            SizedBox(height: 40.h),
            _buildLoginCard(authController),

            // 로그인 방식 전환
            SizedBox(height: 24.h),
            _buildModeToggle(),

            // 하단 정보
            SizedBox(height: 32.h),
            _buildFooter(),

            // 하단 여백
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  /// 헤더 섹션 - 브랜딩이 느껴지는 타이틀
  Widget _buildHeader() {
    return Column(
      children: [
        // 세종대학교 공식 로고
        // 가장 간결한 형태 (정사각)
        Image.asset(
          'assets/sejong-logo.png',
          width: 80.w,
          height: 80.w, // 정사각 유지
          fit: BoxFit.contain,
        ),

        SizedBox(height: 20.h),

        // 앱 타이틀
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

        // 서브 타이틀
        Text(
          _isEmailLogin ? '학번과 비밀번호로 로그인하세요' : '세종대학교 학생 인증으로 간편하게',
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

  /// 로그인 카드 - 메인 기능들이 들어가는 곳
  Widget _buildLoginCard(AuthController authController) {
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
      child: _isEmailLogin
          ? _buildStudentIdLoginForm(authController)
          : _buildStudentAuthContent(authController),
    );
  }

  /// 학번 로그인 폼 - 세종대생들만의 특권! 🎓
  Widget _buildStudentIdLoginForm(AuthController authController) {
    final isLoading = authController.status == AuthStatus.authenticating;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 폼 타이틀
          Text(
            '학번으로 로그인',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // 학번 입력 필드 - 세종대생만의 특별함!
          AppTextField(
            controller: _studentIdController,
            focusNode: _studentIdFocusNode,
            enabled: !isLoading,
            labelText: '학번',
            hintText: '학번을 입력하세요 (예: 20240001)',
            prefixIcon: Icons.person,
            keyboardType: TextInputType.number,
            validator: AppValidators.studentId,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          SizedBox(height: 16.h),

          // 비밀번호 입력 필드 - 보안도 완벽!
          AppTextField.password(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            enabled: !isLoading,
            validator: AppValidators.requiredPassword,
            onSubmitted: (_) => _handleStudentIdLogin(),
          ),

          SizedBox(height: 20.h),

          // 기억하기 체크박스
          _buildRememberMeCheckbox(isLoading),

          SizedBox(height: 24.h),

          // 로그인 버튼 - AppButton의 위엄!
          AppButton.primary(
            text: '로그인',
            onPressed: isLoading ? null : _handleStudentIdLogin,
            isLoading: isLoading,
            isExpanded: true,
            size: AppButtonSize.large,
          ),

          SizedBox(height: 16.h),

          // 비밀번호 찾기 (나중에 구현)
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: 비밀번호 찾기 페이지로 이동
                UiUtils.showErrorSnackBar(
                  context,
                  '비밀번호 찾기 기능은 곧 추가될 예정입니다! 🔧',
                );
              },
              child: Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.brandCrimson,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 세종대 학생 인증 콘텐츠 - 원터치의 편리함!
  Widget _buildStudentAuthContent(AuthController authController) {
    final isLoading = authController.status == AuthStatus.authenticating;

    return Column(
      children: [
        // 학생 인증 타이틀
        Text(
          '세종대학교 학생 인증',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        // 인증 설명
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.brandCrimsonLight,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.verified_user,
                size: 32.w,
                color: AppColors.brandCrimson,
              ),
              SizedBox(height: 12.h),
              Text(
                '세종대학교 포털과 연동하여\n안전하고 간편하게 인증해요',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.brandCrimson,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // 학생 인증 버튼
        AppButton(
          text: '세종대 학생 인증하기',
          onPressed: isLoading ? null : _handleStudentAuth,
          isLoading: isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
          leftIcon: Icons.school,
          backgroundColor: AppColors.brandCrimson,
          textColor: Colors.white,
        ),

        SizedBox(height: 16.h),

        // 인증 혜택 안내
        Text(
          '🎓 학생 인증 시 맞춤형 추천과\n대기열 기능을 모두 이용할 수 있어요!',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 로그인 기억하기 체크박스
  Widget _buildRememberMeCheckbox(bool isLoading) {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: Checkbox(
            value: _rememberMe,
            onChanged: isLoading
                ? null
                : (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
            activeColor: AppColors.brandCrimson,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            '로그인 상태 유지 (공용 컴퓨터에서는 체크 해제)',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  /// 로그인 방식 전환 토글
  Widget _buildModeToggle() {
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
            text: '학번 로그인',
            icon: Icons.person,
            isSelected: _isEmailLogin,
            onTap: () => _isEmailLogin ? null : _toggleLoginMode(),
          ),
          _buildToggleButton(
            text: '학생 인증',
            icon: Icons.school,
            isSelected: !_isEmailLogin,
            onTap: () => !_isEmailLogin ? null : _toggleLoginMode(),
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

  /// 하단 푸터 - 친근한 안내 메시지
  Widget _buildFooter() {
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

        // 게스트 모드 안내
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.w,
                color: AppColors.brandCrimson,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  '로그인하지 않아도 일부 정보를 볼 수 있어요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // 게스트로 계속하기
                  context.go(AppRoutes.feed);
                },
                child: Text(
                  '게스트로 계속',
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
