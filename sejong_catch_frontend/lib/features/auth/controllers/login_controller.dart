import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/routes.dart';
import '../../../domain/controllers/auth_controller.dart';
import '../models/login_step.dart';
import '../services/validation_service.dart';

/// 로그인 페이지의 모든 상태와 로직을 관리하는 컨트롤러
/// 
/// 기존 login_page.dart에서 1000줄이 넘던 로직을 깔끔하게 분리했어요!
/// 이제 로그인 페이지는 진짜 "토스급 클린 코드"가 되었습니다! ✨
class LoginController extends ChangeNotifier {
  // === 의존성 주입 ===
  final AuthController _authController;
  
  LoginController({
    required AuthController authController,
  }) : _authController = authController;

  // === 폼 컨트롤러들 - 텍스트 입력 관리 ===
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  // === 포커스 노드들 - 키보드 포커스 관리 ===
  final _studentIdFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _verificationFocusNode = FocusNode();

  // === 상태 변수들 ===
  bool _isStudentLogin = true; // true: 학번 로그인, false: 게스트 로그인
  bool _rememberMe = false;
  LoginStep _currentLoginStep = LoginStep.studentIdInput;
  
  // === 인증 타이머 관리 ===
  int _remainingSeconds = 180; // 3분 = 180초
  Timer? _verificationTimer;

  // === Getters - 외부에서 상태에 읽기 전용 접근 ===
  
  // 폼 컨트롤러들
  TextEditingController get studentIdController => _studentIdController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get nameController => _nameController;
  TextEditingController get verificationCodeController => _verificationCodeController;

  // 포커스 노드들
  FocusNode get studentIdFocusNode => _studentIdFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;
  FocusNode get phoneFocusNode => _phoneFocusNode;
  FocusNode get nameFocusNode => _nameFocusNode;
  FocusNode get verificationFocusNode => _verificationFocusNode;

  // 상태 정보
  bool get isStudentLogin => _isStudentLogin;
  bool get rememberMe => _rememberMe;
  LoginStep get currentLoginStep => _currentLoginStep;
  int get remainingSeconds => _remainingSeconds;
  
  // 로딩 상태는 AuthController에서 가져옴
  bool get isLoading => _authController.status == AuthStatus.authenticating;
  
  // === 진행률 및 단계별 정보 ===
  
  /// 현재 단계에 따른 진행률 계산 (토스 스타일 프로그레스 바용)
  double getCurrentProgress() {
    switch (_currentLoginStep) {
      case LoginStep.studentIdInput:
      case LoginStep.phoneInput:
        return 0.2; // 20%
      case LoginStep.passwordInput:
      case LoginStep.nameInput:
        return 0.5; // 50%
      case LoginStep.verificationSent:
      case LoginStep.verificationInput:
        return 0.8; // 80%
      case LoginStep.studentLoginLoading:
      case LoginStep.guestLoginLoading:
        return 0.9; // 90%
      case LoginStep.completed:
        return 1.0; // 100%
    }
  }

  /// 현재 단계에 따른 제목 텍스트
  String getCurrentStepTitle() {
    switch (_currentLoginStep) {
      case LoginStep.studentIdInput:
        return '세종대 계정을 입력해주세요';
      case LoginStep.passwordInput:
        return '비밀번호를 입력해주세요';
      case LoginStep.phoneInput:
        return '전화번호를 입력해주세요';
      case LoginStep.nameInput:
        return '이름을 알려주세요';
      case LoginStep.verificationSent:
        return '인증번호를 발송했어요!';
      case LoginStep.verificationInput:
        return '인증번호를 입력해주세요';
      case LoginStep.studentLoginLoading:
        return '로그인 중이에요...';
      case LoginStep.guestLoginLoading:
        return '인증 중이에요...';
      case LoginStep.completed:
        return '환영합니다! 🎉';
    }
  }

