📘 세종 캐치 프론트엔드 공동 개발 가이드 (Flutter)

세종대학교 학생용 올인원 정보 허브 세종 캐치(Sejong Catch) 의 프론트엔드 협업 표준입니다.
Clean Architecture + Riverpod + GoRouter + ScreenUtil + Dio/Retrofit을 고정 규격으로 사용합니다.
백엔드는 Node.js(메인 DB/REST), Python(세종대 SSO & 크롤링 마이크로서비스) 로 구성됩니다.

⸻

🔧 1. 프로젝트 개요
	•	앱명: 세종 캐치 (Sejong Catch)
	•	핵심 역할: 공모전·취업·논문·학교공지 통합, 신뢰도/우선순위 시각화, 스마트 줄서기, 개인화 추천
	•	권한 (RBAC): Guest < Student < Operator < Admin
	•	기술 스택 (FE)
	•	Flutter 3.x
	•	상태관리: flutter_riverpod + riverpod_annotation + riverpod_generator
	•	라우팅: go_router
	•	통신: dio + retrofit
	•	모델: freezed + json_serializable
	•	반응형: flutter_screenutil
	•	캐시/로딩: cached_network_image, shimmer, infinite_scroll_pagination
	•	저장소: flutter_secure_storage(민감), shared_preferences(일반)
	•	백엔드 (BE)
	•	Node.js REST API: 사용자/피드/검색/대기열/프로필/관리(주 DB 담당)
	•	Python 서비스: 세종대 SSO(자체 토큰 발급용 Auth Gateway) & 크롤링 수집기

⸻

📁 2. 폴더 구조 (로그인 86% 코드감소 패턴 전역 적용)

lib/
├── core/
│   ├── config/            # env, 상수, 빌드 채널
│   ├── theme/             # Crimson Design Tokens / ThemeData
│   ├── routing/           # GoRouter + Guards (auth/role/firstRun)
│   ├── utils/             # formatter, debounce, date, logger
│   └── widgets/           # 공용 위젯(AppCard, CTAButton, Shimmer 등)
│
├── data/
│   ├── models/            # Freezed 모델(+ *.g.dart)
│   ├── sources/
│   │   ├── remote/        # Dio/Retrofit API (node, python)
│   │   └── local/         # SharedPreferences, SecureStorage
│   └── repositories/      # Repository 조합 계층
│
├── domain/
│   ├── services/          # Priority/Trust/Dedup 등 도메인 로직
│   └── controllers/       # 전역 컨트롤러(Auth/Theme 등)
│
└── features/
    ├── auth/              # ✅ 성공 패턴 복사(controllers/models/pages/services/widgets)
    ├── feed/
    ├── search/
    ├── queue/
    ├── profile/
    ├── onboarding/
    └── console/

feature 트리(고정): controllers/, models/, pages/, services/, widgets/ui/
BottomNavigation은 오직 RootShell에서만 구현(각 페이지 재정의 금지)

⸻

🧭 3. 라우팅 & 가드 (GoRouter)

/onboarding          -> OnboardingFlowPage        [firstRunGuard]
/auth                -> LoginPage                 [authGuard(미인증만)]
/                    -> RootShell(IndexedStack)
/feed                -> FeedPage
/search              -> SearchPage
/queue               -> QueuePage                 [role>=Student]
/profile             -> ProfilePage
/detail/:id          -> DetailPage
/console             -> ConsoleShell              [role>=Operator]
/console/rules       -> RulesPage                 [role>=Operator]
/console/stats       -> StatsDashboardPage        [role>=Admin]
/settings            -> SettingsPage

	•	authGuard: 앱 토큰 보유 여부, 미보유 시 /auth로
	•	roleGuard: Guest(0)/Student(1)/Operator(2)/Admin(3)
	•	firstRunGuard: 온보딩 완료 플래그(shared_prefs)

⸻

🔌 4. 백엔드 연동 개요 (Node.js + Python)

