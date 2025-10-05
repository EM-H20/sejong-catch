# 🏗️ 세종 캐치 Frontend 아키텍처 트리

## 🎯 성공 검증된 폴더 구조 (auth 리팩토링 기준)

**86% 코드 감소**를 달성한 `lib/features/auth/` 구조를 **모든 기능에 동일하게 적용**합니다.

**🚨 중요 변경**: Freezed 사용하지 않음 - 일반 Dart 클래스로 모델 작성

---

## 📁 전체 프로젝트 구조

```
lib/
├── app/                            # 🌐 앱 전역 설정
│   ├── config/                     # 라우팅, 테마, 환경 변수
│   └── providers/                  # 전역 Provider (@riverpod)
│
├── core/                           # 🔧 공용 모듈
│   ├── widgets/                    # 재사용 위젯 (AppCard, CTAButton 등)
│   ├── theme/                      # AppTheme (크림슨 레드)
│   ├── utils/                      # 공통 유틸리티
│   └── constants/                  # 상수 정의
│
└── features/                       # ✨ 기능별 Clean Architecture
    ├── auth/                       # ✅ 검증된 성공 사례
    ├── feed/                       # 복사할 구조
    ├── search/                     # 복사할 구조
    ├── queue/                      # 복사할 구조
    ├── profile/                    # 복사할 구조
    ├── onboarding/                 # 복사할 구조
    └── console/                    # 복사할 구조

    # 각 Feature 내부 구조 (모든 Feature 동일 적용!)
    └── [feature_name]/
        ├── data/                   # 📡 데이터 계층
        │   ├── models/             # API DTO (일반 Dart 클래스)
        │   ├── repositories/       # Repository 구현체 (Retrofit)
        │   └── datasources/        # API, Local 데이터 소스
        ├── domain/                 # 🧠 비즈니스 로직
        │   ├── entities/           # 순수 비즈니스 엔티티
        │   └── repositories/       # Repository 인터페이스
        └── presentation/           # 🎨 UI 계층
            ├── controllers/        # @riverpod Notifier
            ├── pages/              # ConsumerWidget 페이지
            └── widgets/            # Feature 전용 위젯
```

---

## 🏆 성공 템플릿: `lib/features/auth/`

**이 구조를 모든 feature에 복사하세요!**

```
lib/features/auth/                  # ✅ 86% 코드 감소 달성!
├── data/
│   ├── models/
│   │   ├── login_request.dart     # 📊 API 요청 DTO (일반 클래스)
│   │   └── auth_response.dart     # 📊 API 응답 DTO (일반 클래스)
│   ├── repositories/
│   │   └── auth_repository_impl.dart # 🔌 Retrofit 구현체
│   └── datasources/
│       └── auth_remote_datasource.dart # 🌐 API 호출 로직
│
├── domain/
│   ├── entities/
│   │   └── user.dart              # 🎯 순수 비즈니스 엔티티
│   └── repositories/
│       └── auth_repository.dart   # 📜 Repository 인터페이스
│
└── presentation/
    ├── controllers/
    │   └── login_controller.dart  # 🎛️ @riverpod Notifier (308줄)
    ├── pages/
    │   └── login_page.dart        # 🖼️ ConsumerWidget (145줄)
    └── widgets/ui/                 # 🧩 재사용 컴포넌트들
        ├── login_header.dart      # 헤더 (60줄)
        ├── login_card.dart        # 메인 폼 (350줄)
        ├── login_mode_toggle.dart # 모드 전환 (80줄)
        └── login_footer.dart      # 하단 안내 (70줄)
```

### 📋 각 폴더 역할 정의