  /// 현재 단계에 따른 서브 타이틀
  String getCurrentStepSubtitle() {
    switch (_currentLoginStep) {
      case LoginStep.studentIdInput:
        return '학번, 이메일 또는 아이디로 로그인하세요';
      case LoginStep.passwordInput:
        return '비밀번호를 정확히 입력해주세요';
      case LoginStep.phoneInput:
        return '010-0000-0000 형식으로 입력해주세요';
      case LoginStep.nameInput:
        return '실명을 정확히 입력해주세요';
      case LoginStep.verificationSent:
        return '${_phoneController.text}로 인증번호를 보냈어요';
      case LoginStep.verificationInput:
        return '6자리 숫자를 입력하세요';
      case LoginStep.studentLoginLoading:
        return '세종대 시스템에 인증 중이에요...';
      case LoginStep.guestLoginLoading:
        return '인증번호를 확인하고 있어요...';
      case LoginStep.completed:
        return '세종 캐치에 오신 것을 환영합니다!';
    }
  }

  /// 뒤로가기 가능 여부 확인
  bool canGoBack() {
    switch (_currentLoginStep) {
      case LoginStep.studentIdInput:
      case LoginStep.phoneInput:
      case LoginStep.studentLoginLoading:
      case LoginStep.guestLoginLoading:
      case LoginStep.completed:
        return false;
      default:
        return true;
    }
  }

  // === 상태 변경 메서드들 ===

  /// 로그인 방식 토글 (학번 ↔ 게스트)
  void toggleLoginMode() {
    _isStudentLogin = !_isStudentLogin;

    // 모드 변경 시 폼 초기화
    _clearAllFields();

    // 단계 초기화
    if (_isStudentLogin) {
      _currentLoginStep = LoginStep.studentIdInput;
    } else {
      _currentLoginStep = LoginStep.phoneInput;
    }

    // 게스트 모드 타이머 초기화
    _remainingSeconds = 180;
    _verificationTimer?.cancel();

    notifyListeners();
  }

  /// Remember Me 체크박스 토글
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// 다음 단계로 전환
  void goToNextStep(LoginStep nextStep) {
    _currentLoginStep = nextStep;
    notifyListeners();
  }

  /// 이전 단계로 돌아가기
  void goToPreviousStep() {
    LoginStep previousStep;

    switch (_currentLoginStep) {
      case LoginStep.passwordInput:
        previousStep = LoginStep.studentIdInput;
        break;
      case LoginStep.nameInput:
        previousStep = LoginStep.phoneInput;
        break;
      case LoginStep.verificationInput:
        previousStep = LoginStep.nameInput;
        break;
      default:
        return; // 첫 단계에서는 뒤로 갈 수 없음
    }

    _currentLoginStep = previousStep;
    notifyListeners();
  }

  // === 입력 핸들러 메서드들 (비즈니스 로직) ===

  /// 세종대 계정 입력 처리
  void handleStudentIdInput() {
    final account = _studentIdController.text.trim();

    // 최소한의 검사만 - 빈 값만 방지
    if (account.isEmpty) {
      // 에러 처리는 UI에서 담당하도록 콜백으로 전달
      return;
    }

    // 다음 단계로 전환
    goToNextStep(LoginStep.passwordInput);

    // 비밀번호 필드에 포커스
    Future.delayed(const Duration(milliseconds: 500), () {
      _passwordFocusNode.requestFocus();
    });
  }