4.1 서비스 경계
	•	Node.js API (주 DB)
	•	인증 토큰 검증(JWT), 사용자/피드/검색/대기열/프로필 CRUD
	•	관리자용 규칙/통계 API
	•	Python Auth/Crawler
	•	세종대 SSO 게이트웨이: 학번+포털 로그인 → sejong_token 발급
	•	크롤링/집계 파이프라인: 학교 공지/학내 게시물/언론/커뮤니티 수집 → Node DB로 적재

4.2 FE 인증 플로우
	1.	사용자가 세종대 포털 계정으로 Python Auth API에 로그인
	2.	성공 시 sejong_token(단기) 수신
	3.	FE가 **Node.js /auth/exchange**에 sejong_token을 전달 → 앱용 access_token/refresh_token 발급
	4.	이후 모든 Node API 호출은 Authorization: Bearer access_token 헤더로 접근
	5.	만료 시 401 → FE Interceptor가 /auth/refresh로 자동 갱신, 실패 시 로그아웃

주의: Python 토큰은 FE에 장기 저장 금지(교환 후 즉시 폐기)

⸻

🌐 5. API 인터페이스 (Retrofit 예시)

5.1 환경 변수 (.env)

NODE_API_BASE=https://api.sejongcatch.app
PY_AUTH_BASE=https://auth.sejongcatch.app

5.2 Dio 팩토리

Dio createDio(String baseUrl, {String? accessToken}) {
  final dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 10)));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (o, h) {
      if (accessToken?.isNotEmpty == true) o.headers['Authorization'] = 'Bearer $accessToken';
      return h.next(o);
    },
    onError: (e, h) {
      // 401 → refresh 플로우 트리거
      return h.next(e);
    },
  ));
  return dio;
}

5.3 Python Auth API

@RestApi()
abstract class PyAuthApi {
  factory PyAuthApi(Dio dio, {String baseUrl}) = _PyAuthApi;

  // 세종대 포털 로그인 → sejong_token 발급
  @POST('/sju/login')
  Future<SejongTokenDto> login(@Body() SejongLoginReq body);
}

5.4 Node Auth API

@RestApi()
abstract class NodeAuthApi {
  factory NodeAuthApi(Dio dio, {String baseUrl}) = _NodeAuthApi;

  // sejong_token → 앱용 access/refresh 교환
  @POST('/auth/exchange')
  Future<AppTokenDto> exchange(@Body() ExchangeReq body);

  @POST('/auth/refresh')
  Future<AppTokenDto> refresh(@Body() RefreshReq body);
}

5.5 피드/검색/대기열(일부)

@RestApi()
abstract class FeedApi {
  factory FeedApi(Dio dio, {String baseUrl}) = _FeedApi;

  @GET('/feeds')
  Future<List<FeedItemDto>> getFeeds(
    @Query('tab') String tab,        // recommended | deadline | latest
    @Query('page') int page,
  );

  @GET('/feeds/{id}')
  Future<FeedDetailDto> getDetail(@Path('id') String id);
}

@RestApi()
abstract class SearchApi {
  factory SearchApi(Dio dio, {String baseUrl}) = _SearchApi;

  @GET('/search')
  Future<SearchResultDto> search(@Query('q') String q, @Query('filters') String filtersJson);
}

@RestApi()
abstract class QueueApi {
  factory QueueApi(Dio dio, {String baseUrl}) = _QueueApi;

  @POST('/queue/join')
  Future<QueueTicketDto> join(@Body() QueueJoinReq body);

  @GET('/queue/me')
  Future<List<QueueItemDto>> myQueues();

  @DELETE('/queue/{ticketId}')
  Future<void> cancel(@Path('ticketId') String id);
}


⸻

🧩 6. 계층별 역할
	•	Model (data/models): Freezed + Json (DTO ↔ Domain 변환)
	•	API (data/sources/remote): Node/Python Retrofit 인터페이스
	•	Repository (data/repositories): API 조합 + 로컬 캐시(필요 시), UI에서 유일한 호출점
	•	Services (domain/services & features/*/services): Priority/Trust/Dedup/정렬 등 도메인 로직
	•	Controllers (features/*/controllers): Riverpod Notifier (상태/액션)
	•	Pages (features/*/pages): 레이아웃/바인딩만, 비즈니스 로직 금지
	•	Widgets (features/*/widgets/ui): 재사용 UI 컴포넌트

⸻

