# 📘 세종 캐치 프론트엔드 개발 가이드 (Flutter)

세종대학교 학생용 올인원 정보 허브 **세종 캐치(Sejong Catch)** 의 프론트엔드 개발 가이드입니다.

---

## 🎯 프로젝트 개요

### 핵심 목표
- **정보 통합**: 공모전·취업·논문·학교공지를 한 곳에서
- **맞춤형 추천**: 학과/관심사 기반 스마트 필터링
- **신뢰성 보장**: 출처별 신뢰도 및 우선순위 시각화
- **대기열 관리**: 인기 정보의 스마트 줄서기 시스템

### 사용자 권한 시스템 (RBAC)
```
Guest (0)    → 공개 정보 열람, 인증 유도
Student (1)  → 맞춤 추천, 줄서기, 히스토리
Operator (2) → 수집 규칙, 제외어 관리
Admin (3)    → 통계 대시보드, 권한 로그
```

---

## 🚀 기술 스택 (실제 사용 패키지)

### 필수 패키지 (pubspec.yaml 기준)
```yaml
dependencies:
  # 상태 관리 (Freezed 미사용!)
  flutter_riverpod: ^2.6.1         # Riverpod 상태 관리
  riverpod_annotation: ^2.3.6      # @riverpod 어노테이션

  # 라우팅
  go_router: ^16.2.1               # 선언적 라우팅

  # 네트워킹
  dio: ^5.9.0                      # HTTP 클라이언트
  retrofit: ^4.7.2                 # REST API 인터페이스

  # 로컬 저장소
  shared_preferences: ^2.3.4       # 일반 설정 저장
  flutter_secure_storage: ^9.2.4   # 민감 데이터 저장

  # UI/UX
  flutter_screenutil: ^5.9.3       # 반응형 디자인 (필수!)
  cached_network_image: ^3.4.1     # 이미지 캐싱
  shimmer: ^3.0.0                  # 로딩 애니메이션
  smooth_page_indicator: ^1.2.1    # 페이지 인디케이터
  toggle_switch: ^2.3.0            # 토글 스위치

  # 리스트 & 스크롤
  infinite_scroll_pagination: ^5.1.1  # 무한 스크롤
  pull_to_refresh: ^2.0.0            # 당겨서 새로고침

  # 알림 (Firebase)
  firebase_core: ^4.1.0
  firebase_messaging: ^16.0.1
  flutter_local_notifications: ^19.4.2

  # 차트 (관리자용)
  syncfusion_flutter_charts: ^31.1.17

  # 국제화
  intl: ^0.20.2

dev_dependencies:
  build_runner: ^2.4.15          # 코드 생성
  riverpod_generator: ^2.4.3     # Provider 생성
  flutter_lints: ^5.0.0          # 린트 규칙
```

### ⚠️ 사용하지 않는 패키지
- ❌ **freezed** - 일반 Dart 클래스로 모델 작성
- ❌ **json_serializable** - 수동 JSON 파싱 또는 간단한 fromJson/toJson

---

## 🏗️ 프로젝트 구조

### 폴더 구조 (auth 성공 패턴 적용)
```
lib/
├── app/                          # 앱 전역 설정
│   ├── config/                   # 라우팅, 테마, 환경 설정
│   └── providers/                # 전역 Provider
├── core/                         # 공용 유틸리티
│   ├── widgets/                  # 재사용 가능한 공용 위젯
│   ├── theme/                    # 크림슨 레드 테마
│   ├── utils/                    # 헬퍼 함수, 확장
│   └── constants/                # 상수 정의
└── features/                     # 도메인별 기능 구현 (Clean Architecture)
    └── [feature_name]/           # auth, feed, search, queue 등
        ├── data/                 # 데이터 계층
        │   ├── models/           # API DTO (일반 Dart 클래스)
        │   ├── repositories/     # Repository 구현체 (Retrofit)
        │   └── datasources/      # API, Local 데이터 소스
        ├── domain/               # 비즈니스 로직
        │   ├── entities/         # 순수 비즈니스 엔티티
        │   └── repositories/     # Repository 인터페이스
        └── presentation/         # UI 계층 (Riverpod + 일반 클래스)
            ├── controllers/      # @riverpod Notifier
            ├── pages/            # ConsumerWidget 페이지
            └── widgets/          # Feature 전용 위젯
```

---

## 🧠 상태 관리 패턴 (Freezed 없이!)

### 상태 모델 (일반 Dart 클래스)
```dart
// Freezed 없이 불변 상태 구현
class SearchState {
  final String query;
  final bool isLoading;
  final List<SearchResult> results;
  final String? error;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.results = const [],
    this.error,
  });

  // copyWith 수동 구현
  SearchState copyWith({
    String? query,
    bool? isLoading,
    List<SearchResult>? results,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error,
    );
  }
}
```

