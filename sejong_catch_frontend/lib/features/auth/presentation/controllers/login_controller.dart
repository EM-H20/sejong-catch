import 'package:riverpod_annotation/riverpod_annotation.dart';
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

  /// 로그인 실행
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
    state = state.startLoading();

    try {
      // TODO: 실제 API 연동
      // 1. Python Auth API → sejong_token 발급
      // 2. Node.js /auth/exchange → access_token, refresh_token

      // 임시 딜레이 (API 호출 시뮬레이션)
      await Future.delayed(const Duration(seconds: 2));

      // 성공 시뮬레이션
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        error: null,
      );

      // TODO: 토큰 저장 (FlutterSecureStorage)
      // TODO: 홈 화면으로 네비게이션 (context.go('/feed'))
    } catch (e) {
      // 에러 처리
      state = state.copyWith(
        isLoading: false,
        error: '로그인에 실패했어요. 학번과 비밀번호를 확인해주세요.',
      );
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.clearError();
  }
}