🧠 7. 상태관리 (Riverpod) 규칙
	•	@riverpod + Notifier 고정, 상태는 불변 모델(Freezed or Immutable Class)
	•	UI: ref.watch, 액션/사이드이펙트: ref.read
	•	상태에는 반드시 isLoading, error, empty 고려
	•	Interceptor에서 401 처리 → refresh → 재시도 표준화

간단 예:

@freezed
class QueueState with _$QueueState {
  const factory QueueState({
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<QueueItem> items,
  }) = _QueueState;
}

@riverpod
class QueueController extends _$QueueController {
  late final QueueRepository _repo;
  @override
  QueueState build() {
    _repo = ref.read(queueRepositoryProvider);
    return const QueueState();
  }
  Future<void> load() async { /* ... */ }
  Future<void> join(QueueJoinReq req) async { /* ... */ }
  Future<void> cancel(String ticketId) async { /* ... */ }
}


⸻

🎨 8. 디자인 시스템 (Crimson)
	•	ScreenUtil 100%: .w/.h/.sp/.r 필수
	•	토큰: AppColors.brandCrimson/brandCrimsonDark/Light, success/warning/error
	•	공용 위젯: /core/widgets/(AppCard, PriorityBar, TrustBadge, ShimmerList, EmptyView, ErrorView, FilterChips…)
	•	상태 규칙
	•	버튼: 기본 Crimson → Pressed(Dark) → Disabled(Gray)
	•	칩: 선택 시 Light 배경 + Crimson 텍스트
	•	카드: 만료 60% 투명, 읽음 Secondary 톤
	•	A11y: 대비 ≥ 4.5:1, 터치 ≥ 44dp, Semantics 라벨

⸻

🔐 9. 보안 & 성능
	•	민감: SecureStorage(토큰/계정), 일반: SharedPreferences(테마/온보딩/언어)
	•	입력 검증: FE/BE 이중 검증, 디바운스(검색)
	•	토큰 만료: 401 → refresh → 실패 시 로그아웃
	•	리스트 성능: PagedListView/ListView.builder + AutomaticKeepAliveClientMixin
	•	리빌드 최소화: const, ref.select/Selector

⸻

🧪 10. 품질·협업 규칙

항목	규칙
커밋	Conventional Commits(feat:, fix:, refactor:, chore:, docs:…)
네이밍	변수 camelCase / 클래스 PascalCase / 파일 snake_case.dart
리뷰	PR 1인 이상 승인, dart analyze 통과
금지	View에서 API 직접 호출, 페이지별 BottomNav 재구현, TODO 방치
코드생성	dart run build_runner build --delete-conflicting-outputs
번들체크	flutter analyze, flutter test(있다면)


⸻

🚀 11. 실행·배포 명령어

# 의존성
flutter pub get

# 코드 생성(Freezed/Riverpod/Retrofit/Json)
dart run build_runner build --delete-conflicting-outputs

# 런
flutter run -d <device>

# 릴리즈 빌드
flutter build apk
flutter build ios


⸻

🧰 12. 새 기능 스캐폴딩(선택)

tool/new_feature.sh 스크립트로 표준 트리 자동 생성:
	•	생성 경로: features/<name>/{controllers,models,pages,services,widgets/ui}
	•	기본 Controller/Service/Page/ItemCard 샘플 포함

실행:

chmod +x tool/new_feature.sh
./tool/new_feature.sh feed


⸻

🔗 13. 레퍼런스(채워넣기)
	•	Node API 명세(Swagger/Redoc): (URL)
	•	Python Auth/Crawler 문서: (URL)
	•	디자인(Figma): (URL)
	•	GitHub: (FE/BE 레포 URL)
	•	운영 위키(Notion/Confluence): (URL)

⸻

✅ 최종 메모
	•	Node.js = 주 DB/REST, Python = 세종대 로그인 & 크롤링으로 FE 연동 분리 완료
	•	auth 교환 플로우(sejong_token → app access/refresh)와 401 자동 갱신을 FE Interceptor 표준에 반영
	•	로그인 리팩토링에서 검증된 폴더/상태/라우팅/디자인 패턴을 모든 feature에 강제 적용
