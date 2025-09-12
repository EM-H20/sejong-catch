# 📘 세종 캐치 Flutter 프론트엔드 설계 가이드

## 🎯 핵심 목표

**세종대학교 학생들을 위한 올인원 정보 허브**
- ✅ **정보 통합**: 공모전·취업·논문·공지사항을 한 곳에서
- ✅ **맞춤형 추천**: 학과/관심사 기반 스마트 필터링  
- ✅ **신뢰성 보장**: 출처별 신뢰도 및 우선순위 시각화
- ✅ **대기열 관리**: 인기 정보의 스마트 줄서기 시스템

---

## 🏗️ Clean Architecture 성공 사례: 로그인 페이지 리팩토링

### 리팩토링 전후 비교
```
🔥 리팩토링 성과
• Before: 1,043줄의 거대한 login_page.dart
• After: 145줄 (86% 코드 감소!) + 분리된 5개 컴포넌트
• 결과: 유지보수성 향상, 재사용성 증가, 버그 감소
```

### 성공한 폴더 구조 (모든 feature에 적용)
```
lib/features/auth/                    # ✅ 성공 사례
├── controllers/
│   └── login_controller.dart        # 모든 상태 관리 (308줄)
├── models/
│   └── login_step.dart              # 비즈니스 모델
├── pages/
│   └── login_page.dart              # UI 레이아웃만 (145줄)
├── services/
│   └── validation_service.dart      # 비즈니스 로직
└── widgets/ui/
    ├── login_header.dart            # 재사용 컴포넌트 (60줄)
    ├── login_card.dart              # 메인 폼 (350줄)
    ├── login_mode_toggle.dart       # 모드 전환 (80줄)
    └── login_footer.dart            # 하단 안내 (70줄)
```

### 핵심 성공 원칙

#### 1. 단일 책임 원칙 (SRP) 완벽 구현
- **Page**: 오직 레이아웃과 Provider 연결만
- **Controller**: 모든 상태 관리와 비즈니스 로직
- **Widgets**: 재사용 가능한 UI 컴포넌트
- **Services**: 도메인 로직 (검증, API 호출 등)

#### 2. Provider 패턴 + 콜백으로 안전한 비동기 처리
```dart
// ✅ BuildContext 문제 완벽 해결
Future<void> handleLogin({
  required VoidCallback onSuccess,
  required Function(String) onError,
}) async {
  // 비즈니스 로직...
}
```

---

## 🚀 필수 개발 규칙 (로그인 페이지에서 검증됨)

### 📱 ScreenUtil 100% 의무 사용
```dart
// ✅ 모든 크기는 반응형으로
width: 200.w          // 너비
height: 100.h         // 높이  
padding: 16.w         // 패딩
fontSize: 14.sp       // 폰트 크기
borderRadius: 8.r     // 모서리
```

### 🔄 DRY 원칙 철저 준수
- 같은 코드가 2번 나타나면 즉시 분리
- 공통 UI → `/core/widgets/`
- 공통 로직 → `/core/utils/` 또는 Services
- 상태 관리 → Controller 패턴

### ✅ 완전한 기능 구현 (TODO 금지)
- 모든 요구사항을 한 번에 완전 구현
- "TODO" 주석 절대 금지
- 에러 처리, 로딩 상태, 엣지 케이스까지 완벽 처리

---

## 🎨 디자인 시스템 (크림슨 레드)

### 컬러 토큰
```dart
// Brand Colors
static const brandCrimson = Color(0xFFDC143C);        
static const brandCrimsonDark = Color(0xFFB0102F);    
static const brandCrimsonLight = Color(0xFFF7E3E8);   

// 상태별 컬러
static const success = Color(0xFF16A34A);   
static const warning = Color(0xFFF59E0B);   
static const error = Color(0xFFDC2626);     
```

### 컴포넌트 상태
- **버튼**: Crimson → Pressed (Dark) → Disabled (Gray)
- **칩**: 선택 시 Crimson Light 배경 + Crimson 텍스트
- **카드**: 읽음 상태 Secondary, 만료 시 60% 불투명도

---

## 🛠️ 기술 스택 & 아키텍처

### 필수 패키지
```yaml
dependencies:
  # 상태 관리 & 라우팅
  provider: ^6.1.5                    # 메인 상태 관리
  go_router: ^16.2.1                  # 선언적 라우팅
  
  # 네트워킹 & 데이터
  dio: ^5.9.0                         # HTTP 클라이언트
  retrofit: ^4.7.2                    # API 인터페이스
  freezed: ^3.2.0                     # 불변 모델
  json_serializable: ^6.11.1         # JSON 직렬화
  
  # UI/UX 
  flutter_screenutil: ^5.9.3          # 반응형 디자인 (필수!)
  cached_network_image: ^3.4.1        # 이미지 최적화
  shimmer: ^3.0.0                     # 로딩 애니메이션
  infinite_scroll_pagination: ^5.1.1  # 무한 스크롤
```

