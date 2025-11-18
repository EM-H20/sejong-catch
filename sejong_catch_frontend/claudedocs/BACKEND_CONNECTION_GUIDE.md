# 🔥 백엔드 서버 연결 가이드

**노드 백엔드 서버**와 **Mock 데이터** 자동 전환 시스템 완성! 🎉

---

## 🎯 핵심 요약

### ✅ 구현 완료 사항
```yaml
환경 설정:
  - .env 파일 생성 (NODE_BACKEND_URL=http://152.67.219.91:8888)
  - ApiConfig 환경변수 기반 URL 분기
  - Auth API 엔드포인트 수정 (/auth/login)

Feed 도메인:
  - FeedApi (Retrofit) 생성
  - FeedRepository Mock/Real 분기 구현
  - 카테고리 필터링, 페이지네이션, 북마크 지원

자동 전환:
  - USE_MOCK_AUTH=true → Mock 데이터
  - USE_MOCK_AUTH=false → 실제 백엔드 API
```

---

## 🚀 빠른 사용법

### 방법 1: VS Code에서 실행 (추천!)

1. **Run and Debug** 탭 열기 (⇧⌘D)
2. 드롭다운에서 선택:
   - **🎭 Mock 모드 (개발용)** ← 학번 1234, Mock 피드
   - **🔥 Real 모드 (백엔드 연동)** ← 실제 서버 연결
3. ▶️ 버튼 클릭!

### 방법 2: 터미널 명령어

```bash
# Mock 모드 (학번 1234, Mock 피드)
flutter run --dart-define=USE_MOCK_AUTH=true

# Real 모드 (실제 백엔드 http://152.67.219.91:8888)
flutter run --dart-define=USE_MOCK_AUTH=false

# Default (Mock 모드)
flutter run
```

---

## 🏗️ 아키텍처 구조

### 환경변수 기반 자동 전환 시스템

```dart
// lib/core/config/api_config.dart
static String get baseUrl {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

  if (useMock) {
    return 'http://127.0.0.1:8081';  // Mock (실제로는 API 호출 안 함)
  } else {
    return 'http://152.67.219.91:8888';  // Real 백엔드 서버
  }
}
```

### Auth 도메인 (기존)

```dart
// lib/features/auth/data/repositories/auth_repository.dart
Future<LoginResponse> login(String studentId, String password) async {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

  if (useMock) {
    return _mockLogin(studentId, password);  // 학번 1234만 허용
  } else {
    return _realLogin(studentId, password);  // POST /auth/login
  }
}
```

### Feed 도메인 (신규 구현!)

```dart
// lib/features/feed/data/repositories/feed_repository.dart
Future<List<FeedItem>> getFeedList({String? category, int page = 1}) async {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

  if (useMock) {
    return _mockFeedList(category: category, page: page);  // 더미 데이터
  } else {
    return _realFeedList(category: category, page: page);  // GET /feed
  }
}
```

---

## 📡 백엔드 API 스펙

### Base URL
```
Mock 모드: http://127.0.0.1:8081 (사용 안 함)
Real 모드: http://152.67.219.91:8888
```

### Auth API (구현 완료 ✅)

#### POST /auth/login
**Request**:
```json
{
  "studentId": "20181234",
  "password": "mypassword"
}
```

**Response**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "user_123",
    "studentId": "20181234",
    "role": "student",
    "name": "홍길동",
    "major": "컴퓨터공학과"
  }
}
```

**Status Codes**:
- `200`: 로그인 성공
- `400`: 필수 값 누락
- `401`: 인증 실패

### Feed API (구현 완료 ✅)

#### GET /feed
**Query Parameters**:
- `category` (optional): '전체', '공모전', '취업', '논문', '학교공지', '축제'
- `page` (optional): 페이지 번호 (기본값: 1)
- `limit` (optional): 페이지당 아이템 수 (기본값: 20)

**Response**:
```json
[
  {
    "id": "feed_001",
    "title": "2024 캡스톤 디자인 경진대회",
    "description": "우수작 선정 시 상금 300만원 + 창업 지원",
    "category": "공모전",
    "thumbnailUrl": "https://example.com/thumb.jpg",
    "dDay": 7,
    "viewCount": 1234,
    "priority": "high",
    "isBookmarked": false,
    "createdAt": "2025-01-15T10:30:00Z"
  }
]
```

#### GET /feed/{id}
**Response**: 단일 FeedItem 객체 (위와 동일)

#### POST /feed/{id}/bookmark
**Response**: `200 OK` (북마크 토글 성공)

---

## 🎭 Mock 모드 동작

### Auth Mock
```dart
학번: 1234
비밀번호: 1234

// 잘못된 학번/비밀번호 입력 시
throw Exception('Mock 모드: 학번 1234 / 비밀번호 1234만 사용 가능합니다');
```

### Feed Mock
```dart
// 5개의 더미 피드 아이템 반환
- 캡스톤 디자인 경진대회 (공모전)
- 네이버 클라우드 신입 채용 (취업)
- 한국정보과학회 논문 공모 (논문)
- 수강신청 안내 (학교공지)
- 세종대 대동제 부스 모집 (축제)

// 네트워크 지연 시뮬레이션
await Future.delayed(const Duration(milliseconds: 500));
```

---

## 🔥 Real 모드 동작

### Auth Real
```dart
// 실제 백엔드 API 호출
POST http://152.67.219.91:8888/auth/login

// 세종대 포털 로그인 정보로 인증
studentId: "실제 학번"
password: "실제 비밀번호"
```

### Feed Real
```dart
// 실제 백엔드 API 호출
GET http://152.67.219.91:8888/feed?category=공모전&page=1&limit=20

