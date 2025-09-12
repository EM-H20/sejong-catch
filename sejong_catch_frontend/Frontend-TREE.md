# 🏗️ 세종 캐치 Frontend 아키텍처 트리

## 🎯 성공 검증된 폴더 구조 (auth 리팩토링 기준)

**86% 코드 감소**를 달성한 `lib/features/auth/` 구조를 **모든 기능에 동일하게 적용**합니다.

---

## 📁 전체 프로젝트 구조

```
lib/
├── core/                           # 🌐 전역 공통 모듈
│   ├── config/                     # 환경 변수, 앱 상수
│   ├── theme/                      # AppTheme (크림슨 레드)
│   ├── routing/                    # GoRouter + 권한 가드
│   ├── utils/                      # 공통 유틸리티
│   └── widgets/                    # 재사용 위젯 (AppCard, CTAButton 등)
│
├── data/                           # 🗂️ 데이터 계층
│   ├── models/                     # Freezed 모델
│   ├── sources/remote/             # Dio + Retrofit API
│   ├── sources/local/              # SharedPreferences, SecureStorage  
│   └── repositories/               # Repository 패턴
│
├── domain/                         # 🧠 비즈니스 로직
│   ├── services/                   # 도메인 서비스 (Priority, Trust, Dedup)
│   └── controllers/                # Provider 전역 컨트롤러 (Auth, Theme 등)
│
└── features/                       # ✨ 기능별 구현 (성공 패턴 복사!)
    ├── auth/                       # ✅ 검증된 성공 사례
    ├── feed/                       # 복사할 구조
    ├── search/                     # 복사할 구조
    ├── queue/                      # 복사할 구조
    ├── profile/                    # 복사할 구조
    ├── onboarding/                 # 복사할 구조
    └── console/                    # 복사할 구조
```

---

## 🏆 성공 템플릿: `lib/features/auth/` 

**이 구조를 모든 feature에 복사하세요!**

```
lib/features/auth/                  # ✅ 86% 코드 감소 달성!
├── controllers/                    
│   └── login_controller.dart       # 🎛️ 모든 상태 관리 (308줄)
│                                   
├── models/                         
│   └── login_step.dart            # 📊 비즈니스 모델
│                                   
├── pages/                          
│   └── login_page.dart            # 🖼️ UI 레이아웃만 (145줄)
│                                   
├── services/                       
│   └── validation_service.dart    # 🔧 도메인 로직
│                                   
└── widgets/ui/                     # 🧩 재사용 컴포넌트들
    ├── login_header.dart          # 헤더 (60줄)
    ├── login_card.dart            # 메인 폼 (350줄)
    ├── login_mode_toggle.dart     # 모드 전환 (80줄)
    └── login_footer.dart          # 하단 안내 (70줄)
```

### 📋 각 폴더 역할 정의