  /// 비밀번호 입력 및 실제 로그인 처리
  Future<void> handlePasswordInput({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final password = _passwordController.text;

    // 비밀번호 유효성 검사
    if (password.isEmpty) {
      onError('비밀번호를 입력해주세요! 🔐');
      return;
    }

    if (password.length < 4) {
      onError('비밀번호가 너무 짧습니다');
      return;
    }

    // 로딩 단계로 전환
    goToNextStep(LoginStep.studentLoginLoading);

    try {
      // 세종대 계정으로 로그인 - 사용자 입력값을 그대로 사용
      final account = _studentIdController.text.trim();
      
      final success = await _authController.loginWithEmail(account, password);

      if (success) {
        // 성공 단계로 전환
        goToNextStep(LoginStep.completed);

        // 잠시 성공 메시지를 보여준 후 네비게이션
        await Future.delayed(const Duration(milliseconds: 1500));

        onSuccess();
      } else {
        // 실패 시 비밀번호 입력 단계로 되돌리기
        goToNextStep(LoginStep.passwordInput);
        _passwordController.clear();
        _passwordFocusNode.requestFocus();

        onError(_authController.errorMessage ?? '로그인에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // 실패 시 비밀번호 입력 단계로 되돌리기
      goToNextStep(LoginStep.passwordInput);
      _passwordController.clear();
      _passwordFocusNode.requestFocus();

      onError('네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요! 📶');
    }
  }

  /// 전화번호 입력 처리
  void handlePhoneInput({
    required Function(String) onError,
  }) {
    final phone = _phoneController.text.trim();

    // ValidationService 사용
    final phoneValidation = ValidationService.validatePhoneNumber(phone);
    if (phoneValidation != null) {
      onError(phoneValidation);
      return;
    }

    // 다음 단계로 전환
    goToNextStep(LoginStep.nameInput);

    // 이름 필드에 포커스
    Future.delayed(const Duration(milliseconds: 500), () {
      _nameFocusNode.requestFocus();
    });
  }

  /// 이름 입력 처리 및 SMS 발송
  Future<void> handleNameInputAndSendSMS({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final name = _nameController.text.trim();

    // ValidationService 사용
    final nameValidation = ValidationService.validateKoreanName(name);
    if (nameValidation != null) {
      onError(nameValidation);
      return;
    }

    // SMS 발송 중 상태로 전환
    goToNextStep(LoginStep.verificationSent);

    try {
      // 실제 SMS 발송 로직은 향후 AuthService에 위임 예정
      await Future.delayed(const Duration(seconds: 2));

      // 성공적으로 발송됐다고 가정
      _remainingSeconds = 180; // 3분 타이머 시작

      // 인증번호 입력 단계로 전환
      goToNextStep(LoginStep.verificationInput);

      // 타이머 시작
      _startVerificationTimer();

      onSuccess();

      // 인증번호 입력 필드로 포커스 이동
      Future.delayed(const Duration(milliseconds: 500), () {
        _verificationFocusNode.requestFocus();
      });
    } catch (e) {
      // 실패 시 이름 입력 단계로 되돌리기
      goToNextStep(LoginStep.nameInput);
      onError('인증번호 발송에 실패했습니다. 잠시 후 다시 시도해주세요! 📶');
    }
  }

  /// 인증번호 입력 처리
  Future<void> handleVerificationInput({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final code = _verificationCodeController.text.trim();

    // ValidationService 사용
    final codeValidation = ValidationService.validateVerificationCode(code);
    if (codeValidation != null) {
      onError(codeValidation);
      return;
    }

    // 인증 처리 중 상태로 전환
    goToNextStep(LoginStep.guestLoginLoading);

    try {
      // 실제 인증 확인 로직은 향후 AuthService에 위임 예정
      await Future.delayed(const Duration(seconds: 2));

      // 타이머 정리
      _verificationTimer?.cancel();

      // 성공 단계로 전환
      goToNextStep(LoginStep.completed);

      // 잠시 성공 메시지를 보여준 후 네비게이션
      await Future.delayed(const Duration(milliseconds: 1500));

      onSuccess();
    } catch (e) {
      // 실패 시 인증번호 입력 단계로 되돌리기
      goToNextStep(LoginStep.verificationInput);
      _verificationCodeController.clear();
      _verificationFocusNode.requestFocus();

      onError('인증번호가 올바르지 않습니다. 다시 확인해주세요! 🔍');
    }
  }

  // === 네비게이션 및 완료 처리 ===

  /// 로그인 후 적절한 페이지로 네비게이션
  void navigateAfterLogin(BuildContext context, {String? redirectUrl}) {
    if (redirectUrl != null && redirectUrl.isNotEmpty) {
      // 리다이렉트 URL이 있으면 해당 페이지로
      context.go(redirectUrl);
    } else {
      // 기본적으로 메인 피드로 이동
      context.go(AppRoutes.feed);
    }
  }

  // === 타이머 관리 ===

  /// 인증 타이머 시작
  void _startVerificationTimer() {
    _verificationTimer?.cancel(); // 기존 타이머 정리

    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        // 타이머 종료는 UI에서 처리
      }
    });
  }

  // === 정리 메서드들 ===

  /// 모든 입력 필드 클리어
  void _clearAllFields() {
    _studentIdController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _nameController.clear();
    _verificationCodeController.clear();
  }

  /// 메모리 누수 방지 - dispose
  @override
  void dispose() {
    // 컨트롤러들 정리
    _studentIdController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _verificationCodeController.dispose();

    // 포커스 노드들 정리
    _studentIdFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    _nameFocusNode.dispose();
    _verificationFocusNode.dispose();

    // 타이머 정리
    _verificationTimer?.cancel();

    super.dispose();
  }
}