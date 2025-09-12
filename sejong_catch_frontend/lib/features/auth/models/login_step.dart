/// 토스 스타일 단계별 로그인을 위한 상태 모델들
/// 
/// 세종 캐치의 로그인 플로우는 토스처럼 매끄럽고 직관적으로 설계되어 있습니다.
/// 각 단계마다 명확한 목적과 검증 로직을 가지고 있어요! 🚀
library;

/// 로그인 단계 - 토스 스타일 단계별 입력을 위한 enum
/// 
/// 두 가지 로그인 방식을 지원합니다:
/// - 학번 로그인: 세종대학교 재학생을 위한 공식 로그인
/// - 게스트 로그인: 전화번호 인증을 통한 간편 로그인
enum LoginStep {
  // ===== 학번 로그인 플로우 =====
  
  /// 세종대 계정 입력 단계 (학번, 이메일, 아이디 등 자유 형식)
  studentIdInput,
  
  /// 비밀번호 입력 단계
  passwordInput,
  
  /// 학번 로그인 처리 중 (서버 인증 진행)
  studentLoginLoading,
  
  // ===== 게스트 로그인 플로우 =====
  
  /// 전화번호 입력 단계 (010-0000-0000 형식)
  phoneInput,
  
  /// 이름 입력 단계 (실명 입력)
  nameInput,
  
  /// 인증번호 발송 완료 상태 (SMS 발송 성공)
  verificationSent,
  
  /// 인증번호 입력 단계 (6자리 숫자)
  verificationInput,
  
  /// 게스트 로그인 처리 중 (인증번호 확인 진행)
  guestLoginLoading,
  
  // ===== 공통 완료 상태 =====
  
  /// 로그인 완료 (성공 애니메이션 표시 후 메인 페이지 이동)
  completed,
}

/// 전화번호 인증 진행 단계 (기존 코드와의 호환성을 위해 유지)
/// 
/// 이 enum은 게스트 로그인에서 전화번호 인증 상태를 추적합니다.
/// LoginStep과 중복되는 부분이 있지만, 기존 코드 호환성을 위해 유지해요.
enum VerificationStep {
  /// 정보 입력 단계 (전화번호, 이름 입력)
  inputInfo,
  
  /// 전화번호 인증 단계 (SMS 인증번호 입력)
  verifyPhone,
  
  /// 인증 완료 단계
  completed,
}

/// LoginStep 확장 메서드 - 단계별 유틸리티 기능들
/// 
/// 각 단계에 대한 정보를 쉽게 가져올 수 있는 편의 메서드들입니다.
extension LoginStepExtension on LoginStep {
  /// 현재 단계의 진행률 계산 (토스 스타일 프로그레스 바용)
  /// 
  /// 반환값: 0.0 ~ 1.0 사이의 진행률
  double get progress {
    switch (this) {
      case LoginStep.studentIdInput:
      case LoginStep.phoneInput:
        return 0.2; // 20% - 시작 단계
      
      case LoginStep.passwordInput:
      case LoginStep.nameInput:
        return 0.5; // 50% - 중간 단계
      
      case LoginStep.verificationSent:
      case LoginStep.verificationInput:
        return 0.8; // 80% - 거의 완료
      
      case LoginStep.studentLoginLoading:
      case LoginStep.guestLoginLoading:
        return 0.9; // 90% - 처리 중
      
      case LoginStep.completed:
        return 1.0; // 100% - 완료!
    }
  }
  
  /// 현재 단계의 제목 텍스트
  /// 
  /// 사용자에게 보여줄 명확하고 친근한 제목입니다.
  String get title {
    switch (this) {
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
  
  /// 현재 단계의 서브타이틀 (설명 텍스트)
  /// 
  /// 사용자가 무엇을 해야 하는지 명확히 안내하는 설명입니다.
  String getSubtitle({String? phoneNumber}) {
    switch (this) {
      case LoginStep.studentIdInput:
        return '학번, 이메일 또는 아이디로 로그인하세요';
      
      case LoginStep.passwordInput:
        return '비밀번호를 정확히 입력해주세요';
      
      case LoginStep.phoneInput:
        return '010-0000-0000 형식으로 입력해주세요';
      
      case LoginStep.nameInput:
        return '실명을 정확히 입력해주세요';
      
      case LoginStep.verificationSent:
        return phoneNumber != null 
            ? '$phoneNumber로 인증번호를 보냈어요'
            : '인증번호를 발송했어요';
      
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
  /// 
  /// 첫 단계나 로딩 중일 때는 뒤로갈 수 없습니다.
  bool get canGoBack {
    switch (this) {
      case LoginStep.studentIdInput:
      case LoginStep.phoneInput:
      case LoginStep.studentLoginLoading:
      case LoginStep.guestLoginLoading:
      case LoginStep.completed:
        return false; // 뒤로가기 불가능
      
      default:
        return true; // 뒤로가기 가능
    }
  }
  
  /// 이전 단계 계산
  /// 
  /// 뒤로가기 버튼을 눌렀을 때 이동할 단계를 반환합니다.
  LoginStep? get previousStep {
    if (!canGoBack) return null;
    
    switch (this) {
      case LoginStep.passwordInput:
        return LoginStep.studentIdInput;
      
      case LoginStep.nameInput:
        return LoginStep.phoneInput;
      
      case LoginStep.verificationInput:
        return LoginStep.nameInput;
      
      default:
        return null; // 이전 단계 없음
    }
  }
  
  /// 학생 로그인 플로우 여부 확인
  /// 
  /// 현재 단계가 학생 로그인에 속하는지 확인합니다.
  bool get isStudentFlow {
    switch (this) {
      case LoginStep.studentIdInput:
      case LoginStep.passwordInput:
      case LoginStep.studentLoginLoading:
        return true;
      
      default:
        return false;
    }
  }
  
  /// 게스트 로그인 플로우 여부 확인
  /// 
  /// 현재 단계가 게스트 로그인에 속하는지 확인합니다.
  bool get isGuestFlow {
    switch (this) {
      case LoginStep.phoneInput:
      case LoginStep.nameInput:
      case LoginStep.verificationSent:
      case LoginStep.verificationInput:
      case LoginStep.guestLoginLoading:
        return true;
      
      default:
        return false;
    }
  }
  
  /// 로딩 단계 여부 확인
  /// 
  /// 현재 단계가 로딩 중인지 확인합니다. (사용자 입력 불가 상태)
  bool get isLoading {
    switch (this) {
      case LoginStep.studentLoginLoading:
      case LoginStep.guestLoginLoading:
        return true;
      
      default:
        return false;
    }
  }
}