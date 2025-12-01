import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/onboarding_service.dart';
import '../datasources/auth_api.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

part 'auth_repository.g.dart';

/// AuthApi Provider
@riverpod
AuthApi authApi(Ref ref) {
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
  /// - Mock 모드: --dart-define=USE_MOCK_AUTH=true
  /// - Real 모드: --dart-define=USE_MOCK_AUTH=false
  Future<LoginResponse> login(String studentId, String password) async {
    // 🔥 컴파일 타임 상수로 분기 (launch.json 설정 반영!)
    if (EnvConfig.useMockAuth) {
      return _mockLogin(studentId, password);
    } else {
      return _realLogin(studentId, password);
    }
  }

  /// Mock 로그인 (개발 전용) - 백엔드 응답 구조와 일치!
  ///
  /// **🎭 테스트 계정**:
  /// | 학번 | 비밀번호 | 역할 | 설명 |
  /// |------|---------|------|------|
  /// | 1234 | 1234 | student | 일반 학생 (기본) |
  /// | 9999 | 9999 | operator | 큐 운영자 (큐 생성 가능) |
  /// | 0000 | 0000 | admin | 관리자 (모든 권한) |
  Future<LoginResponse> _mockLogin(String studentId, String password) async {
    // 🎭 역할별 테스트 계정 (학번 = 비밀번호)
    final mockAccounts = <String, ({String role, String name, String major})>{
      '1234': (role: 'student', name: '홍길동', major: '컴퓨터공학과'),
      '9999': (role: 'operator', name: '김운영', major: '축제준비위원회'),
      '0000': (role: 'admin', name: '박관리', major: '학생처'),
    };

    // 학번 = 비밀번호 && 계정 존재 시 로그인 성공
    if (studentId == password && mockAccounts.containsKey(studentId)) {
      // 네트워크 지연 시뮬레이션 (1초)
      await Future.delayed(const Duration(seconds: 1));

      final account = mockAccounts[studentId]!;

      return LoginResponse(
        accessToken: 'mock_access_token_$studentId',
        refreshToken: 'mock_refresh_token_$studentId',
        user: UserDto(
          id: 'mock_user_$studentId',
          email: '$studentId@sejong.local',
          role: account.role,
          name: account.name,
          major: account.major,
          year: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    // 잘못된 학번/비밀번호
    await Future.delayed(const Duration(milliseconds: 500));
    throw Exception(
      'Mock 모드: 학번=비밀번호로 입력하세요\n'
      '• 1234 → 학생\n'
      '• 9999 → 운영자 (큐 생성 가능)\n'
      '• 0000 → 관리자',
    );
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
    if (!EnvConfig.useMockAuth) {
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
