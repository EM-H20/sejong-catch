import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_provider.dart';
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
  Future<LoginResponse> login(String studentId, String password) async {
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
  Future<void> logout() async {
    final api = ref.read(authApiProvider);
    await api.logout();
  }

  /// 내 정보 조회
  Future<Map<String, dynamic>> getMe() async {
    final api = ref.read(authApiProvider);
    final response = await api.getMe();
    return response.data as Map<String, dynamic>;
  }
}
