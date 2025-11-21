import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/onboarding_service.dart';
import '../datasources/auth_api.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

part 'auth_repository.g.dart';

/// AuthApi Provider
@riverpod
AuthApi authApi(AuthApiRef ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
}

/// 인증 Repository
@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  void build() {}

  /// 로그인
  ///
  /// 🔧 **개발/프로덕션 자동 전환**
  /// - Mock 모드: `flutter run --dart-define=USE_MOCK_AUTH=true`
  /// - Real 모드: `flutter run` (기본값)
  Future<LoginResponse> login(String studentId, String password) async {
    // 환경 변수로 Mock/Real 자동 전환
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

    if (useMock) {
      return _mockLogin(studentId, password);
    } else {
      return _realLogin(studentId, password);
    }
  }

  /// Mock 로그인 (개발 전용) - 백엔드 응답 구조와 일치!
  Future<LoginResponse> _mockLogin(String studentId, String password) async {
    // 학번 1234 / 비밀번호 1234만 허용
    if (studentId == '1234' && password == '1234') {
      // 네트워크 지연 시뮬레이션 (1초)
      await Future.delayed(const Duration(seconds: 1));

      return LoginResponse(
        accessToken: 'mock_access_token_abc123xyz',
        refreshToken: 'mock_refresh_token_def456uvw',
        user: UserDto(
          id: 'mock_user_001',
          email: '1234@sejong.local',
          role: 'student',
          name: '홍길동',
          major: '컴퓨터공학과',
          year: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    // 잘못된 학번/비밀번호
    await Future.delayed(const Duration(milliseconds: 500));
    throw Exception('Mock 모드: 학번 1234 / 비밀번호 1234만 사용 가능합니다');
  }

  /// 실제 API 로그인 (프로덕션)
  Future<LoginResponse> _realLogin(String studentId, String password) async {
    final api = ref.read(authApiProvider);
    final request = LoginRequest(studentId: studentId, password: password);
    return await api.login(request);
  }

  /// 토큰 갱신
  Future<String> refreshToken(String refreshToken) async {
    final api = ref.read(authApiProvider);
    final response = await api.refresh({'refresh_token': refreshToken});
    return response.data['access_token'] as String;
  }

  /// 로그아웃
  ///
  /// **동작**:
  /// 1. 토큰 삭제 (FlutterSecureStorage)
  /// 2. SharedPreferences 모든 데이터 삭제 (온보딩 상태 포함)
  /// 3. API 로그아웃 호출 (선택적, Mock 모드에서는 스킵)
  ///
  /// **Mock/Real 모드 모두 지원**
  Future<void> logout() async {
    // 1. 토큰 삭제
    final tokenStorage = ref.read(tokenStorageServiceProvider.notifier);
    await tokenStorage.clearTokens();

    // 2. SharedPreferences 전체 삭제 (온보딩 상태 초기화)
    final onboardingService = ref.read(onboardingServiceProvider);
    await onboardingService.clearAllLocalData();

    // 3. API 로그아웃 호출 (Real 모드일 때만)
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);
    if (!useMock) {
      try {
        final api = ref.read(authApiProvider);
        await api.logout();
      } catch (e) {
        // API 로그아웃 실패해도 로컬 데이터는 이미 삭제됨
      }
    }
  }

  /// 내 정보 조회
  Future<Map<String, dynamic>> getMe() async {
    final api = ref.read(authApiProvider);
    final response = await api.getMe();
    return response.data as Map<String, dynamic>;
  }
}