// 백엔드 데이터베이스에서 실제 피드 조회
```

---

## 🧪 테스트 시나리오

### ✅ Mock 모드 테스트
```bash
flutter run --dart-define=USE_MOCK_AUTH=true
```

1. **로그인 테스트**
   - 학번 `1234`, 비밀번호 `1234` 입력
   - ✅ 성공: "홍길동" 사용자로 로그인
   - ❌ 실패: 다른 학번 입력 시 에러 메시지

2. **피드 조회 테스트**
   - 피드 페이지 진입
   - ✅ 5개의 더미 피드 아이템 표시
   - ✅ 카테고리 필터 동작 (공모전, 취업, 논문 등)

### ✅ Real 모드 테스트
```bash
flutter run --dart-define=USE_MOCK_AUTH=false
```

1. **로그인 테스트**
   - 실제 세종대 학번/비밀번호 입력
   - ✅ 성공: 백엔드에서 JWT 토큰 발급
   - ❌ 실패: 401 Unauthorized

2. **피드 조회 테스트**
   - 피드 페이지 진입
   - ✅ 백엔드 데이터베이스에서 실제 피드 조회
   - ✅ 카테고리 필터, 페이지네이션 동작

---

## 📂 관련 파일

### 핵심 파일
```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart              # ✅ 환경변수 기반 URL 분기
│   └── network/
│       └── dio_provider.dart            # Dio 인스턴스 제공
│
├── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_api.dart        # ✅ POST /auth/login
    │   │   └── repositories/
    │   │       └── auth_repository.dart # ✅ Mock/Real 분기
    │
    └── feed/
        └── data/
            ├── datasources/
            │   └── feed_api.dart        # ✅ GET /feed, /feed/{id}
            └── repositories/
                └── feed_repository.dart # ✅ Mock/Real 분기
```

### 설정 파일
```
.env                      # NODE_BACKEND_URL 설정
.vscode/launch.json       # VS Code 실행 프로파일
AUTH_MOCK_GUIDE.md        # Auth Mock 가이드 (기존)
```

---

## 🚨 주의사항

### Mock 모드
- ⚠️ **프로덕션 배포 금지!**
- ⚠️ 학번 1234 이외의 계정은 로그인 불가
- ⚠️ Feed는 5개 더미 데이터만 표시
- ⚠️ 네트워크 지연 시뮬레이션 (500ms)

### Real 모드
- ⚠️ 백엔드 서버가 실행 중이어야 함
- ⚠️ 네트워크 연결 필요
- ⚠️ 실제 세종대 포털 로그인 정보 필요
- ⚠️ API 응답 구조가 다르면 `LoginResponse`, `FeedItem` 모델 수정 필요

### API 응답 구조 불일치 시
```dart
// 백엔드 응답이 다를 경우
// lib/features/auth/data/models/response/login_response.dart
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,  // 매핑!
    @JsonKey(name: 'refresh_token') required String refreshToken,
    // ...
  }) = _LoginResponse;
}
```

---

## 🎉 완료 체크리스트

### ✅ 환경 설정
- [x] `.env` 파일 생성
- [x] `ApiConfig.baseUrl` 환경변수 분기
- [x] Auth API 엔드포인트 수정 (`/auth/login`)

### ✅ Feed 도메인
- [x] `FeedApi` Retrofit 인터페이스 생성
- [x] `FeedRepository` Mock/Real 분기 구현
- [x] 카테고리 필터링, 페이지네이션 지원
- [x] 북마크 토글 기능

### ✅ 코드 생성
- [x] `dart run build_runner build` 실행
- [x] `auth_api.g.dart` 생성
- [x] `feed_api.g.dart` 생성
- [x] `feed_repository.g.dart` 생성

---

## 🔥 다음 단계

### 1. UI 연동 (Feed Page에서 Repository 사용)
```dart
// lib/features/feed/presentation/pages/feed_page.dart
final feedListProvider = FutureProvider.family<List<FeedItem>, String?>((ref, category) async {
  final repository = ref.read(feedRepositoryProvider.notifier);
  return await repository.getFeedList(category: category);
});
```

### 2. 실제 백엔드 테스트
```bash
# Real 모드로 실행
flutter run --dart-define=USE_MOCK_AUTH=false

# 실제 학번/비밀번호로 로그인
# 피드 데이터가 백엔드에서 조회되는지 확인
```

### 3. 에러 처리 강화
```dart
try {
  final feedList = await repository.getFeedList();
} catch (e) {
  if (e is DioException && e.response?.statusCode == 401) {
    // 인증 만료 → 로그인 페이지로 이동
  }
}
```

---

## 💡 핵심 포인트

### 🎯 Zero Configuration
- 개발자: `flutter run` → 자동 Mock
- QA: `flutter run --dart-define=USE_MOCK_AUTH=false` → Real
- 배포: `flutter build apk --dart-define=USE_MOCK_AUTH=false`

### 🎯 DRY 원칙
- `USE_MOCK_AUTH` 환경변수 **한 곳**에서 모든 도메인 제어
- Auth, Feed, Search, Queue, Profile 모두 같은 패턴

### 🎯 안전한 전환
- Mock → Real 전환 시 코드 변경 **0줄**
- 환경변수만 바꾸면 끝!

---

**Last Updated**: 2025-11-17
**Status**: ✅ 구현 완료 - Real 모드 테스트 대기 중!

**🎉 백엔드 연결 준비 완료! 이제 실제 서버와 연결하면 끝!** 🚀
