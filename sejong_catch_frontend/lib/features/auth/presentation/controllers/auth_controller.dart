/// 🔐 인증 컨트롤러 (Riverpod Notifier)
///
/// 참조: claudedocs/AUTH_API_SPEC.md
/// 로그인/로그아웃 상태 관리
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스 + copyWith
/// ✅ @riverpod 어노테이션으로 자동 생성
/// ✅ 모든 상태 변경은 copyWith()로 불변성 보장

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/exceptions/auth_exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';

part 'auth_controller.g.dart';

// ═══════════════════════════════════════════════════
// 🎯 인증 상태 클래스 (State)
// ═══════════════════════════════════════════════════

/// 인증 상태
///
/// CLAUDE.md 원칙: Freezed 없이 일반 클래스로 불변 상태 구현
class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  /// 로그인 여부 (computed property)
  bool get isLoggedIn => user != null;

  /// copyWith (불변 업데이트)
  ///
  /// 사용 예시:
  /// ```dart
  /// state = state.copyWith(isLoading: true, error: null);
  /// ```
  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }

  /// 로그아웃 상태로 초기화
  AuthState logout() {
    return const AuthState(
      isLoading: false,
      user: null,
      error: null,
    );
  }

  @override
  String toString() =>
      'AuthState(isLoading: $isLoading, user: $user, error: $error)';
}

// ═══════════════════════════════════════════════════
// 🎛️ 인증 컨트롤러 (Notifier)
// ═══════════════════════════════════════════════════

/// 인증 컨트롤러
///
/// 참조: AUTH_API_SPEC.md - 로그인/로그아웃 플로우
/// @riverpod 어노테이션으로 authControllerProvider 자동 생성
@riverpod
class AuthController extends _$AuthController {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    // Repository 주입
    _repository = ref.read(authRepositoryProvider);

    // 앱 시작 시 로그인 상태 확인
    checkLoginStatus();

    // 초기 상태
    return const AuthState();
  }

  /// 앱 시작 시 로그인 상태 확인
  ///
  /// TokenRepository에 Access Token이 있으면 로그인 상태로 설정
  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await _repository.isLoggedIn();

      if (isLoggedIn) {
        // 토큰이 있으면 프로필 조회
        final user = await _repository.getMyProfile();
        state = state.copyWith(user: user);
      }
    } catch (e) {
      // 토큰이 만료되었거나 유효하지 않으면 로그아웃 처리
      state = state.logout();
    }
  }

  /// 학생 로그인
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/login
  /// [studentId]: 세종대 학번
  /// [password]: 세종대 포털 비밀번호
  Future<void> login(String studentId, String password) async {
    // 로딩 시작
    state = state.copyWith(isLoading: true, error: null);

    try {
      // API 호출
      final user = await _repository.login(studentId, password);

      // 성공: 사용자 정보 저장
      state = state.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } on ValidationException catch (e) {
      // 400: 입력 검증 실패
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on UnauthorizedException catch (e) {
      // 401: 인증 실패 (학번 또는 비밀번호 불일치)
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on RateLimitException catch (e) {
      // 429: 너무 많은 로그인 시도
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on NetworkException catch (e) {
      // 네트워크 연결 오류
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      // 기타 오류
      state = state.copyWith(
        isLoading: false,
        error: '로그인 중 오류가 발생했습니다. 다시 시도해주세요.',
      );
    }
  }

  /// 로그아웃
  ///
  /// 참조: AUTH_API_SPEC.md - POST /api/auth/logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // 서버에 로그아웃 요청 + 로컬 토큰 삭제
      await _repository.logout();

      // 성공: 상태 초기화
      state = state.logout();
    } catch (e) {
      // 에러가 발생해도 로컬 상태는 초기화
      state = state.logout();
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}
