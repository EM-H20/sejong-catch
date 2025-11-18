import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/response/login_response.dart';

part 'auth_state.freezed.dart';

/// 인증 상태 모델
///
/// **상태**:
/// - `isAuthenticated`: 로그인 여부 (백엔드 검증 완료)
/// - `currentUser`: 현재 로그인한 사용자 정보
/// - `isLoading`: 로그인 상태 체크 중
/// - `error`: 에러 메시지 (있을 경우)
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(null) UserDto? currentUser,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _AuthState;

  /// 초기 상태 (앱 시작 시)
  factory AuthState.initial() => const AuthState();

  /// 로딩 중 상태
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// 로그인됨 상태
  factory AuthState.authenticated(UserDto user) => AuthState(
        isAuthenticated: true,
        currentUser: user,
        isLoading: false,
      );

  /// 로그아웃됨 상태
  factory AuthState.unauthenticated() => const AuthState(
        isAuthenticated: false,
        currentUser: null,
        isLoading: false,
      );

  /// 에러 상태
  factory AuthState.error(String message) => AuthState(
        isAuthenticated: false,
        currentUser: null,
        isLoading: false,
        error: message,
      );
}