| 폴더 | 책임 | 예시 |
|------|------|------|
| **data/models/** | API DTO (요청/응답) | `login_request.dart`, `auth_response.dart` |
| **data/repositories/** | Repository 구현체 (Retrofit) | `auth_repository_impl.dart` |
| **data/datasources/** | 외부 데이터 소스 | `auth_remote_datasource.dart` |
| **domain/entities/** | 순수 비즈니스 엔티티 | `user.dart`, `feed_item.dart` |
| **domain/repositories/** | Repository 인터페이스 | `auth_repository.dart` |
| **presentation/controllers/** | @riverpod Notifier 상태 관리 | `login_controller.dart` |
| **presentation/pages/** | ConsumerWidget UI 페이지 | `login_page.dart` |
| **presentation/widgets/** | Feature 전용 UI 컴포넌트 | `login_card.dart` |

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
│   └── feed_item.dart             # 일반 클래스: Item, PriorityLevel, TrustLevel
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
│   ├── search_filter.dart         # 일반 클래스: 필터 조건
│   └── search_result.dart         # 일반 클래스: 검색 결과
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

### 🎪 줄서기 페이지 (축제/행사 큐 시스템)
```
lib/features/queue/
├── data/
│   ├── models/
│   │   ├── queue_model.dart        # 큐 데이터 모델 (일반 클래스)
│   │   ├── participant_model.dart  # 참가자 모델
│   │   └── queue_state.dart        # 큐 상태 모델
│   ├── repositories/
│   │   └── queue_repository_impl.dart # Repository 구현체
│   └── datasources/
│       └── queue_local_datasource.dart # Mock 데이터 소스
├── domain/
│   ├── entities/
│   │   ├── queue_entity.dart       # 큐 엔티티
│   │   └── participant_entity.dart # 참가자 엔티티
│   └── repositories/
│       └── queue_repository.dart   # Repository 인터페이스
└── presentation/
    ├── controllers/
    │   ├── queue_controller.dart   # 큐 목록 상태 관리
    │   ├── queue_detail_controller.dart # 상세 상태 관리
    │   └── queue_create_controller.dart # 생성 상태 관리 (Operator용)
    ├── pages/
    │   ├── queue_page.dart         # 메인 큐 목록 (리팩토링)
    │   ├── queue_detail_page.dart  # 큐 상세 & 줄서기
    │   ├── queue_create_page.dart  # 운영자용 큐 생성
    │   └── queue_manage_page.dart  # 운영자용 관리 대시보드
    └── widgets/ui/
        ├── queue_card.dart         # 큐 카드 컴포넌트
        ├── participant_list.dart   # 참가자 목록 (운영자용)
        ├── queue_status_badge.dart # 상태 뱃지 (active/paused/full)
        └── operator_fab.dart       # 운영자 전용 FAB 버튼
```

### 👤 프로필 페이지
```
lib/features/profile/
├── controllers/
│   └── profile_controller.dart     # 사용자 정보, 설정 관리
├── models/
│   ├── user_profile.dart          # 일반 클래스: 사용자 프로필
│   └── app_settings.dart          # 일반 클래스: 앱 설정
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
│   └── onboarding_step.dart       # 일반 클래스: 온보딩 단계 enum
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
│   ├── collection_rule.dart       # 일반 클래스: 수집 규칙
│   └── admin_stats.dart           # 일반 클래스: 통계 데이터
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

## 🚀 Riverpod 상태 관리 패턴 (Freezed 없이!)

### ProviderScope 구조 (main.dart) - 훨씬 간단해짐!
```dart
void main() {
  runApp(
    ProviderScope(  // 🔥 하나로 끝! 모든 Provider 자동 관리
      observers: [
        if (kDebugMode) RiverpodLogger(), // 디버깅 자동화
      ],
      child: const MyApp(),
    ),
  );
}

// 전역 Provider들 (자동으로 의존성 해결!)
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() => const AuthState();
}

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeState build() => const ThemeState();
}

@riverpod
class FeedController extends _$FeedController {
  @override
  FeedState build() => const FeedState();
}
```

### Riverpod 컨트롤러 패턴 (일반 클래스 + copyWith!)
```dart
// 1. 상태 클래스 정의 (일반 Dart 클래스로 불변성 보장)
class FeatureState {
  final bool isLoading;
  final String? error;
  final List<Item> items;

  const FeatureState({
    this.isLoading = false,
    this.error,
    this.items = const [],
  });

  // copyWith 수동 구현
  FeatureState copyWith({
    bool? isLoading,
    String? error,
    List<Item>? items,
  }) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      items: items ?? this.items,
    );
  }
}

// 2. Notifier 컨트롤러 (타입 안전성 완벽 보장!)
@riverpod
class FeatureController extends _$FeatureController {
  @override
  FeatureState build() => const FeatureState();

  // 🔥 컴파일 타임 안전성 + 자동 리빌드!
  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 의존성 자동 주입 (ref.read/watch)
      final items = await ref.read(repositoryProvider).getItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 자동 캐싱 + 의존성 추적
  void selectItem(Item item) {
    final updatedItems = state.items.map((i) =>
      i.id == item.id ? item.copyWith(isSelected: true) : i
    ).toList();

    state = state.copyWith(items: updatedItems);
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

### 1. Clean Architecture 폴더 구조 생성
- [ ] `lib/features/[기능명]/` 디렉토리 생성
- [ ] `data/` - models, repositories, datasources 폴더 생성
- [ ] `domain/` - entities, repositories 폴더 생성
- [ ] `presentation/` - controllers, pages, widgets 폴더 생성

### 2. 파일 생성 (auth Clean Architecture 패턴 복사)
- [ ] **Data Layer**: DTO 모델, Repository 구현체, Datasource
- [ ] **Domain Layer**: 비즈니스 엔티티, Repository 인터페이스
- [ ] **Presentation Layer**: @riverpod Controller, ConsumerWidget Page, UI 위젯

### 3. Riverpod 연결 (일반 클래스 사용!)
- [ ] 일반 Dart 클래스로 상태 모델 작성 (Freezed X)
- [ ] copyWith 메서드 수동 구현
- [ ] @riverpod 어노테이션으로 Provider 자동 생성
- [ ] ConsumerWidget으로 Page 구현
- [ ] ref.watch()로 상태 반응형 구독
- [ ] ref.read()로 메서드 호출 (side effect 방지)
- [ ] dart run build_runner build로 코드 생성

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

### ✅ 검증된 패턴 (auth에서 86% 감소 달성) + Riverpod!
1. **단일 책임 원칙**: 각 파일이 하나의 역할만
2. **일반 클래스 + copyWith**: Freezed 없이 안전한 불변 상태 관리 🚀
3. **컴포넌트 분리**: ConsumerWidget으로 반응형 UI
4. **DRY 원칙**: 중복 코드 철저 제거 + 코드 생성 자동화
5. **타입 안전성**: 컴파일 타임 에러 방지
6. **자동 최적화**: 메모이제이션과 의존성 추적

### 🎨 일관성 유지
- 모든 기능이 동일한 폴더 구조
- 동일한 네이밍 컨벤션
- 통일된 에러 처리 및 로딩 상태
- 크림슨 레드 테마 일관성

### 🚀 Riverpod으로 더 강력해진 확장성
- 새로운 기능 추가 시 기존 패턴 복사
- @riverpod 어노테이션으로 보일러플레이트 제거
- 공용 컴포넌트 우선 활용 + ConsumerWidget
- 자동 의존성 관리로 Provider 간 결합도 최소화
- 테스트 가능한 구조 유지 + ProviderContainer로 격리 테스트
- Freezed 없이도 타입 안전한 상태 관리

---

**🏆 이 구조는 로그인 페이지에서 86% 코드 감소를 달성한 검증된 성공 패턴입니다!**
모든 새로운 기능은 이 템플릿을 따라 개발하면 일관성 있고 유지보수하기 쉬운 코드가 됩니다.