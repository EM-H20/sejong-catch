# 🔐 세종 캐치 인증 API 명세서 (Flutter 연동용)

**작성일**: 2025-01-16 (수정본 v2)
**기반 문서**: INTEGRATION_GUIDE.md
**대상**: Flutter Frontend 개발자

> ✅ **v2 개선사항**: Dio Interceptor 무한 루프 수정, Exception 클래스 추가, Retrofit 헤더 중복 제거

---

## 📋 목차

- [API 엔드포인트 요약](#api-엔드포인트-요약)
- [1. 로그인](#1-로그인)
- [2. Access Token 갱신](#2-access-token-갱신)
- [3. 내 정보 조회](#3-내-정보-조회)
- [4. 로그아웃](#4-로그아웃)
- [에러 응답 표준](#에러-응답-표준)
- [Exception 클래스 정의](#exception-클래스-정의)
- [Flutter DTO 모델 예시](#flutter-dto-모델-예시)
- [Retrofit API 인터페이스](#retrofit-api-인터페이스)
- [Dio Interceptor 가이드 (수정됨)](#dio-interceptor-가이드-수정됨)
- [환경 설정 관리](#환경-설정-관리)

---

## 🎯 API 엔드포인트 요약

| 메서드 | 엔드포인트 | 인증 | 설명 |
|--------|-----------|------|------|
| POST | `/api/auth/login` | ❌ | 세종대 계정으로 로그인 |
| POST | `/api/auth/refresh` | ❌ | Access Token 갱신 |
| GET | `/api/users/me` | ✅ | 내 정보 조회 |
| POST | `/api/auth/logout` | ✅ | 로그아웃 (Refresh Token 무효화) |

**인증 헤더 형식**: `Authorization: Bearer {access_token}`

---

## 1. 로그인

### 📡 API 정보
```
POST /api/auth/login
Content-Type: application/json
```

### 📤 요청 (Request)

#### JSON 스키마
```json
{
  "student_id": "string",    // 필수: 세종대 학번
  "password": "string"       // 필수: 세종대 포털 비밀번호
}
```

#### 예시
```json
{
  "student_id": "20231234",
  "password": "my_sejong_password"
}
```

#### Flutter 요청 DTO
```dart
// lib/features/auth/data/models/request/login_request.dart

class LoginRequest {
  final String studentId;
  final String password;

  const LoginRequest({
    required this.studentId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'password': password,
      };

  @override
  String toString() => 'LoginRequest(studentId: ${studentId.substring(0, 4)}***)';
}
```

### 📥 응답 (Response)

#### ✅ 성공 응답 (201 Created)

**JSON 스키마**
```json
{
  "access_token": "string",       // JWT Access Token (15분 만료)
  "refresh_token": "string",      // JWT Refresh Token (7일 만료)
  "user": {
    "student_id": "string",       // 학번
    "name": "string",             // 이름 (세종대 서버에서 수집)
    "major": "string",            // 전공 (세종대 서버에서 수집)
    "year": number                // 학년 (세종대 서버에서 수집)
  }
}
```

**예시**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "student_id": "20231234",
    "name": "홍길동",
    "major": "컴퓨터공학과",
    "year": 3
  }
}
```

**Flutter 응답 DTO**
```dart
// lib/features/auth/data/models/response/auth_response.dart

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserDto user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user': user.toJson(),
      };
}

// lib/features/auth/data/models/response/user_dto.dart

class UserDto {
  final String studentId;
  final String name;
  final String major;
  final int year;

  const UserDto({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'name': name,
        'major': major,
        'year': year,
      };

  @override
  String toString() => 'UserDto(studentId: $studentId, name: $name, major: $major, year: $year)';
}
```

#### ❌ 에러 응답

| 상태 코드 | 응답 예시 | 설명 |
|----------|----------|------|
| **400** | `{ "error": "학번과 비밀번호를 입력해주세요." }` | 필수 필드 누락 |
| **401** | `{ "error": "인증에 실패했습니다." }` | 학번 또는 비밀번호 불일치 |
| **429** | `{ "error": "너무 많은 인증 시도가 있었습니다. 15분 후 다시 시도해주세요." }` | Rate Limit 초과 (15분 5회) |
| **500** | `{ "error": "서버 오류가 발생했습니다." }` | 서버 내부 오류 |

---

## 2. Access Token 갱신

### 📡 API 정보
```
POST /api/auth/refresh
Content-Type: application/json
```

### 📤 요청 (Request)

#### JSON 스키마
```json
{
  "refresh_token": "string"    // 필수: Refresh Token
}
```

#### 예시
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Flutter 요청 DTO
```dart
// lib/features/auth/data/models/request/refresh_request.dart

class RefreshRequest {
  final String refreshToken;

  const RefreshRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };
}
```

### 📥 응답 (Response)

#### ✅ 성공 응답 (200 OK)

**JSON 스키마**
```json
{
  "access_token": "string"    // 새로운 Access Token (15분 만료)
}
```

**예시**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Flutter 응답 DTO**
```dart
// lib/features/auth/data/models/response/refresh_response.dart

class RefreshResponse {
  final String accessToken;

  const RefreshResponse({
    required this.accessToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['access_token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
      };
}
```

#### ❌ 에러 응답

| 상태 코드 | 응답 예시 | 설명 |
|----------|----------|------|
| **400** | `{ "error": "Refresh token이 필요합니다." }` | refresh_token 필드 누락 |
| **401** | `{ "error": "유효하지 않은 토큰입니다." }` | 잘못된 토큰 또는 서명 불일치 |
| **401** | `{ "error": "만료된 토큰입니다." }` | Refresh Token 만료 (7일 경과) |
| **404** | `{ "error": "사용자를 찾을 수 없습니다." }` | DB에 해당 학번 없음 |

---

## 3. 내 정보 조회

### 📡 API 정보
```
GET /api/users/me
Authorization: Bearer {access_token}
```

### 📤 요청 (Request)

**헤더만 필요** (Body 없음)
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 📥 응답 (Response)

#### ✅ 성공 응답 (200 OK)

**JSON 스키마**
```json
{
  "user": {
    "student_id": "string",        // 학번
    "name": "string",              // 이름
    "major": "string",             // 전공
    "year": number,                // 학년
    "created_at": "string",        // ISO 8601 날짜 (첫 로그인)
    "last_login": "string"         // ISO 8601 날짜 (마지막 로그인)
  }
}
```

**예시**
```json
{
  "user": {
    "student_id": "20231234",
    "name": "홍길동",
    "major": "컴퓨터공학과",
    "year": 3,
    "created_at": "2025-01-15T10:30:00.000Z",
    "last_login": "2025-01-16T14:20:00.000Z"
  }
}
```

**Flutter 응답 DTO**
```dart
// lib/features/auth/data/models/response/user_profile_dto.dart

class UserProfileDto {
  final String studentId;
  final String name;
  final String major;
  final int year;
  final DateTime createdAt;
  final DateTime lastLogin;

  const UserProfileDto({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
    required this.createdAt,
    required this.lastLogin,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
      year: json['year'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: DateTime.parse(json['last_login'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'name': name,
        'major': major,
        'year': year,
        'created_at': createdAt.toIso8601String(),
        'last_login': lastLogin.toIso8601String(),
      };
}
```

#### ❌ 에러 응답

| 상태 코드 | 응답 예시 | 설명 |
|----------|----------|------|
| **401** | `{ "error": "인증이 필요합니다." }` | Authorization 헤더 누락 |
| **401** | `{ "error": "유효하지 않은 토큰입니다." }` | 잘못된 Access Token |
| **404** | `{ "error": "사용자를 찾을 수 없습니다." }` | DB에 해당 학번 없음 |
| **500** | `{ "error": "서버 오류가 발생했습니다." }` | 서버 내부 오류 |

---

## 4. 로그아웃

### 📡 API 정보
```
POST /api/auth/logout
Authorization: Bearer {access_token}
```

### 📤 요청 (Request)

**헤더만 필요** (Body 없음)
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 📥 응답 (Response)

#### ✅ 성공 응답 (200 OK)

**JSON 스키마**
```json
{
  "message": "string"    // 성공 메시지
}
```

**예시**
```json
{
  "message": "로그아웃 되었습니다."
}
```

**Flutter 응답 DTO**
```dart
// lib/features/auth/data/models/response/logout_response.dart

class LogoutResponse {
  final String message;

  const LogoutResponse({
    required this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
```

#### ❌ 에러 응답

| 상태 코드 | 응답 예시 | 설명 |
|----------|----------|------|
| **401** | `{ "error": "인증이 필요합니다." }` | Authorization 헤더 누락 |
| **401** | `{ "error": "유효하지 않은 토큰입니다." }` | 잘못된 Access Token |
| **500** | `{ "error": "서버 오류가 발생했습니다." }` | 서버 내부 오류 |

---

## 🚨 에러 응답 표준

### 공통 에러 DTO

**모든 에러는 동일한 구조를 가집니다.**

```dart
// lib/core/models/error_response.dart

class ErrorResponse {
  final String error;

  const ErrorResponse({
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'error': error,
      };

  @override
  String toString() => 'ErrorResponse(error: $error)';
}
```

---

## 🔥 Exception 클래스 정의

**모든 커스텀 Exception을 정의합니다.**

```dart
// lib/core/exceptions/auth_exceptions.dart

/// 기본 인증 예외
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, {this.statusCode});

  @override
  String toString() => 'AuthException: $message (statusCode: $statusCode)';
}

/// 400 - 입력 검증 실패
class ValidationException extends AuthException {
  ValidationException(String message) : super(message, statusCode: 400);
}

/// 401 - 인증 실패 (일반)
class UnauthorizedException extends AuthException {
  UnauthorizedException(String message) : super(message, statusCode: 401);
}

/// 401 - Refresh Token 만료 (로그아웃 필요)
class SessionExpiredException extends AuthException {
  SessionExpiredException(String message) : super(message, statusCode: 401);
}

/// 404 - 리소스 없음
class NotFoundException extends AuthException {
  NotFoundException(String message) : super(message, statusCode: 404);
}

/// 429 - Rate Limit 초과
class RateLimitException extends AuthException {
  RateLimitException(String message) : super(message, statusCode: 429);
}

/// 500 - 서버 내부 오류
class ServerException extends AuthException {
  ServerException(String message) : super(message, statusCode: 500);
}

/// 네트워크 연결 오류
class NetworkException extends AuthException {
  NetworkException(String message) : super(message);
}

/// 알 수 없는 오류
class UnknownException extends AuthException {
  UnknownException(String message) : super(message);
}
```

### 에러 코드별 처리 가이드

```dart
// Dio Interceptor에서 처리할 에러 매핑

AuthException mapDioErrorToAuthException(DioException error) {
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
```

---

## 🧩 Flutter DTO 모델 예시

### Domain Entity (비즈니스 로직용)

```dart
// lib/features/auth/domain/entities/user.dart

class User {
  final String studentId;
  final String name;
  final String major;
  final int year;

  const User({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
  });

  // DTO → Entity 변환
  factory User.fromDto(UserDto dto) {
    return User(
      studentId: dto.studentId,
      name: dto.name,
      major: dto.major,
      year: dto.year,
    );
  }

  // copyWith (불변 업데이트용)
  User copyWith({
    String? studentId,
    String? name,
    String? major,
    int? year,
  }) {
    return User(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      major: major ?? this.major,
      year: year ?? this.year,
    );
  }

  @override
  String toString() => 'User(studentId: $studentId, name: $name, major: $major, year: $year)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          studentId == other.studentId;

  @override
  int get hashCode => studentId.hashCode;
}
```

---

## 🔌 Retrofit API 인터페이스

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/request/login_request.dart';
import '../models/request/refresh_request.dart';
import '../models/response/auth_response.dart';
import '../models/response/refresh_response.dart';
import '../models/response/user_profile_dto.dart';
import '../models/response/logout_response.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  /// 로그인
  @POST('/api/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  /// Access Token 갱신
  @POST('/api/auth/refresh')
  Future<RefreshResponse> refresh(@Body() RefreshRequest request);

  /// 내 정보 조회
  /// ⚠️ Authorization 헤더는 Interceptor에서 자동 추가됨
  @GET('/api/users/me')
  Future<UserProfileDto> getMyProfile();

  /// 로그아웃
  /// ⚠️ Authorization 헤더는 Interceptor에서 자동 추가됨
  @POST('/api/auth/logout')
  Future<LogoutResponse> logout();
}
```

### 사용 예시

```dart
// Repository에서 사용

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenRepository _tokenRepository; // 토큰 저장소 추상화

  AuthRepositoryImpl(this._remoteDataSource, this._tokenRepository);

  @override
  Future<User> login(String studentId, String password) async {
    try {
      final request = LoginRequest(
        studentId: studentId,
        password: password,
      );

      final response = await _remoteDataSource.login(request);

      // 토큰 저장
      await _tokenRepository.saveAccessToken(response.accessToken);
      await _tokenRepository.saveRefreshToken(response.refreshToken);

      // DTO → Entity 변환
      return User.fromDto(response.user);

    } on DioException catch (e) {
      throw mapDioErrorToAuthException(e);
    }
  }
}
```

---

## 🛡️ Dio Interceptor 가이드 (수정됨)

### ✅ 무한 루프 수정: 별도 Dio 인스턴스 사용

```dart
// lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../repositories/token_repository.dart';
import '../exceptions/auth_exceptions.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final TokenRepository _tokenRepository;
  final String _baseUrl;

  AuthInterceptor(
    this._dio,
    this._tokenRepository,
    this._baseUrl,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 로그인/갱신 요청은 토큰 불필요
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    // Access Token 자동 추가
    final accessToken = await _tokenRepository.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 401 에러 → Access Token 만료
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/refresh')) {
      try {
        // 🔥 핵심: 별도 Dio 인스턴스로 refresh 요청
        final newAccessToken = await _refreshAccessToken();

        if (newAccessToken != null) {
          // 토큰 저장
          await _tokenRepository.saveAccessToken(newAccessToken);

          // 원래 요청 재시도
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (refreshError) {
        // Refresh 실패 → 로그아웃 처리
        await _tokenRepository.clearTokens();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// ✅ 별도 Dio 인스턴스로 토큰 갱신 (무한 루프 방지!)
  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _tokenRepository.getRefreshToken();
    if (refreshToken == null) return null;

    // 🚨 중요: Interceptor가 적용되지 않은 별도 Dio 인스턴스 생성!
    final refreshDio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {'Content-Type': 'application/json'},
    ));

    try {
      final response = await refreshDio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      return response.data['access_token'] as String?;
    } catch (e) {
      // Refresh 실패
      return null;
    }
  }
}
```

### 토큰 저장소 추상화 (테스트 용이성)

```dart
// lib/core/repositories/token_repository.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenRepository {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> clearTokens();
}

// lib/core/repositories/token_repository_impl.dart

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage _storage;

  TokenRepositoryImpl(this._storage);

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
```

### Dio 인스턴스 설정

```dart
// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../repositories/token_repository.dart';
import 'auth_interceptor.dart';

Dio createDio(TokenRepository tokenRepository, String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Auth Interceptor 추가
  dio.interceptors.add(AuthInterceptor(dio, tokenRepository, baseUrl));

  // 디버그 모드에서만 로깅
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (log) => debugPrint(log.toString()),
    ));
  }

  return dio;
}
```

---

## 🌐 환경 설정 관리

### 환경별 baseUrl 관리

```dart
// lib/core/config/env_config.dart

enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  final Environment environment;

  EnvConfig(this.environment);

  String get baseUrl {
    switch (environment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.sejongcatch.com';
      case Environment.production:
        return 'https://api.sejongcatch.com';
    }
  }

  bool get isProduction => environment == Environment.production;
}
```

### 사용 예시

```dart
// lib/main.dart

void main() {
  const environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  final envConfig = EnvConfig(
    environment == 'production'
        ? Environment.production
        : environment == 'staging'
            ? Environment.staging
            : Environment.development,
  );

  final tokenRepository = TokenRepositoryImpl(const FlutterSecureStorage());
  final dio = createDio(tokenRepository, envConfig.baseUrl);

  runApp(MyApp(dio: dio));
}
```

**실행 시 환경 지정**:
```bash
# 개발 환경
flutter run

# 스테이징 환경
flutter run --dart-define=ENV=staging

# 프로덕션 환경
flutter run --dart-define=ENV=production --release
```

---

## 📚 참고 사항

### 토큰 만료 시간
- **Access Token**: 15분 (짧은 만료로 보안 강화)
- **Refresh Token**: 7일 (DB 저장으로 탈취 시 무효화 가능)

### Rate Limiting
- **로그인 엔드포인트**: 15분당 5회 제한
- 초과 시 429 에러 및 15분 대기 필요

### 보안 권장사항
1. **FlutterSecureStorage 사용**: 토큰을 안전하게 저장
2. **HTTPS 통신**: 프로덕션에서 필수
3. **토큰 로깅 금지**: 디버그 로그에 토큰 노출 방지
4. **자동 로그아웃**: Refresh Token 만료 시 즉시 로그인 화면으로 이동
5. **별도 Dio 인스턴스**: Refresh 요청 시 무한 루프 방지

### 에러 처리 우선순위
1. **401 (Unauthorized)**: 자동 refresh 시도 → 실패 시 로그아웃
2. **429 (Rate Limit)**: 사용자에게 대기 안내
3. **500 (Server Error)**: 재시도 또는 나중에 다시 시도 안내
4. **400 (Bad Request)**: 입력 필드 검증 및 사용자 안내

---

## 🎯 주요 개선사항 (v2)

### ✅ 수정된 내용

1. **Dio Interceptor 무한 루프 수정**
   - `_refreshAccessToken()`에서 별도 Dio 인스턴스 사용
   - Interceptor가 적용되지 않은 독립적인 요청

2. **Exception 클래스 완전 정의**
   - `ValidationException`, `SessionExpiredException` 등 모든 예외 추가
   - `mapDioErrorToAuthException()` 유틸리티 함수 제공

3. **Retrofit 헤더 중복 제거**
   - API 인터페이스에서 `@Header('Authorization')` 제거
   - Interceptor에서 자동 추가하도록 통일

4. **토큰 저장소 추상화**
   - `TokenRepository` 인터페이스 분리
   - 테스트 시 Mock 주입 가능

5. **환경 설정 관리**
   - `EnvConfig`로 개발/스테이징/프로덕션 환경 분리
   - baseUrl 하드코딩 제거

---

**🎉 이제 프로덕션 환경에서 안전하게 사용할 수 있는 완벽한 인증 API 명세서입니다!**

**다음 단계**: 피드, 검색, 큐 관리 등 다른 기능의 API 명세도 동일한 패턴으로 작성하세요.
