# 🔗 백엔드 연동 가이드

**최종 업데이트**: 2025-11-21
**백엔드 서버**: http://152.67.219.91:8888
**상태**: ✅ 인증 API 연동 완료

---

## 📋 목차

- [연동 완료 현황](#연동-완료-현황)
- [백엔드 API 응답 구조](#백엔드-api-응답-구조)
- [JSON 필드명 규칙](#json-필드명-규칙)
- [Freezed 모델 작성법](#freezed-모델-작성법)
- [Mock/Real 모드 전환](#mockreal-모드-전환)
- [에러 처리 패턴](#에러-처리-패턴)
- [트러블슈팅](#트러블슈팅)

---

## ✅ 연동 완료 현황

### 인증 (Auth)
```yaml
엔드포인트: POST /auth/login
상태: ✅ 완료
모델: LoginRequest, LoginResponse, UserDto
마지막 수정: 2025-11-21 (commit 4c09892)
```

**완료 내역**:
- ✅ 백엔드 camelCase JSON 응답 대응
- ✅ LoginRequest/LoginResponse Freezed 모델 수정
- ✅ Mock 데이터 백엔드 구조 동기화
- ✅ 실제 로그인 테스트 성공

### 피드 (Feed)
```yaml
엔드포인트: GET /feed
상태: ⏳ Mock 구현 완료, Real 연동 대기
모델: FeedItem, FeedCategory
참고: Mock 모드로 UI 개발 가능
```

---

## 🔥 백엔드 API 응답 구조

### 중요! Node.js 백엔드는 **camelCase** 사용

```json
{
  "user": {
    "id": "u_20011650",
    "email": "20011650@sejong.local",
    "name": "홍의민",
    "role": "student",
    "major": "컴퓨터공학과",
    "year": null,
    "createdAt": "2025-11-21T07:36:28.686Z",
    "updatedAt": "2025-11-21T07:36:28.686Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**핵심 포인트**:
- ❌ `access_token` (snake_case) → ✅ `accessToken` (camelCase)
- ❌ `student_id` (snake_case) → ✅ `id` (camelCase)
- ❌ `created_at` (snake_case) → ✅ `createdAt` (camelCase)

---

## 📝 JSON 필드명 규칙

### ⚠️ @JsonKey 사용하지 말 것!

Freezed + json_serializable은 **기본적으로 Dart 필드명을 그대로 JSON 키로 사용**합니다.

```dart
// ❌ 잘못된 방법 (백엔드가 snake_case 쓸 때만 필요)
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @JsonKey(name: 'student_id') required String studentId,  // ❌ 불필요!
    required String password,
  }) = _LoginRequest;
}

// ✅ 올바른 방법 (백엔드가 camelCase 쓰면 @JsonKey 제거)
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String studentId,  // → JSON: "studentId"
    required String password,   // → JSON: "password"
  }) = _LoginRequest;
}
```

**생성된 JSON**:
```json
{
  "studentId": "20011650",
  "password": "my_password"
}
```

### 백엔드가 snake_case를 쓴다면?

Python 백엔드(FastAPI 등)는 snake_case를 사용하므로 **@JsonKey 필요**:

```dart
@freezed
class PythonApiRequest with _$PythonApiRequest {
  const factory PythonApiRequest({
    @JsonKey(name: 'student_id') required String studentId,  // ✅ 필요함
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PythonApiRequest;
}
```

---

## 🧩 Freezed 모델 작성법

### 기본 패턴

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 로그인 API 응답 모델 (백엔드 스펙 일치!)
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,   // camelCase
    required String refreshToken,  // camelCase
    required UserDto user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 사용자 정보 DTO (백엔드 스펙 일치!)
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String role,
    required String name,
    required String major,
    int? year,              // nullable
    DateTime? createdAt,    // nullable + 자동 DateTime 변환
    DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
```

### 코드 생성 명령어

```bash
# 한 번만 생성
dart run build_runner build --delete-conflicting-outputs

# 파일 변경 감지 (개발 중 추천!)
dart run build_runner watch --delete-conflicting-outputs
```

---

## 🔄 Mock/Real 모드 전환

### 환경 변수 설정

```bash
# .env 파일
NODE_BACKEND_URL=http://152.67.219.91:8888
USE_MOCK_AUTH=false  # false = Real 모드, true = Mock 모드
```

### Repository 구현 패턴

```dart
// lib/features/auth/data/repositories/auth_repository.dart

@riverpod
class AuthRepository extends _$AuthRepository {
  @override
  FutureOr<void> build() {}

  /// 로그인 (Mock/Real 자동 분기)
  Future<LoginResponse> login(String studentId, String password) async {
    const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: false);

    if (useMock) {
      return _mockLogin(studentId, password);
    } else {
      return _realLogin(studentId, password);
    }
  }

  /// Real 로그인 (실제 API 호출)
  Future<LoginResponse> _realLogin(String studentId, String password) async {
    final api = ref.read(authApiProvider);
    final request = LoginRequest(
      studentId: studentId,
      password: password,
    );

    return await api.login(request);
  }

  /// Mock 로그인 (개발 전용) - 백엔드 응답 구조와 일치!
  Future<LoginResponse> _mockLogin(String studentId, String password) async {
    // 학번 1234 / 비밀번호 1234만 허용
    if (studentId == '1234' && password == '1234') {
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

    await Future.delayed(const Duration(milliseconds: 500));
    throw Exception('Mock 모드: 학번 1234 / 비밀번호 1234만 사용 가능합니다');
  }
}
```

---

## ⚠️ 에러 처리 패턴

### DioException 처리

```dart
try {
  final response = await api.login(request);
  // 성공
} on DioException catch (e) {
  final statusCode = e.response?.statusCode;
  final errorData = e.response?.data;

  if (errorData is Map<String, dynamic>) {
    final message = errorData['message'] ?? '알 수 없는 오류';

    switch (statusCode) {
      case 400:
        throw Exception('입력 오류: $message');
      case 401:
        throw Exception('인증 실패: $message');
      case 500:
        throw Exception('서버 오류: $message');
      default:
        throw Exception('오류 발생: $message');
    }
  }

  throw Exception('네트워크 오류가 발생했습니다');
} catch (e) {
  throw Exception('알 수 없는 오류: $e');
}
```

---

## 🐛 트러블슈팅

### 1. JSON 파싱 실패: "type 'Null' is not a subtype of type 'String'"

**원인**: 백엔드 응답에 없는 필드를 `required`로 선언함

```dart
// ❌ 잘못된 코드
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String studentId,  // 백엔드에 이 필드 없음!
  }) = _UserDto;
}

// ✅ 해결 방법 1: 필드 삭제
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,  // 백엔드 실제 필드명
  }) = _UserDto;
}

// ✅ 해결 방법 2: nullable로 변경
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    String? studentId,  // nullable
  }) = _UserDto;
}
```

### 2. 400 Bad Request: "studentId and password are required"

**원인**: 요청 JSON 필드명이 백엔드 예상과 다름

**해결**:
1. DIO 로그 확인: `flutter run`에서 요청 JSON 출력 보기
2. 백엔드 기대 필드명 확인
3. Dart 필드명을 백엔드 필드명과 일치시키기
4. 필요시 `@JsonKey(name: '...')` 사용

### 3. 로그인 성공했는데 홈으로 이동 안 됨

**원인**: JSON 파싱은 실패했지만 200 응답 받음

**디버깅**:
```dart
// 파싱 에러 확인
try {
  final response = await api.login(request);
  print('✅ 파싱 성공: ${response.user.name}');
} catch (e, stackTrace) {
  print('❌ 파싱 실패: $e');
  print('Stack: $stackTrace');
}
```

**해결**: 백엔드 응답 JSON과 Freezed 모델을 완벽히 일치시키기

### 4. Mock 데이터 컴파일 에러

**증상**:
```
The named parameter 'email' is required, but there's no corresponding argument.
The named parameter 'studentId' isn't defined.
```

**원인**: Mock 데이터가 변경된 모델 구조를 따르지 않음

**해결**: Mock 데이터를 Real API 구조와 동일하게 업데이트

```dart
// ❌ 잘못된 Mock 데이터
user: UserDto(
  id: 'mock_001',
  studentId: '1234',  // ← 필드 삭제됨!
)

// ✅ 수정된 Mock 데이터
user: UserDto(
  id: 'mock_001',
  email: '1234@sejong.local',  // ← 새로 추가된 필드
  role: 'student',
  name: '홍길동',
  major: '컴퓨터공학과',
)
```

---

## 🎯 체크리스트

### 새로운 API 연동 시

- [ ] Postman/curl로 실제 백엔드 응답 확인
- [ ] JSON 응답을 복사해서 [quicktype.io](https://quicktype.io) 에서 Dart 모델 자동 생성
- [ ] `@freezed` 어노테이션 추가
- [ ] `part 'xxx.freezed.dart'` 및 `part 'xxx.g.dart'` 추가
- [ ] 필드명이 백엔드와 100% 일치하는지 확인
- [ ] `dart run build_runner build --delete-conflicting-outputs` 실행
- [ ] Mock 데이터를 Real API 구조와 동일하게 작성
- [ ] Mock/Real 분기 Repository 메서드 작성
- [ ] DIO 로그로 요청/응답 JSON 확인
- [ ] 실제 로그인 테스트 성공 확인

---

## 📚 참고 문서

- [AUTH_API_SPEC.md](./AUTH_API_SPEC.md) - 구 명세서 (snake_case 기준, 참고용)
- [BACKEND_STATUS_REPORT.md](./BACKEND_STATUS_REPORT.md) - 백엔드 서버 상태
- [Freezed 공식 문서](https://pub.dev/packages/freezed)
- [Retrofit 공식 문서](https://pub.dev/packages/retrofit)

---

## 🎉 성공 사례

### 2025-11-21: 로그인 API 연동 완료

**문제 상황**:
- 백엔드는 200 응답 반환
- 프론트엔드는 "알 수 없는 오류" 표시
- 홈 화면으로 이동하지 않음

**원인 분석**:
1. LoginRequest: `student_id` (snake_case) 전송 → 백엔드는 `studentId` (camelCase) 기대
2. LoginResponse: `access_token` 파싱 시도 → 백엔드는 `accessToken` 반환
3. UserDto: `studentId` 필드 기대 → 백엔드는 `id`, `email` 반환
4. Mock 데이터: 변경된 모델 구조 미반영

**해결 방법**:
1. `@JsonKey` 어노테이션 전부 제거 (camelCase 일치)
2. 백엔드에 없는 필드 삭제 (`linked`, `sso`, `studentId`)
3. 백엔드 실제 필드 추가 (`id`, `email`, `year?`, `createdAt?`, `updatedAt?`)
4. Mock 데이터 동기화

**결과**: ✅ 로그인 성공 → 홈 화면 이동 성공!

**커밋**: `4c09892` "fix(auth): 백엔드 API 스펙과 일치하도록 로그인 모델 수정"

---

**💡 핵심 교훈**: 백엔드 응답 JSON을 **있는 그대로** Freezed 모델로 만들어야 합니다!