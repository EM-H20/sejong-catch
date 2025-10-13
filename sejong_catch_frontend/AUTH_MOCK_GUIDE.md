# 🎭 Mock/Real 인증 전환 가이드

백엔드 개발 중 Mock 데이터로 프론트엔드 개발하고, 백엔드 준비되면 즉시 전환!

---

## 🚀 빠른 사용법

### 방법 1: VS Code에서 버튼 클릭 (추천!)

1. VS Code에서 `Run and Debug` 탭 열기 (⇧⌘D)
2. 드롭다운에서 선택:
   - **🎭 Mock 모드 (개발용)** ← 학번 1234로 로그인
   - **🔥 Real 모드 (프로덕션)** ← 실제 백엔드 API
   - **📱 Default (Mock)** ← 기본 Mock 모드
3. ▶️ 버튼 클릭!

### 방법 2: 터미널 명령어

```bash
# Mock 모드 (개발용)
flutter run --dart-define=USE_MOCK_AUTH=true

# Real 모드 (백엔드 연동)
flutter run --dart-define=USE_MOCK_AUTH=false

# Default (Mock 모드)
flutter run
```

---

## 🎯 Mock 로그인 정보

### 테스트 계정
```
학번: 1234
비밀번호: 1234
```

### Mock 응답 데이터
```dart
이름: 홍길동
학과: 컴퓨터공학과
학번: 1234
역할: student
토큰: mock_access_token_abc123xyz (가짜)
```

---

## 🔧 환경 변수 설명

### `USE_MOCK_AUTH`
- **`true`**: Mock 로그인 사용 (학번 1234만 허용)
- **`false`**: 실제 백엔드 API 호출
- **기본값**: `true` (설정 안 하면 Mock 모드)

---

## 📂 관련 파일

### 핵심 파일
```
lib/features/auth/data/repositories/auth_repository.dart
```
- `_mockLogin()`: Mock 로그인 로직
- `_realLogin()`: 실제 API 호출 로직
- 환경 변수로 자동 전환

### 설정 파일
```
.vscode/launch.json
```
- VS Code 실행 프로파일 정의
- Mock/Real 전환 버튼 추가

---

## 🎨 실행 프로파일 상세

### 🎭 Mock 모드 (개발용)
- **언제 사용?**: 백엔드 없이 UI 개발할 때
- **장점**:
  - 네트워크 없어도 작동
  - 빠른 테스트 가능
  - 항상 성공 응답
- **제한**: 학번 1234 / 비번 1234만 로그인 가능

### 🔥 Real 모드 (프로덕션)
- **언제 사용?**: 백엔드 준비되었을 때
- **장점**:
  - 실제 세종대 포털 인증
  - 모든 학번으로 로그인 가능
  - 실제 사용자 데이터
- **요구사항**: 백엔드 API 서버 실행 필요

---

## 🔍 동작 원리

### 코드 구조
```dart
Future<LoginResponse> login(String studentId, String password) async {
  const useMock = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);

  if (useMock) {
    return _mockLogin(studentId, password);  // Mock 데이터 반환
  } else {
    return _realLogin(studentId, password);  // 실제 API 호출
  }
}
```

### 흐름도
```
사용자 → login() → 환경 변수 체크
                    ↓
          ┌─────────┴─────────┐
          ↓                    ↓
    _mockLogin()          _realLogin()
    (가짜 데이터)          (실제 API)
          ↓                    ↓
       LoginResponse ←─────────┘
```

---

## 🚨 주의사항

### Mock 모드
- ⚠️ **프로덕션에 배포하면 안 됨!**
- ⚠️ 학번 1234 이외의 계정은 "Mock 모드" 에러 발생
- ⚠️ 1초 지연 시뮬레이션 (실제 네트워크 흉내)

### Real 모드
- ⚠️ 백엔드 API 서버가 실행 중이어야 함
- ⚠️ 네트워크 연결 필요
- ⚠️ 실제 세종대 포털 로그인 정보 필요

---

## 🎉 완료!

이제 백엔드 상태에 따라 자유롭게 전환하면서 개발할 수 있어요!

**개발 중** → 🎭 Mock 모드
**백엔드 준비됨** → 🔥 Real 모드
**배포 전** → 🔥 Real 모드 (필수!)

---

**Last Updated**: 2025-10-13
**Author**: Claude Code 🤖
