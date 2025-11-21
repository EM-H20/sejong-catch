import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/response/login_response.dart';
import '../models/auth_state.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/user_storage_service.dart';

part 'auth_state_controller.g.dart';

/// 앱 전역 인증 상태 관리 컨트롤러
///
/// **역할**:
/// - 앱 시작 시 자동으로 로그인 상태 체크
/// - 로그인/로그아웃 시 전역 상태 업데이트
/// - Profile 페이지 등에서 사용자 정보 제공
///
/// **상태**:
/// - `isAuthenticated`: 로그인 여부
/// - `currentUser`: 현재 사용자 정보 (UserDto)
/// - `isLoading`: 상태 체크 중
///
/// **사용처**:
/// - ProfilePage: 사용자 정보 표시
/// - AppRouter: 라우팅 가드
/// - LoginController: 로그인/로그아웃 시 상태 업데이트
@riverpod
class AuthStateController extends _$AuthStateController {
  @override
  AuthState build() {
    // 앱 시작 시 자동으로 인증 상태 체크
    _checkAuthStatus();
    return AuthState.initial();
  }

  /// 앱 시작 시 인증 상태 체크
  ///
  /// **동작**:
  /// 1. 토큰 존재 여부 확인 (FlutterSecureStorage)
  /// 2. 토큰 있으면 → SharedPreferences에서 UserDto 불러오기
  /// 3. UserDto 있으면 → 로그인 상태로 전환
  /// 4. 없으면 → 로그아웃 상태로 전환
  ///
  /// **참고**:
  /// - Real 모드에서는 GET /users/me 호출도 가능하지만
  ///   SharedPreferences 사용이 더 빠르고 오프라인 대응 가능
  Future<void> _checkAuthStatus() async {
    state = AuthState.loading();

    try {
      // 1. 토큰 확인
      final tokenStorage = ref.read(tokenStorageServiceProvider.notifier);
      final accessToken = await tokenStorage.getAccessToken();

      if (accessToken == null) {
        // 토큰 없음 → 로그아웃 상태
        state = AuthState.unauthenticated();
        return;
      }

      // 2. 사용자 정보 불러오기 (SharedPreferences)
      final userStorage = ref.read(userStorageServiceProvider.notifier);
      final user = await userStorage.getUser();

      if (user != null) {
        // 사용자 정보 있음 → 로그인 상태
        state = AuthState.authenticated(user);
      } else {
        // 토큰은 있지만 사용자 정보 없음 (비정상 상태)
        // → 토큰 삭제하고 로그아웃 상태로 전환
        await tokenStorage.clearTokens();
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // 에러 발생 시 로그아웃 상태로 전환
      state = AuthState.error('인증 상태 확인 실패');
    }
  }

  /// 로그인 성공 시 호출 (LoginController에서)
  ///
  /// **동작**:
  /// 1. AuthState를 로그인 상태로 전환
  /// 2. UserDto를 SharedPreferences에 저장
  ///
  /// **사용 예시**:
  /// ```dart
  /// // LoginController.login() 내부
  /// final authStateController = ref.read(authStateControllerProvider.notifier);
  /// authStateController.setAuthenticated(response.user);
  /// ```
  Future<void> setAuthenticated(UserDto user) async {
    try {
      // 1. 상태 업데이트
      state = AuthState.authenticated(user);

      // 2. SharedPreferences에 저장
      final userStorage = ref.read(userStorageServiceProvider.notifier);
      await userStorage.saveUser(user);
    } catch (e) {
      state = AuthState.error('사용자 정보 저장 실패');
    }
  }

  /// 로그아웃 시 호출 (LoginController에서)
  ///
  /// **동작**:
  /// 1. AuthState를 로그아웃 상태로 전환
  /// 2. SharedPreferences에서 UserDto 삭제
  ///
  /// **사용 예시**:
  /// ```dart
  /// // LoginController.logout() 내부
  /// final authStateController = ref.read(authStateControllerProvider.notifier);
  /// authStateController.setUnauthenticated();
  /// ```
  Future<void> setUnauthenticated() async {
    try {
      // 1. 상태 업데이트
      state = AuthState.unauthenticated();

      // 2. SharedPreferences에서 삭제
      final userStorage = ref.read(userStorageServiceProvider.notifier);
      await userStorage.clearUser();
    } catch (e) {
      // 삭제 실패해도 상태는 로그아웃으로 전환
      state = AuthState.unauthenticated();
    }
  }

  /// 수동으로 인증 상태 재확인
  ///
  /// **사용처**:
  /// - 사용자가 프로필 페이지 새로고침할 때
  /// - 토큰 갱신 후 상태 재확인할 때
  ///
  /// **사용 예시**:
  /// ```dart
  /// final authStateController = ref.read(authStateControllerProvider.notifier);
  /// await authStateController.refresh();
  /// ```
  Future<void> refresh() async {
    await _checkAuthStatus();
  }
}
