import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// 로그인 화면의 상태를 관리하는 모델
///
/// Freezed를 사용하여 불변성 보장 및 copyWith 자동 생성
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? error,

    /// 세종대 포털 아이디
    @Default('') String studentId,

    /// 세종대 포털 비밀번호
    @Default('') String password,

    /// 로그인 성공 여부
    @Default(false) bool isLoggedIn,
  }) = _LoginState;
}