| 폴더 | 책임 | 예시 |
|------|------|------|
| **controllers/** | Provider 상태 관리 | `login_controller.dart`, `search_controller.dart` |
| **models/** | 비즈니스 모델 | `login_step.dart`, `search_filter.dart` |
| **pages/** | UI 레이아웃 + Provider 연결 | `login_page.dart`, `search_page.dart` |
| **services/** | 도메인 로직 | `validation_service.dart`, `api_service.dart` |
| **widgets/ui/** | 재사용 UI 컴포넌트 | `login_card.dart`, `search_bar.dart` |

---

## 🚀 GoRouter 라우팅 구조

```
GoRouter
└── routes
    ├── /onboarding          -> OnboardingFlowPage    [guard: firstRunGuard]
    ├── /auth                -> AuthPage              
    ├── /                    -> RootShell (BottomNav) 
    │   ├── /feed            -> FeedPage              
    │   ├── /search          -> SearchPage           
    │   ├── /queue           -> QueuePage            [guard: role>=Student]
    │   └── /profile         -> ProfilePage          
    ├── /detail/:id          -> DetailPage           
    ├── /console             -> ConsoleShell         [guard: role>=Operator]
    │   ├── /console/rules   -> RulesPage           [guard: role>=Operator]
    │   └── /console/stats   -> StatsDashboardPage  [guard: role>=Admin]
    └── /settings            -> SettingsPage         
```

### 🛡️ 권한 가드 시스템
- **authGuard**: 로그인/학생 인증 확인
- **roleGuard**: Guest < Student < Operator < Admin  
- **firstRunGuard**: 온보딩 완료 여부 (SharedPreferences)

---

## 🧩 기능별 구현 가이드 (auth 패턴 복사)

### 📺 피드 페이지
```
lib/features/feed/
├── controllers/
│   └── feed_controller.dart        # 탭별 상태, 페이지네이션
├── models/
│   └── feed_item.dart             # Item, PriorityLevel, TrustLevel
├── pages/
│   └── feed_page.dart             # Scaffold + TabBarView
├── services/
│   └── feed_service.dart          # API 호출, 정렬 로직
└── widgets/ui/
    ├── feed_tab_bar.dart          # 추천/마감임박/최신 탭
    ├── feed_item_card.dart        # AppCard 확장
    └── feed_empty_view.dart       # 빈 상태 UI
```

### 🔍 검색 페이지
```
lib/features/search/
├── controllers/
│   └── search_controller.dart      # 검색 상태, 필터 관리
├── models/
│   ├── search_filter.dart         # 필터 조건
│   └── search_result.dart         # 검색 결과
├── pages/
│   └── search_page.dart           # 검색바 + 결과 리스트
├── services/
│   └── search_service.dart        # 검색 API, 디바운싱
└── widgets/ui/
    ├── search_app_bar.dart        # 검색 입력 바
    ├── filter_bottom_sheet.dart   # 고급 필터
    ├── filter_chip_group.dart     # 저장된 필터 칩
    └── recent_keywords.dart       # 최근 검색어
```

### 🚶‍♂️ 줄서기 페이지
```
lib/features/queue/
├── controllers/
│   └── queue_controller.dart       # 대기열 상태, 순번 관리
├── models/
│   ├── queue_item.dart            # 대기열 아이템
│   └── queue_status.dart          # 대기중/진행중/완료
├── pages/
│   └── queue_page.dart            # 탭별 대기열 리스트
├── services/
│   └── queue_service.dart         # 순번 계산, 알림 스케줄링
└── widgets/ui/
    ├── queue_tab_view.dart        # 상태별 탭
    ├── queue_item_card.dart       # 순번, D-day, 진행률
    └── queue_actions.dart         # 제거/설정 액션
```

### 👤 프로필 페이지
```
lib/features/profile/
├── controllers/
│   └── profile_controller.dart     # 사용자 정보, 설정 관리
├── models/
│   ├── user_profile.dart          # 사용자 프로필
│   └── app_settings.dart          # 앱 설정
├── pages/
│   └── profile_page.dart          # 설정 섹션들
├── services/
│   └── profile_service.dart       # 프로필 업데이트 API
└── widgets/ui/
    ├── user_header.dart           # 이름, 역할 배지
    ├── settings_section.dart      # 설정 그룹
    ├── department_dropdown.dart   # 학과 선택
    └── interest_chips.dart        # 관심사 칩
```

### 🎯 온보딩 페이지
```
lib/features/onboarding/
├── controllers/
│   └── onboarding_controller.dart  # 단계 관리, 완료 플래그
├── models/
│   └── onboarding_step.dart       # 온보딩 단계 enum
├── pages/
│   └── onboarding_flow_page.dart  # PageView + 진행률
├── services/
│   └── onboarding_service.dart    # SharedPreferences 관리
└── widgets/ui/
    ├── intro_page.dart            # 인트로 화면
    ├── collect_filter_page.dart   # 수집/필터링 설명
    ├── roles_page.dart            # 권한 안내
    └── personalize_page.dart      # 개인화 설정
```

### 🎮 콘솔 페이지 (운영자/관리자)
```
lib/features/console/
├── controllers/
│   └── console_controller.dart     # 규칙 관리, 통계
├── models/
│   ├── collection_rule.dart       # 수집 규칙
│   └── admin_stats.dart           # 통계 데이터
├── pages/
│   ├── console_shell.dart         # 콘솔 메인
│   ├── rules_page.dart           # 규칙 관리
│   └── stats_dashboard_page.dart  # 통계 대시보드
├── services/
│   └── admin_service.dart         # 관리자 API
└── widgets/ui/
    ├── console_card.dart          # 콘솔 메뉴 카드
    ├── rule_editor.dart           # 규칙 편집기
    └── stats_chart.dart           # 통계 차트
```

---

## 🎨 공용 위젯 라이브러리 (`/core/widgets/`)

**모든 기능에서 재사용하는 컴포넌트들**

```
lib/core/widgets/
├── cards/
│   ├── app_card.dart              # 🏷️ 기본 정보 카드
│   └── priority_bar.dart          # 🔴 우선순위 컬러 바
├── buttons/
│   ├── cta_button.dart            # 🔘 메인 액션 버튼 (크림슨)
│   └── icon_button_ext.dart       # 🎯 확장 아이콘 버튼
├── inputs/
│   ├── search_app_bar.dart        # 🔍 검색 앱바
│   └── filter_chip_group.dart     # 🏷️ 필터 칩 그룹
├── feedback/
│   ├── skeleton_list.dart         # ⏳ Shimmer 로딩 리스트
│   ├── empty_view.dart            # 📭 빈 상태 UI
│   └── error_view.dart            # ❌ 에러 상태 UI
└── indicators/
    ├── trust_badge.dart           # 🛡️ 신뢰도 배지
    └── smooth_page_indicator.dart  # 📍 페이지 인디케이터
```

---

## 🎛️ Provider 상태 관리 패턴

### MultiProvider 구조 (main.dart)
```dart
MultiProvider(
  providers: [
    // 전역 컨트롤러들
    ChangeNotifierProvider(create: (_) => AuthController()),
    ChangeNotifierProvider(create: (_) => ThemeController()),
    
    // 기능별 컨트롤러들 (페이지별 생성)
    ChangeNotifierProvider(create: (_) => FeedController()),
    ChangeNotifierProvider(create: (_) => SearchController()),
    ChangeNotifierProvider(create: (_) => QueueController()),
    ChangeNotifierProvider(create: (_) => ProfileController()),
  ],
  child: MyApp(),
)
```

### 컨트롤러 패턴 (성공 검증된 방식)
```dart
class FeatureController extends ChangeNotifier {
  // 상태 변수들
  bool _isLoading = false;
  String? _error;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // 콜백 패턴으로 안전한 비동기 처리
  Future<void> handleAction({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    // 비즈니스 로직...
  }
}
```

---

## 📱 하단 네비게이션 구조

```
RootShell (Scaffold)
├── body: IndexedStack              # 탭 상태 유지
│   ├── FeedPage                   # 0: 피드
│   ├── SearchPage                 # 1: 검색  
│   ├── QueuePage                  # 2: 줄서기 [Student+]
│   └── ProfilePage                # 3: 프로필
└── bottomNavigationBar: AppBottomNav
```

### 권한별 탭 노출
- **Guest**: 피드, 검색, 프로필 (3개)
- **Student+**: 피드, 검색, 줄서기, 프로필 (4개)
- **Operator+**: 콘솔 액세스 추가

---

## 🚦 개발 체크리스트 (새 기능 추가 시)

### 1. 폴더 구조 생성
- [ ] `lib/features/[기능명]/` 디렉토리 생성
- [ ] `controllers/`, `models/`, `pages/`, `services/`, `widgets/ui/` 하위 폴더 생성

### 2. 파일 생성 (auth 패턴 복사)
- [ ] `[기능명]_controller.dart` - Provider 상태 관리
- [ ] `[기능명]_page.dart` - 메인 UI 페이지 (레이아웃만)
- [ ] 필요한 model, service, widget 파일들 생성

### 3. Provider 연결
- [ ] MultiProvider에 Controller 추가
- [ ] Page에서 Consumer<Controller> 패턴 사용
- [ ] 콜백 패턴으로 비동기 처리

### 4. GoRouter 라우팅
- [ ] 라우트 경로 추가
- [ ] 필요 시 권한 가드 적용
- [ ] 네비게이션 테스트

### 5. 공용 위젯 활용
- [ ] `/core/widgets/` 컴포넌트 최대한 재사용
- [ ] ScreenUtil 모든 크기에 적용
- [ ] 일관된 디자인 시스템 준수

---

## 🎯 핵심 성공 요소

### ✅ 검증된 패턴 (auth에서 86% 감소 달성)
1. **단일 책임 원칙**: 각 파일이 하나의 역할만
2. **Provider + 콜백**: 안전한 비동기 상태 관리
3. **컴포넌트 분리**: 재사용 가능한 UI 위젯들
4. **DRY 원칙**: 중복 코드 철저 제거

### 🎨 일관성 유지
- 모든 기능이 동일한 폴더 구조
- 동일한 네이밍 컨벤션
- 통일된 에러 처리 및 로딩 상태
- 크림슨 레드 테마 일관성

### 🚀 확장성 고려
- 새로운 기능 추가 시 기존 패턴 복사
- 공용 컴포넌트 우선 활용
- Provider 의존성 최소화
- 테스트 가능한 구조 유지

---

**🏆 이 구조는 로그인 페이지에서 86% 코드 감소를 달성한 검증된 성공 패턴입니다!**
모든 새로운 기능은 이 템플릿을 따라 개발하면 일관성 있고 유지보수하기 쉬운 코드가 됩니다.