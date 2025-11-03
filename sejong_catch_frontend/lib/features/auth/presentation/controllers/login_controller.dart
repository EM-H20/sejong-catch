import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/services/token_storage_service.dart';
import '../models/login_state.dart';

part 'login_controller.g.dart';

/// 로그인 화면의 상태와 로직을 관리하는 컨트롤러
///
/// Riverpod Notifier 패턴으로 타입 안전성과 자동 리빌드 보장
@riverpod
class LoginController extends _$LoginController {
  @override
  LoginState build() {
    return const LoginState();
  }

  /// 학번 입력 처리
  void updateStudentId(String value) {
    state = state.copyWith(studentId: value);
  }

  /// 비밀번호 입력 처리
  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  /// 로그인 실행 (실제 API 연동)
  Future<void> login() async {
    // 유효성 검증
    if (state.studentId.isEmpty) {
      state = state.copyWith(error: '학번을 입력해주세요');
      return;
    }

    if (state.password.isEmpty) {
      state = state.copyWith(error: '비밀번호를 입력해주세요');
      return;
    }

    // 로딩 시작
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. 백엔드 API 호출 (실제 연동!)
      final authRepository = ref.read(authRepositoryProvider.notifier);
      final response = await authRepository.login(
        state.studentId,
        state.password,
      );

      // 2. 토큰 저장 (FlutterSecureStorage)
      final tokenStorage = ref.read(tokenStorageServiceProvider.notifier);
      await tokenStorage.saveTokens(
        response.accessToken,
        response.refreshToken,
      );

      // 3. 성공 상태로 업데이트
      state = state.copyWith(isLoading: false, isLoggedIn: true, error: null);

      // ✅ 로그인 성공!
      // TODO: 홈 화면으로 네비게이션 (context.go('/feed'))
    } on DioException catch (e) {
      // 네트워크 에러 처리
      String errorMessage = '로그인에 실패했어요. 학번과 비밀번호를 확인해주세요.';

      if (e.response?.statusCode == 401) {
        errorMessage = '학번 또는 비밀번호가 올바르지 않아요.';
      } else if (e.response?.statusCode == 429) {
        errorMessage = '너무 많은 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = '서버 연결에 실패했어요. 네트워크를 확인해주세요.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = '인터넷 연결을 확인해주세요.';
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      // 기타 에러 처리
      state = state.copyWith(
        isLoading: false,
        error: '알 수 없는 오류가 발생했어요. 다시 시도해주세요.',
      );
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 로그아웃
  ///
  /// **동작**:
  /// 1. AuthRepository.logout() 호출 (토큰 삭제 + SharedPreferences 삭제)
  /// 2. State를 초기 상태로 리셋
  /// 3. Mock/Real 모드 모두 지원
  ///
  /// **반환**: 성공 시 true, 실패 시 false
  Future<bool> logout() async {
    try {
      // 1. Repository logout 호출 (토큰 + 로컬 데이터 삭제)
      final authRepository = ref.read(authRepositoryProvider.notifier);
      await authRepository.logout();

      // 2. State 초기화
      state = const LoginState();

      // ✅ 로그아웃 성공!
      return true;
    } catch (e) {
      // 에러 발생 시에도 State는 초기화 (로컬 삭제가 더 중요)
      state = const LoginState();
      return false;
    }
  }
}