### Riverpod Controller 패턴
```dart
@riverpod
class SearchController extends _$SearchController {
  @override
  SearchState build() => const SearchState();

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await ref.read(searchRepositoryProvider).search(query);
      state = state.copyWith(
        results: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }
}
```

---

## 🧭 라우팅 시스템 (GoRouter)

### 라우트 구조
```dart
final appRouter = GoRouter(
  routes: [
    // 메인 ShellRoute - BottomNav 유지
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(path: '/feed', builder: (_, __) => const FeedPage()),
        GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
        GoRoute(path: '/queue', builder: (_, __) => const QueuePage()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      ],
    ),

    // 독립 페이지들 - BottomNav 없음
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
    GoRoute(path: '/auth', builder: (_, __) => const AuthPage()),
    GoRoute(path: '/detail/:id', builder: (_, state) => DetailPage(id: state.params['id']!)),
  ],

  redirect: (context, state) {
    // 권한 가드 로직
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    final isFirstRun = ref.read(onboardingProvider).isFirstRun;

    if (isFirstRun) return '/onboarding';
    if (!isLoggedIn && state.location != '/auth') return '/auth';
    return null;
  },
);
```

### 🚫 라우팅 금지사항
- ❌ Navigator 직접 사용 금지
- ❌ 각 feature에서 BottomNavigationBar 중복 구현 금지
- ✅ 모든 네비게이션은 GoRouter 사용

---

## 🌐 백엔드 연동

### API 구조
- **Node.js API**: 사용자/피드/검색/대기열/프로필 CRUD
- **Python 서비스**: 세종대 SSO 인증 & 크롤링

### Retrofit API 인터페이스
```dart
@RestApi()
abstract class FeedApi {
  factory FeedApi(Dio dio, {String baseUrl}) = _FeedApi;

  @GET('/feeds')
  Future<List<FeedItem>> getFeeds(
    @Query('tab') String tab,
    @Query('page') int page,
  );

  @GET('/feeds/{id}')
  Future<FeedDetail> getDetail(@Path('id') String id);
}
```

### Dio 인터셉터 설정
```dart
Dio createDio() {
  final dio = Dio();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authProvider).accessToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        // 토큰 갱신 로직
        await ref.read(authProvider.notifier).refreshToken();
      }
      handler.next(error);
    },
  ));

  return dio;
}
```

---

## 🎨 디자인 시스템

### 크림슨 레드 컬러
```dart
class AppColors {
  static const brandCrimson = Color(0xFFDC143C);
  static const brandCrimsonDark = Color(0xFFB0102F);
  static const brandCrimsonLight = Color(0xFFF7E3E8);

  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);
}
```

### ScreenUtil 필수 사용
```dart
// ✅ 모든 크기는 반응형으로
width: 200.w          // 너비
height: 100.h         // 높이
padding: 16.w         // 패딩
fontSize: 14.sp       // 폰트 크기
borderRadius: 8.r     // 모서리
```

---

## 🛠️ 개발 명령어

### 코드 생성 (Riverpod)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 개발 중 자동 생성
```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 분석 & 테스트
```bash
flutter analyze
flutter test
```

---

## 📋 개발 체크리스트

### 새 기능 개발 시
- [ ] features/[기능명]/ Clean Architecture 폴더 구조 생성
  - [ ] data/ - models, repositories, datasources
  - [ ] domain/ - entities, repositories (interface)
  - [ ] presentation/ - controllers, pages, widgets
- [ ] 일반 Dart 클래스로 모델/엔티티 작성 (Freezed X)
- [ ] copyWith 메서드 수동 구현
- [ ] Repository 패턴 구현 (인터페이스 + 구현체)
- [ ] @riverpod Notifier로 상태 관리
- [ ] ConsumerWidget으로 페이지 구현
- [ ] ScreenUtil 모든 크기에 적용
- [ ] GoRouter 라우트 추가
- [ ] 코드 생성 실행 (build_runner)

### 코드 품질
- [ ] DRY 원칙 준수
- [ ] 단일 책임 원칙
- [ ] 에러 처리 완벽 구현
- [ ] 로딩/빈 상태 UI 구현

### 금지사항
- ❌ Freezed 사용
- ❌ Navigator 직접 사용
- ❌ TODO 주석 방치
- ❌ ScreenUtil 미사용
- ❌ 하드코딩된 크기값

---

## 🎯 최종 목표

**모든 페이지를 LoginPage처럼 클린하게 리팩토링하여 유지보수성과 개발 효율성을 극대화!**

이 가이드는 실제 사용되는 패키지만으로 작성된 실용적인 개발 가이드입니다.