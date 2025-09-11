import 'dart:async';

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

/// 전화번호 인증 진행 단계
enum VerificationStep {
  inputInfo, // 정보 입력 단계
  verifyPhone, // 전화번호 인증 단계
  completed, // 인증 완료 단계
}

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
  bool _isStudentLogin = true; // true: 학번 로그인, false: 게스트 로그인
  bool _rememberMe = false;

  // 게스트 로그인용 추가 컨트롤러들
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _verificationFocusNode = FocusNode();

  // 전화번호 인증 상태 관리
  VerificationStep _currentStep = VerificationStep.inputInfo;
  int _remainingSeconds = 180; // 3분 = 180초
  Timer? _verificationTimer;

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

    // 게스트 로그인 관련 컨트롤러들 정리
    _phoneController.dispose();
    _nameController.dispose();
    _verificationCodeController.dispose();
    _phoneFocusNode.dispose();
    _nameFocusNode.dispose();
    _verificationFocusNode.dispose();

    // 애니메이션 및 타이머 정리
    _fadeController.dispose();
    _slideController.dispose();
    _verificationTimer?.cancel();
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

  // ===== 게스트 로그인 관련 검증 메서드들 =====

  /// 전화번호 검증 - 한국 형식 (010-0000-0000)
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요 📱';
    }

    // 하이픈 제거 후 검증
    final cleanPhone = value.replaceAll('-', '').replaceAll(' ', '');

    if (!RegExp(r'^010[0-9]{8}$').hasMatch(cleanPhone)) {
      return '올바른 전화번호 형식을 입력해주세요 (010-0000-0000)';
    }

    return null;
  }

  /// 한글 이름 검증 (2~4글자)
  String? _validateKoreanName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요 😊';
    }

    if (value.length < 2 || value.length > 4) {
      return '2~4글자의 이름을 입력해주세요';
    }

    if (!RegExp(r'^[가-힣]+$').hasMatch(value)) {
      return '한글 이름을 입력해주세요';
    }

    return null;
  }

  /// 인증번호 검증 (6자리 숫자)
  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return '인증번호를 입력해주세요 🔢';
    }

    if (value.length != 6) {
      return '6자리 인증번호를 입력해주세요';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return '숫자만 입력 가능해요';
    }

    return null;
  }

  /// 시간 포맷 (초 → MM:SS)
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // ===== 게스트 로그인 관련 핸들러 메서드들 =====

  /// 인증번호 발송 처리 - SMS의 마법! ✨
  Future<void> _handleSendVerificationCode() async {
    // 폼 검증부터 확인
    if (!_formKey.currentState!.validate()) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '입력하신 정보를 다시 확인해주세요! 📝');
      return;
    }

    try {
      // 실제 SMS 발송 로직은 향후 AuthController에 위임 예정
      // 현재는 UI 플로우만 구현 - SMS API 연동 예정
      await Future.delayed(Duration(seconds: 2)); // API 호출 시뮬레이션

      if (!mounted) return;

      // 성공적으로 발송됐다고 가정
      setState(() {
        _currentStep = VerificationStep.verifyPhone;
        _remainingSeconds = 180; // 3분 타이머 시작
      });

      // 타이머 시작
      _startVerificationTimer();

      UiUtils.showSuccessSnackBar(
        context,
        '📱 ${_phoneController.text}로 인증번호를 발송했어요!',
      );

      // 인증번호 입력 필드로 포커스 이동
      _verificationFocusNode.requestFocus();
    } catch (e) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '인증번호 발송에 실패했습니다. 잠시 후 다시 시도해주세요! 📶');
    }
  }

  /// 전화번호 인증 처리 - 숫자 6자리의 마법! 🔢
  Future<void> _handleVerifyPhone() async {
    // 인증번호 검증
    if (_verificationCodeController.text.length != 6) {
      UiUtils.showErrorSnackBar(context, '6자리 인증번호를 입력해주세요! 🔢');
      return;
    }

    try {
      // 실제 인증 확인 로직은 향후 AuthController에 위임 예정
      // 현재는 UI 플로우만 구현 - SMS 인증 API 연동 예정
      await Future.delayed(Duration(seconds: 2)); // API 호출 시뮬레이션

      if (!mounted) return;

      // 타이머 정리
      _verificationTimer?.cancel();

      // 인증 성공
      setState(() {
        _currentStep = VerificationStep.completed;
      });

      UiUtils.showSuccessSnackBar(
        context,
        '🎉 인증이 완료되었습니다! ${_nameController.text}님 환영해요!',
      );
    } catch (e) {
      if (!mounted) return;
      UiUtils.showErrorSnackBar(context, '인증번호가 올바르지 않습니다. 다시 확인해주세요! 🔍');
    }
  }

  /// 인증 타이머 시작
  void _startVerificationTimer() {
    _verificationTimer?.cancel(); // 기존 타이머 정리

    _verificationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        // 타이머 종료 시 재전송 가능하다고 안내
        if (mounted) {
          UiUtils.showErrorSnackBar(context, '⏰ 인증 시간이 만료되었습니다. 재전송을 눌러주세요!');
        }
      }
    });
  }

  /// 로그인 방식 토글 (학번 ↔ 게스트)
  void _toggleLoginMode() {
    setState(() {
      _isStudentLogin = !_isStudentLogin;
      // 모드 변경 시 폼 초기화
      _studentIdController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _nameController.clear();
      _verificationCodeController.clear();

      // 게스트 모드 상태 초기화
      _currentStep = VerificationStep.inputInfo;
      _remainingSeconds = 180;
      _verificationTimer?.cancel();
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
          _isStudentLogin ? '학번과 비밀번호로 로그인하세요' : '전화번호로 간편하게 시작하세요',
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
      child: _isStudentLogin
          ? _buildStudentIdLoginForm(authController)
          : _buildGuestLoginForm(authController),
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

  /// 게스트 로그인 폼 - 전화번호로 간편하게! 📱
  Widget _buildGuestLoginForm(AuthController authController) {
    final isLoading = authController.status == AuthStatus.authenticating;

    switch (_currentStep) {
      case VerificationStep.inputInfo:
        return _buildGuestInfoStep(isLoading);
      case VerificationStep.verifyPhone:
        return _buildVerificationStep(isLoading);
      case VerificationStep.completed:
        return _buildCompletionStep(isLoading);
    }
  }

  /// 1단계: 전화번호와 이름 입력
  Widget _buildGuestInfoStep(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 게스트 로그인 타이틀
          Text(
            '게스트로 시작하기',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // 전화번호 입력 필드
          AppTextField(
            controller: _phoneController,
            focusNode: _phoneFocusNode,
            enabled: !isLoading,
            labelText: '전화번호',
            hintText: '010-0000-0000',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: _validatePhoneNumber,
            onSubmitted: (_) => _nameFocusNode.requestFocus(),
          ),

          SizedBox(height: 16.h),

          // 이름 입력 필드
          AppTextField(
            controller: _nameController,
            focusNode: _nameFocusNode,
            enabled: !isLoading,
            labelText: '이름',
            hintText: '홍길동',
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: _validateKoreanName,
            onSubmitted: (_) => _handleSendVerificationCode(),
          ),

          SizedBox(height: 24.h),

          // 인증번호 발송 버튼
          AppButton.primary(
            text: '인증번호 받기',
            onPressed: isLoading ? null : _handleSendVerificationCode,
            isLoading: isLoading,
            isExpanded: true,
            size: AppButtonSize.large,
          ),

          SizedBox(height: 16.h),

          // 게스트 안내
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.brandCrimsonLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 24.w,
                  color: AppColors.brandCrimson,
                ),
                SizedBox(height: 8.h),
                Text(
                  '📱 게스트로 가입하시면 기본 정보를 볼 수 있어요!\n더 많은 기능을 원하시면 학번 로그인을 이용해주세요',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.brandCrimson,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2단계: 인증번호 입력
  Widget _buildVerificationStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 인증 단계 타이틀
        Text(
          '인증번호를 입력해주세요',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        // 인증번호 발송 안내
        Text(
          '${_phoneController.text}로\n인증번호를 발송했어요! 📱',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 24.h),

        // 인증번호 입력 필드
        AppTextField(
          controller: _verificationCodeController,
          focusNode: _verificationFocusNode,
          enabled: !isLoading,
          labelText: '인증번호',
          hintText: '6자리 숫자를 입력하세요',
          prefixIcon: Icons.lock_outline,
          keyboardType: TextInputType.number,
          validator: _validateVerificationCode,
          maxLength: 6,
          onSubmitted: (_) => _handleVerifyPhone(),
        ),

        SizedBox(height: 16.h),

        // 타이머 표시
        if (_remainingSeconds > 0)
          Text(
            '남은 시간: ${_formatTime(_remainingSeconds)}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

        SizedBox(height: 24.h),

        // 인증 확인 버튼
        AppButton.primary(
          text: '인증 완료',
          onPressed: isLoading ? null : _handleVerifyPhone,
          isLoading: isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
        ),

        SizedBox(height: 16.h),

        // 재전송 버튼
        Center(
          child: TextButton(
            onPressed: _remainingSeconds == 0
                ? _handleSendVerificationCode
                : null,
            child: Text(
              _remainingSeconds > 0 ? '인증번호가 오지 않았나요?' : '인증번호 재전송',
              style: TextStyle(
                fontSize: 14.sp,
                color: _remainingSeconds == 0
                    ? AppColors.brandCrimson
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 3단계: 인증 완료
  Widget _buildCompletionStep(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 완료 아이콘
        Center(
          child: Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 40.w, color: Colors.white),
          ),
        ),

        SizedBox(height: 24.h),

        // 완료 메시지
        Text(
          '인증이 완료되었습니다!',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 16.h),

        Text(
          '🎉 ${_nameController.text}님, 환영합니다!\n이제 세종 캐치를 이용하실 수 있어요',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 32.h),

        // 시작하기 버튼
        AppButton.primary(
          text: '세종 캐치 시작하기',
          onPressed: isLoading ? null : () => _navigateAfterLogin(),
          isLoading: isLoading,
          isExpanded: true,
          size: AppButtonSize.large,
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
            isSelected: _isStudentLogin,
            onTap: () => _isStudentLogin ? null : _toggleLoginMode(),
          ),
          _buildToggleButton(
            text: '게스트',
            icon: Icons.phone,
            isSelected: !_isStudentLogin,
            onTap: () => !_isStudentLogin ? null : _toggleLoginMode(),
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
