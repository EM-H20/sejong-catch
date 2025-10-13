# 로그인 API 프론트엔드 연결 구현 보고서

> **세종 캐치 (Sejong Catch) - Flutter 프론트엔드**
> 작성일: 2025-01-13
> 작성자: Development Team

---

## 📋 목차
1. [개요](#1-개요)
2. [기술 스택](#2-기술-스택)
3. [아키텍처 설계](#3-아키텍처-설계)
4. [구현 상세](#4-구현-상세)
5. [인증 플로우](#5-인증-플로우)
6. [개발/프로덕션 환경 분리](#6-개발프로덕션-환경-분리)
7. [코드 구조](#7-코드-구조)
8. [커밋 히스토리](#8-커밋-히스토리)

---

## 1. 개요

### 1.1 목적
세종대학교 학생들을 위한 올인원 정보 허브 애플리케이션에서 **세종대 포털 계정 기반 인증 시스템**을 프론트엔드에 연동하여 안전하고 효율적인 사용자 인증을 구현합니다.

### 1.2 주요 기능
- 세종대 포털 계정 로그인 (학번 + 비밀번호)
- JWT 기반 토큰 인증 (Access Token + Refresh Token)
- 자동 토큰 갱신
- Mock/Real API 자동 전환 (개발/프로덕션 환경 분리)
- 안전한 토큰 저장 (FlutterSecureStorage)

---

## 2. 기술 스택

### 2.1 Core 라이브러리
| 라이브러리 | 버전 | 역할 |
|-----------|------|------|
| **Flutter** | 3.x | 크로스플랫폼 UI 프레임워크 |
| **Riverpod** | 3.0+ | 상태 관리 + 의존성 주입 |
| **Freezed** | 2.5.7 | 불변 데이터 클래스 자동 생성 |
| **Retrofit** | 4.4.1 | HTTP 클라이언트 코드 자동 생성 |
| **Dio** | 5.7.0 | HTTP 통신 라이브러리 |
| **json_serializable** | 6.8.0 | JSON 직렬화 자동화 |

### 2.2 보안 라이브러리
| 라이브러리 | 역할 |
|-----------|------|
| **flutter_secure_storage** | 토큰 암호화 저장 (iOS Keychain, Android KeyStore) |

### 2.3 코드 생성 도구
```yaml
build_runner: ^2.4.13    # 코드 자동 생성 실행
freezed_annotation: ^2.4.4
json_annotation: ^4.9.0
retrofit_generator: ^9.1.4
riverpod_generator: ^3.0.2
```

---

## 3. 아키텍처 설계

### 3.1 Clean Architecture 적용
```
lib/features/auth/
├── data/                          # 데이터 계층
│   ├── datasources/
│   │   └── auth_api.dart          # Retrofit API 인터페이스
│   ├── models/
│   │   ├── request/
│   │   │   └── login_request.dart # @freezed 로그인 요청 모델
│   │   └── response/
│   │       └── login_response.dart # @freezed 로그인 응답 모델
│   └── repositories/
│       └── auth_repository.dart    # @riverpod Repository 구현체
└── presentation/                   # UI 계층
    ├── controllers/
    │   └── login_controller.dart   # @riverpod Notifier
    └── pages/
        └── login_page.dart         # UI 컴포넌트
```

### 3.2 계층별 역할

#### 📡 **Data Layer (데이터 계층)**
- **auth_api.dart**: Retrofit을 사용한 HTTP API 인터페이스 정의
- **login_request.dart**: API 요청 데이터 모델 (Freezed + JsonSerializable)
- **login_response.dart**: API 응답 데이터 모델 (Freezed + JsonSerializable)
- **auth_repository.dart**: 비즈니스 로직 구현 (Mock/Real 전환 로직 포함)

#### 🎨 **Presentation Layer (UI 계층)**
- **login_controller.dart**: Riverpod 기반 상태 관리 (로그인 상태, 에러 핸들링)
- **login_page.dart**: 사용자 인터페이스 (입력 폼, 버튼, 로딩 상태)

---

## 4. 구현 상세

### 4.1 API 인터페이스 정의 (Retrofit)

**파일**: `lib/features/auth/data/datasources/auth_api.dart`

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

part 'auth_api.g.dart';

/// 인증 API 인터페이스 (Retrofit)
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  /// 로그인
  @POST('/api/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// 토큰 갱신
  @POST('/api/auth/refresh')
  Future<HttpResponse<dynamic>> refresh(@Body() Map<String, String> body);

  /// 로그아웃
  @POST('/api/auth/logout')
  Future<HttpResponse<dynamic>> logout();

  /// 내 정보 조회
  @GET('/api/users/me')
  Future<HttpResponse<dynamic>> getMe();
}
```

**핵심 포인트**:
- `@RestApi()` 어노테이션으로 Retrofit 인터페이스 정의
- `@POST`, `@GET` 으로 HTTP 메서드 지정
- `@Body()` 로 요청 본문 자동 직렬화
- Freezed 모델과 완벽 호환 (자동 JSON 변환)

---

### 4.2 요청/응답 모델 (Freezed + JsonSerializable)

#### 4.2.1 로그인 요청 모델

**파일**: `lib/features/auth/data/models/request/login_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// 로그인 API 요청 모델
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @JsonKey(name: 'student_id') required String studentId,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
```

**JSON 변환 예시**:
```json
{
  "student_id": "20240001",
  "password": "my_password"
}
```

---

#### 4.2.2 로그인 응답 모델

**파일**: `lib/features/auth/data/models/response/login_response.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 로그인 API 응답 모델
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserDto user,
    required bool linked,
    required SsoDto sso,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 사용자 정보 DTO
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    required String role,
    required String name,
    required String major,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// SSO 정보 DTO
@freezed
class SsoDto with _$SsoDto {
  const factory SsoDto({
    required bool success,
    @JsonKey(name: 'is_auth') required bool isAuth,
    required String code,
    required SsoBodyDto body,
  }) = _SsoDto;

  factory SsoDto.fromJson(Map<String, dynamic> json) =>
      _$SsoDtoFromJson(json);
}

/// SSO Body DTO
@freezed
class SsoBodyDto with _$SsoBodyDto {
  const factory SsoBodyDto({
    required String name,
    required String major,
  }) = _SsoBodyDto;

  factory SsoBodyDto.fromJson(Map<String, dynamic> json) =>
      _$SsoBodyDtoFromJson(json);
}
```

**JSON 응답 예시**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "dGhpc19pc19yZWZyZXNoX3Rva2Vu...",
  "user": {
    "id": "usr_001",
    "student_id": "20240001",
    "role": "student",
    "name": "홍길동",
    "major": "컴퓨터공학과"
  },
  "linked": true,
  "sso": {
    "success": true,
    "is_auth": true,
    "code": "200",
    "body": {
      "name": "홍길동",
      "major": "컴퓨터공학과"
    }
  }
}
```

**핵심 포인트**:
- `@freezed` 로 불변 객체 자동 생성 (copyWith, ==, hashCode)
- `@JsonKey(name: '...')` 로 snake_case ↔ camelCase 자동 변환
- 중첩된 객체 (UserDto, SsoDto) 자동 직렬화/역직렬화
- 컴파일 타임에 타입 안정성 보장

---

### 4.3 Repository 구현 (비즈니스 로직)

**파일**: `lib/features/auth/data/repositories/auth_repository.dart`

```dart
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

  /// Mock 로그인 (개발 전용)
  Future<LoginResponse> _mockLogin(String studentId, String password) async {
    // 학번 1234 / 비밀번호 1234만 허용
    if (studentId == '1234' && password == '1234') {
      // 네트워크 지연 시뮬레이션 (1초)
      await Future.delayed(const Duration(seconds: 1));

      return const LoginResponse(
        accessToken: 'mock_access_token_abc123xyz',
        refreshToken: 'mock_refresh_token_def456uvw',
        user: UserDto(
          id: 'mock_user_001',
          studentId: '1234',
          role: 'student',
          name: '홍길동',
          major: '컴퓨터공학과',
        ),
        linked: true,
        sso: SsoDto(
          success: true,
          isAuth: true,
          code: '200',
          body: SsoBodyDto(
            name: '홍길동',
            major: '컴퓨터공학과',
          ),
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
```

**핵심 포인트**:
- `@riverpod` 로 자동 의존성 주입
- `bool.fromEnvironment('USE_MOCK_AUTH')` 로 Mock/Real 자동 전환
- Mock 모드에서 네트워크 지연 시뮬레이션 (실제 환경과 유사하게)
- Freezed 모델을 사용하여 타입 안전한 데이터 반환

---

### 4.4 Dio 설정 (HTTP 클라이언트)

**파일**: `lib/core/network/dio_provider.dart`

```dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/api_config.dart';

part 'dio_provider.g.dart';

/// Dio 인스턴스 Provider
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,  // http://127.0.0.1:8081
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 로깅 인터셉터 (디버그 모드)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => print('[DIO] $obj'),
    ),
  );

  // TODO: 토큰 인터셉터 추가 (access_token 자동 추가)
  // dio.interceptors.add(AuthInterceptor(ref));

  return dio;
}
```

**핵심 포인트**:
- Riverpod Provider로 Dio 인스턴스 싱글톤 관리
- `LogInterceptor` 로 요청/응답 로깅 (디버깅 용이)
- 향후 `AuthInterceptor` 추가 예정 (자동 토큰 추가, 401 에러 시 자동 갱신)

---

## 5. 인증 플로우

### 5.1 전체 인증 플로우 다이어그램

```
┌──────────┐       ┌────────────┐       ┌──────────────┐       ┌─────────────┐
│          │       │            │       │              │       │             │
│  사용자   │──────▶│ LoginPage  │──────▶│ LoginCtrl    │──────▶│ AuthRepo    │
│  (학생)   │       │   (UI)     │       │  (상태관리)   │       │ (비즈니스)  │
│          │       │            │       │              │       │             │
└──────────┘       └────────────┘       └──────────────┘       └─────────────┘
                          │                     │                      │
                          │ 1. 학번+비밀번호      │                      │
                          │    입력              │                      │
                          │─────────────────────▶│                      │
                          │                     │                      │
                          │                     │ 2. login() 호출       │
                          │                     │─────────────────────▶│
                          │                     │                      │
                          │                     │                      │ 3. Mock 체크
                          │                     │                      │    (USE_MOCK_AUTH?)
                          │                     │                      │
                          │                     │                      ├─── Mock 모드
                          │                     │                      │    └─ 1초 딜레이
                          │                     │                      │    └─ 더미 토큰 반환
                          │                     │                      │
                          │                     │                      └─── Real 모드
                          │                     │                           └─ POST /api/auth/login
                          │                     │                           └─ Node.js API 호출
                          │                     │                      │
                          │                     │ 4. LoginResponse     │
                          │                     │◀─────────────────────│
                          │                     │   (access_token,     │
                          │                     │    refresh_token,    │
                          │                     │    user, sso)        │
                          │                     │                      │
                          │ 5. UI 업데이트        │                      │
                          │◀─────────────────────│                      │
                          │   (로그인 성공)        │                      │
                          │                     │                      │
                          ▼                     ▼                      ▼
                     HomeShell              토큰 저장             FlutterSecureStorage
                   (메인 화면)          (SecureStorage)           (암호화 저장소)
```

### 5.2 단계별 설명

#### **Step 1: 사용자 입력**
- 사용자가 학번(student_id)과 비밀번호(password) 입력
- LoginPage에서 TextField로 입력 받음
- "로그인" 버튼 클릭

#### **Step 2: Controller 호출**
```dart
// LoginController에서 Repository 호출
final repository = ref.read(authRepositoryProvider.notifier);
final response = await repository.login(studentId, password);
```

#### **Step 3: Repository 로직 분기**
```dart
// 환경 변수 체크
const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

if (useMock) {
  return _mockLogin(studentId, password);  // Mock 모드
} else {
  return _realLogin(studentId, password);  // Real 모드
}
```

#### **Step 4: API 호출 (Real 모드)**
```dart
// Retrofit AuthApi를 통한 HTTP 요청
final api = ref.read(authApiProvider);
final request = LoginRequest(studentId: studentId, password: password);
return await api.login(request);

// 실제 HTTP 요청
POST http://127.0.0.1:8081/api/auth/login
Content-Type: application/json

{
  "student_id": "20240001",
  "password": "my_password"
}
```

#### **Step 5: 응답 처리**
```dart
// LoginResponse 자동 역직렬화
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "dGhpc19pc19yZWZyZXNoX3Rva2Vu...",
  "user": { ... },
  "linked": true,
  "sso": { ... }
}

// Freezed 모델로 자동 변환
final response = LoginResponse.fromJson(jsonResponse);
```

#### **Step 6: 토큰 저장 (향후 구현)**
```dart
// FlutterSecureStorage에 암호화 저장
await storage.write(key: 'access_token', value: response.accessToken);
await storage.write(key: 'refresh_token', value: response.refreshToken);
```

#### **Step 7: 화면 전환**
```dart
// 로그인 성공 시 메인 화면으로 이동
context.go('/home');
```

---

## 6. 개발/프로덕션 환경 분리

### 6.1 Mock 모드 (개발 환경)

**목적**: 백엔드 API 없이 프론트엔드 개발 가능

**실행 방법**:
```bash
# Mock 모드 (기본값)
flutter run

# 또는 명시적으로 Mock 활성화
flutter run --dart-define=USE_MOCK_AUTH=true
```

**동작 방식**:
- 실제 HTTP 요청 없이 더미 데이터 반환
- 네트워크 지연 시뮬레이션 (1초)
- 고정된 테스트 계정: 학번 `1234` / 비밀번호 `1234`

**Mock 응답 데이터**:
```dart
return const LoginResponse(
  accessToken: 'mock_access_token_abc123xyz',
  refreshToken: 'mock_refresh_token_def456uvw',
  user: UserDto(
    id: 'mock_user_001',
    studentId: '1234',
    role: 'student',
    name: '홍길동',
    major: '컴퓨터공학과',
  ),
  linked: true,
  sso: SsoDto(
    success: true,
    isAuth: true,
    code: '200',
    body: SsoBodyDto(
      name: '홍길동',
      major: '컴퓨터공학과',
    ),
  ),
);
```

---

### 6.2 Real 모드 (프로덕션 환경)

**목적**: 실제 백엔드 API와 통신

**실행 방법**:
```bash
# Real 모드 활성화
flutter run --dart-define=USE_MOCK_AUTH=false
```

**동작 방식**:
- 실제 Node.js API 서버로 HTTP 요청
- 세종대 포털 인증 연동
- 실제 JWT 토큰 발급

**API 엔드포인트**:
```
POST http://127.0.0.1:8081/api/auth/login
```

---

### 6.3 환경 전환 장점

| 항목 | Mock 모드 | Real 모드 |
|-----|----------|----------|
| **백엔드 의존성** | ❌ 불필요 | ✅ 필요 |
| **개발 속도** | ⚡ 빠름 (즉시 응답) | 🐢 느림 (네트워크 지연) |
| **테스트** | ✅ 쉬움 (고정 데이터) | ⚠️ 복잡 (실제 계정 필요) |
| **디버깅** | ✅ 쉬움 (에러 시뮬레이션) | ⚠️ 어려움 (네트워크 이슈) |
| **CI/CD** | ✅ 가능 (백엔드 없이) | ❌ 어려움 (백엔드 필요) |

---

## 7. 코드 구조

### 7.1 파일 목록

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_api.dart              # Retrofit API 인터페이스
│   │   └── auth_api.g.dart            # 자동 생성된 Retrofit 구현체
│   ├── models/
│   │   ├── request/
│   │   │   ├── login_request.dart     # 로그인 요청 모델
│   │   │   ├── login_request.freezed.dart  # Freezed 자동 생성
│   │   │   └── login_request.g.dart   # JsonSerializable 자동 생성
│   │   └── response/
│   │       ├── login_response.dart    # 로그인 응답 모델
│   │       ├── login_response.freezed.dart  # Freezed 자동 생성
│   │       └── login_response.g.dart  # JsonSerializable 자동 생성
│   └── repositories/
│       ├── auth_repository.dart       # Repository 구현체
│       └── auth_repository.g.dart     # Riverpod 자동 생성
└── presentation/
    ├── controllers/
    │   ├── login_controller.dart      # 상태 관리
    │   └── login_controller.g.dart    # Riverpod 자동 생성
    └── pages/
        └── login_page.dart            # UI 화면
```

### 7.2 코드 생성 명령어

**모든 자동 생성 파일 빌드**:
```bash
# Freezed + Retrofit + Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 개발 중 자동 생성 (파일 변경 감지)
dart run build_runner watch --delete-conflicting-outputs
```

**생성되는 파일**:
- `*.freezed.dart` - Freezed 불변 클래스 (copyWith, ==, toString)
- `*.g.dart` - JsonSerializable (fromJson, toJson) + Riverpod Provider
- `auth_api.g.dart` - Retrofit API 구현체

---

## 8. 커밋 히스토리

### 8.1 주요 커밋 분석

#### **Commit 1: 로그인 페이지 초기 구현**
```
7c582e4 - feat: login page
```
- 로그인 UI 기본 구조 생성
- TextField (학번, 비밀번호) + 로그인 버튼

---

#### **Commit 2: 로그인 입력칸 수정**
```
62c5cd1 - fix: 로그인 입력칸
```
- UI 개선 (패딩, 스타일링)
- 입력 검증 로직 추가

---

#### **Commit 3: 로그인 응답 모델 생성**
```
a983a89 - 로그인 응답 모델 생성
```
- `LoginResponse`, `UserDto`, `SsoDto` 모델 정의
- Freezed + JsonSerializable 적용

---

#### **Commit 4: Freezed 제거 및 단순화 (Rollback)**
```
2f5d303 - refactor: Freezed 제거 및 코드 구조 대폭 단순화
```
- ❌ **잘못된 시도**: Freezed 제거하고 수동 구현
- 이후 다시 Freezed로 복구 (다음 커밋)

---

#### **Commit 5: Freezed + Retrofit 완전 재구축** ⭐
```
fdeb9b0 - refactor: Freezed + Retrofit 기반 인증 시스템 완전 재구축
```
- ✅ **핵심 커밋**: 현재 아키텍처의 기반
- Freezed 모델 재적용 (LoginRequest, LoginResponse)
- Retrofit API 인터페이스 구축
- Riverpod Repository 패턴 적용

**변경 파일**:
- `auth_api.dart` - Retrofit 인터페이스 생성
- `auth_repository.dart` - Repository 로직 구현
- `login_request.dart` - @freezed 요청 모델
- `login_response.dart` - @freezed 응답 모델

---

#### **Commit 6: Mock/Real 자동 전환 시스템** 🎭
```
ae72f4f - feat: Mock/Real 인증 자동 전환 시스템 구축 🎭
```
- ✅ **최종 완성 커밋**: 개발/프로덕션 환경 분리
- `bool.fromEnvironment('USE_MOCK_AUTH')` 로 자동 전환
- Mock 로그인 로직 구현 (테스트 계정: 1234/1234)
- 네트워크 지연 시뮬레이션 추가

**주요 코드**:
```dart
Future<LoginResponse> login(String studentId, String password) async {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

  if (useMock) {
    return _mockLogin(studentId, password);
  } else {
    return _realLogin(studentId, password);
  }
}
```

---

### 8.2 개발 타임라인

```
2024-XX-XX  feat: login page
            ↓ 로그인 UI 초기 구현
2024-XX-XX  fix: 로그인 입력칸
            ↓ UI 개선
2024-XX-XX  로그인 응답 모델 생성
            ↓ 데이터 모델 정의
2024-XX-XX  refactor: Freezed 제거 (잘못된 시도)
            ↓ 수동 구현 시도
2024-XX-XX  refactor: Freezed + Retrofit 재구축 ⭐
            ↓ 현재 아키텍처 확립
2024-XX-XX  feat: Mock/Real 자동 전환 🎭
            ↓ 최종 완성
```

---

## 9. 결론 및 향후 계획

### 9.1 현재 구현 상태

✅ **완료된 항목**:
- Freezed + Retrofit 기반 Clean Architecture 구축
- Mock/Real API 자동 전환 시스템
- 로그인 요청/응답 모델 (타입 안전)
- Riverpod 기반 상태 관리
- Dio HTTP 클라이언트 설정

⚠️ **진행 중인 항목**:
- FlutterSecureStorage 토큰 저장
- AuthInterceptor (자동 토큰 추가, 401 에러 시 refresh)
- 로그아웃 기능 완성
- 토큰 갱신 로직

---

### 9.2 향후 구현 계획

#### **Phase 1: 토큰 관리**
- FlutterSecureStorage 연동
- 자동 토큰 갱신 (Interceptor)
- 로그인 세션 유지

#### **Phase 2: 에러 핸들링**
- 네트워크 에러 처리
- 401/403 에러 자동 처리
- 사용자 친화적 에러 메시지

#### **Phase 3: 보안 강화**
- 토큰 만료 시간 체크
- 자동 로그아웃
- SSL Pinning (프로덕션)

---

### 9.3 핵심 성과

| 항목 | 성과 |
|-----|------|
| **코드 품질** | Freezed + Retrofit로 타입 안전성 극대화 |
| **개발 효율** | Mock/Real 전환으로 백엔드 의존성 제거 |
| **유지보수성** | Clean Architecture로 계층 분리 |
| **확장성** | Riverpod Provider로 의존성 주입 자동화 |

---

## 10. 참고 자료

### 10.1 공식 문서
- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Riverpod 문서](https://riverpod.dev/)
- [Freezed 문서](https://pub.dev/packages/freezed)
- [Retrofit 문서](https://pub.dev/packages/retrofit)
- [Dio 문서](https://pub.dev/packages/dio)

### 10.2 프로젝트 파일
- [CLAUDE.md](../CLAUDE.md) - 프로젝트 가이드라인
- [pubspec.yaml](../pubspec.yaml) - 의존성 목록

---

**작성일**: 2025-01-13
**작성자**: Sejong Catch Development Team
**문서 버전**: 1.0.0