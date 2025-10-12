/// 🔐 인증 저장소 구현체 (Data Layer)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Repository 구현 예시
/// Domain Repository 인터페이스의 실제 구현
///
/// CLAUDE.md 원칙:
/// ✅ 인터페이스 구현으로 테스트 가능
/// ✅ DTO ↔ Entity 변환 처리
/// ✅ DioException → 커스텀 Exception 변환
/// ✅ 토큰 저장/조회 로직 포함

import 'package:dio/dio.dart';
import '../../../../core/exceptions/auth_exceptions.dart';
import '../../../../core/repositories/token_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/request/login_request.dart';
import '../models/request/refresh_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenRepository _tokenRepository;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._tokenRepository,
  );

  @override
  Future<User> login(String studentId, String password) async {
    try {
      // 1. API 요청
      final request = LoginRequest(
        studentId: studentId,
        password: password,
      );

      final response = await _remoteDataSource.login(request);

      // 2. 토큰 저장 (FlutterSecureStorage)
      await _tokenRepository.saveAccessToken(response.accessToken);
      await _tokenRepository.saveRefreshToken(response.refreshToken);

      // 3. DTO → Entity 변환
      return User.fromDto(response.user);
    } on DioException catch (e) {
      // DioException → AuthException 변환
      throw _mapDioErrorToAuthException(e);
    }
  }

  @override
  Future<bool> refreshAccessToken() async {
    try {
      // 1. Refresh Token 조회
      final refreshToken = await _tokenRepository.getRefreshToken();
      if (refreshToken == null) {
        throw SessionExpiredException('Refresh Token이 없습니다.');
      }

      // 2. API 요청
      final request = RefreshRequest(refreshToken: refreshToken);
      final response = await _remoteDataSource.refresh(request);

      // 3. 새 Access Token 저장
      await _tokenRepository.saveAccessToken(response.accessToken);

      return true;
    } on DioException catch (e) {
      throw _mapDioErrorToAuthException(e);
    }
  }

  @override
  Future<User> getMyProfile() async {
    try {
      // API 요청 (Authorization 헤더는 Interceptor에서 자동 추가)
      final profileDto = await _remoteDataSource.getMyProfile();

      // UserProfileDto → User 변환
      return User(
        id: profileDto.id,
        studentId: profileDto.studentId,
        role: profileDto.role,
        name: profileDto.name,
        major: profileDto.major,
      );
    } on DioException catch (e) {
      throw _mapDioErrorToAuthException(e);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      // 1. 서버에 로그아웃 요청 (Refresh Token 무효화)
      await _remoteDataSource.logout();

      // 2. 로컬 토큰 삭제
      await _tokenRepository.clearTokens();

      return true;
    } on DioException catch (e) {
      // 에러가 발생해도 로컬 토큰은 삭제
      await _tokenRepository.clearTokens();
      throw _mapDioErrorToAuthException(e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    // Access Token 존재 여부로 로그인 상태 확인
    final accessToken = await _tokenRepository.getAccessToken();
    return accessToken != null;
  }

  /// DioException → AuthException 변환
  ///
  /// 참조: AUTH_API_SPEC.md - 에러 코드별 처리 가이드
  AuthException _mapDioErrorToAuthException(DioException error) {
    final statusCode = error.response?.statusCode;
    final errorData = error.response?.data;

    String errorMessage = '알 수 없는 오류가 발생했습니다.';

    if (errorData is Map<String, dynamic> && errorData.containsKey('error')) {
      errorMessage = errorData['error'] as String;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(errorMessage);

      case 401:
        // Refresh Token 만료 여부 확인
        if (error.requestOptions.path.contains('/auth/refresh')) {
          return SessionExpiredException(errorMessage);
        }
        return UnauthorizedException(errorMessage);

      case 404:
        return NotFoundException(errorMessage);

      case 429:
        return RateLimitException(errorMessage);

      case 500:
        return ServerException(errorMessage);

      default:
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return NetworkException('네트워크 연결을 확인해주세요.');
        }
        return UnknownException(errorMessage);
    }
  }
}
