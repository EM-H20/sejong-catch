/// 로그인 화면의 상태를 관리하는 모델
///
/// Freezed 없이 일반 Dart 클래스로 불변성 보장
class LoginState {
  /// 로딩 상태
  final bool isLoading;

  /// 에러 메시지
  final String? error;

  /// 세종대 포털 아이디
  final String studentId;

  /// 세종대 포털 비밀번호
  final String password;

  /// 로그인 성공 여부
  final bool isLoggedIn;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.studentId = '',
    this.password = '',
    this.isLoggedIn = false,
  });

  /// copyWith 메서드 - 불변 상태 업데이트용
  LoginState copyWith({
    bool? isLoading,
    String? error,
    String? studentId,
    String? password,
    bool? isLoggedIn,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      studentId: studentId ?? this.studentId,
      password: password ?? this.password,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  /// 에러 초기화 헬퍼
  LoginState clearError() {
    return copyWith(error: null);
  }

  /// 로딩 시작 헬퍼
  LoginState startLoading() {
    return copyWith(isLoading: true, error: null);
  }

  /// 로딩 종료 헬퍼
  LoginState stopLoading() {
    return copyWith(isLoading: false);
  }
}