### Clean Architecture 레이어
```
lib/
├── core/                  # 전역 공통 (테마, 라우팅, 공용 위젯)
├── data/                  # 데이터 계층 (API, 로컬 저장소)
├── domain/               # 비즈니스 로직 (Services, Controllers)
└── features/            # 기능별 구현 (성공한 auth 구조 복사)
```

---

## 📱 핵심 기능 & 화면 구조

### Bottom Navigation (4개 탭)
1. **피드** - 추천/마감임박/최신 + 무한 스크롤
2. **검색** - 검색바 + 고급 필터 바텀시트  
3. **줄서기** - 대기열 관리 + 순번 확인 (Student 이상)
4. **프로필** - 권한 관리, 개인화 설정

### 권한 시스템 (RBAC)
- **Guest**: 공개 정보 열람, 인증 유도
- **Student**: 맞춤 추천, 줄서기, 히스토리
- **Operator**: 수집 규칙, 제외어 관리  
- **Admin**: 통계 대시보드, 권한 로그

### 신뢰도 & 우선순위 시스템
- **TrustBadge**: Official(Shield) > Academic > Press > Community
- **PriorityBar**: 카드 상단 2-3px 컬러바 (High=Crimson)
- **상태 칩**: HOT, TREND, Recommended

---

## 🎯 온보딩 플로우 (4화면)

1. **Intro** - "세종인을 위한 단 하나의 정보 허브"
2. **수집·필터링** - "자동 수집 & 중복 제거, 신뢰도 반영"  
3. **권한 안내** - Guest/Student/Operator/Admin 설명
4. **개인화** - 학과 선택, 관심사 칩 설정

**구현**: PageView + SmoothPageIndicator + SharedPreferences 완료 플래그

---

## 🔐 보안 & 성능 가이드

### 데이터 보안
- **민감 정보**: FlutterSecureStorage (토큰, 인증 정보)
- **일반 설정**: SharedPreferences (테마, 언어 등)
- **입력 검증**: 모든 사용자 입력을 서버/클라이언트 양쪽 검증

### 성능 최적화
- **이미지**: CachedNetworkImage + 적절한 리사이징
- **리스트**: ListView.builder + PagedListView (무한 스크롤)
- **상태**: const 위젯 적극 활용, 불필요한 리빌드 방지

---

## 🌍 접근성 & 국제화

### 접근성 (A11y)
- **대비율**: 텍스트 4.5:1 이상 유지
- **터치 영역**: 최소 44×44dp 보장
- **스크린 리더**: Semantics 위젯 활용

### 다국어 지원
- 현재 한국어 우선, 향후 영어 확장 가능
- 긴 텍스트 줄바꿈 및 ellipsis 처리

---

## 🎨 마이크로카피 (한국적 톤앤매너)

### 인증 & 온보딩
- **Guest 유도**: "학생 인증이 필요한 정보입니다. 1분 만에 완료해요."
- **프로필 완성**: "프로필을 완성하면 더 정확한 추천을 받을 수 있어요"

### 기능 피드백  
- **북마크 성공**: "북마크에 담았어요. 마감 전에 확인해드릴게요"
- **줄서기 추가**: "대기열에 추가했어요. 순서가 되면 알려드릴게요"
- **중복 통합**: "유사 공지를 묶어 깔끔하게 정리했어요"

### 에러 & 빈 상태
- **네트워크 오류**: "인터넷 연결을 확인해주세요"
- **빈 검색**: "검색 결과가 없어요. 다른 키워드로 시도해보세요"
- **빈 대기열**: "아직 대기 중인 항목이 없어요"

---

## 🚦 개발 체크리스트

### 새 기능 개발 시 확인사항
- [ ] **폴더 구조**: auth/ 성공 패턴 복사 (controllers, models, pages, services, widgets)
- [ ] **상태 관리**: Provider + Controller 패턴 적용
- [ ] **UI 컴포넌트**: 재사용 가능하게 분리
- [ ] **ScreenUtil**: 모든 크기 값에 .w, .h, .r, .sp 적용
- [ ] **에러 처리**: 네트워크, 검증, 예외 상황 완벽 대응
- [ ] **로딩 상태**: Shimmer 또는 CircularProgressIndicator
- [ ] **빈 상태**: 친화적 메시지와 액션 버튼 제공
- [ ] **접근성**: 적절한 대비율과 터치 영역 보장

### 코드 품질 검증
- [ ] **DRY**: 중복 코드 없음
- [ ] **SRP**: 각 파일이 단일 책임만 가짐  
- [ ] **const**: 가능한 모든 위젯에 const 적용
- [ ] **Null Safety**: 안전한 null 처리
- [ ] **한국어**: 자연스러운 사용자 메시지

---

**🎉 이 가이드는 로그인 페이지에서 86% 코드 감소를 달성한 검증된 방법론입니다!**
모든 새로운 기능은 이 패턴을 따라 개발하면 유지보수성과 재사용성이 극대화됩니다.