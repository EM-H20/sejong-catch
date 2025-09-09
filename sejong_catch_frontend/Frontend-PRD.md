📘 세종 크롤링 & 세종 캐치 – Flutter 프론트엔드 최종 설계 (수정본)

0) 핵심 목표 요약
	•	정보 허브화: 공모전·취업·논문·공지 등 분산 정보를 통합·정돈된 리스트로 제공
	•	맞춤형 최적화: 학과/관심사/키워드(+제외어) 기반의 추천
	•	신뢰·우선순위 신호: 출처/공식성/마감 임박/중복 통합을 시각적으로 명확히

⸻

1) 앱 아키텍처 & 폴더 구조

권장 기술 스택
	•	상태관리: Provider
	•	라우팅: GoRouter (권한 기반 가드)
	•	네트워킹: dio + retrofit
	•	직렬화: json_serializable + freezed
	•	스토리지: flutter_secure_storage (민감 데이터 저장)
	•	UI/UX 개선: flutter_screenutil, cached_network_image, shimmer, smooth_page_indicator
	•	리스트 관리: infinite_scroll_pagination, pull_to_refresh

⚠️ 알림(firebase_messaging, awesome_notifications), 실시간(web_socket_channel), 분석(firebase_analytics, crashlytics) 제외

폴더 구조 (예시)

lib/
  core/
    config/        # 상수, 환경
    theme/         # ColorScheme, TextTheme, ThemeData
    routing/       # GoRouter, route guard (RBAC)
    utils/         # 공통 유틸
    widgets/       # 공용 위젯(CTAButton, AppCard, Empty/Error/Skeleton)
  data/
    models/        # freezed 모델
    sources/       # remote(dio/retrofit)
    repository/    # 도메인별 Repo
  domain/
    services/      # 비즈 로직(우선순위, 중복 병합, 신뢰도 산정)
  features/
    onboarding/    # 온보딩
    auth/          # 로그인/인증
    feed/          # 홈 피드
    search/        # 검색/필터
    detail/        # 상세
    bookmarks/     # 북마크
    profile/       # 내 정보/관심사/권한 표시
    console/       # 운영/관리 콘솔


⸻

2) 라우팅 & 권한(RBAC)

역할
	•	Guest: 공개 정보 열람(일부 제한), 인증 유도
	•	Student: 맞춤 추천, 북마크, 히스토리
	•	Operator: 수집 규칙/제외어/중복 규칙 관리
	•	Admin: 통계·정책 관리, 권한 변경 로그

GoRouter 가드
	•	authGuard: 로그인/학생 인증 여부 확인
	•	roleGuard: Role 기반 접근 제어

⸻

3) 화면 구성(IA) & 핵심 UX
	•	하단 탭 (5개)
	1.	홈 – 추천/마감임박/최신 탭 + 무한 스크롤
	2.	검색 – 검색바 + 저장필터칩 + 고급 필터 바텀시트
	3.	북마크 – 저장 항목 + 마감 임박 정렬
	4.	알림 – (향후 필요 시 구현)
	5.	내 정보 – 권한, 학과·관심사, 설정
	•	상세 화면
	•	제목, 출처 로고, 신뢰 뱃지, 마감 D-n, 요약, 외부 링크, 액션 버튼
	•	중복 통합 칩 → 출처별 리스트 펼치기
	•	운영/관리 콘솔
	•	운영자: 키워드/제외어/중복 규칙 관리
	•	관리자: KPI 카드, 차트, 권한 변경 로그

⸻

4) 온보딩 플로우 (5화면)
	1.	Intro – “세종인을 위한 단 하나의 정보 허브”
	2.	수집·필터링 – “자동 수집 & 중복 제거, 신뢰도 반영”
	3.	권한 안내 – 학생/게스트/운영자/관리자
	4.	개인화 – 학과 선택, 관심사 칩
	5.	(향후) 알림 권한 요청 – 현재는 제외 가능

패턴: PageView + dot indicator, 상단 Skip, 최초 실행 시에만 노출(shared_preferences)

⸻

5) 디자인 시스템 (크림슨 레드 & 화이트)

5.1 컬러 토큰
	•	Brand Crimson: #DC143C
	•	Brand Crimson Dark: #B0102F
	•	Brand Crimson Light: #F7E3E8
	•	White: #FFFFFF
	•	Surface: #F7F7F8 (라이트), #121212 (다크)
	•	Text Primary: #111111 / #EDEDED
	•	Text Secondary: #6B7280
	•	Success: #16A34A, Warning: #F59E0B, Error: #DC2626
	•	Divider: #E5E7EB / #2A2A2A

5.2 타이포그래피
	•	Title Large: 20–24sp / Bold
	•	Title Medium: 18sp / Semi-Bold
	•	Body Medium: 14–16sp / Regular
	•	Label Large: 14sp / Medium

5.3 레이아웃
	•	4pt Grid, Radius 8–12dp, Elevation 1–3

5.4 컴포넌트 상태
	•	버튼: Crimson → Pressed Crimson Dark → Disabled Gray
	•	칩: 선택 시 Crimson Light 배경 + Crimson 텍스트
	•	카드: 읽음 시 Secondary 텍스트, 만료 시 60% 불투명

⸻

6) 신뢰·우선순위 시각화
	•	신뢰 뱃지
	•	Official: Shield + Crimson Outline
	•	Academic: 학술 아이콘 + Neutral Outline
	•	Press: 기사 아이콘 + Gray Outline
	•	우선순위 표시
	•	카드 상단 2–3px 바 (High=Crimson, Mid=Crimson Light)
	•	HOT, TREND, Recommended 칩

⸻

7) 리스트/검색/필터 UX
	•	리스트 그룹: 추천 / 마감임박 / 최신
	•	검색: 검색바 고정, 저장필터칩 제공
	•	고급 필터 시트: 공식만/중복 제거, 정렬 옵션, 기간·학과·키워드/제외어
	•	빈/로딩/에러: Skeleton(3–5개), 친절한 메시지, 필터 초기화 버튼

⸻

8) Flutter 테마 매핑 (핵심 코드)

class AppTheme {
  static const _crimson = Color(0xFFDC143C);
  static const _crimsonDark = Color(0xFFB0102F);
  static const _crimsonLight = Color(0xFFF7E3E8);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _crimson,
      primary: _crimson,
      secondary: _crimson,
      background: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF7F7F8),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: const AppBarTheme(
        elevation: 2,
        backgroundColor: Color(0xFFF7F7F8),
        foregroundColor: Colors.black87,
      ),
    );
  }
}


⸻

9) 공용 컴포넌트
	•	AppCard: 출처 로고, 신뢰 뱃지, 제목, 카테고리/마감일, 액션 버튼
	•	PriorityBar: 카드 상단 강조 바
	•	TrustBadge: Official/Academic/Press/Community
	•	FilterChips: 선택 시 Crimson Light + Crimson 라벨
	•	Empty/Skeleton/Error: 통일된 아이콘/문구/버튼

⸻

10) 온보딩 와이어 구조
	•	SafeArea + PageView(5), 상단 Skip, 하단 dot, Primary CTA
	•	Intro / 수집·필터링 / 권한 안내 / 개인화 / (선택적 알림)

⸻

11) 접근성·모션·국제화
	•	대비: 텍스트 4.5:1 이상 유지
	•	터치 타겟: 최소 44×44dp
	•	모션: 탭 전환 200ms, 페이드 인/아웃 140ms
	•	다크 모드: 채도 낮춘 Crimson 적용
	•	다국어: 줄바꿈/ellipsis 테스트

⸻

12) 품질 보증 & 테스트
	•	Lint: flutter_lints or very_good_analysis
	•	Golden Test(옵션): 주요 화면 스냅샷 비교
	•	성능: 캐싱(cached_network_image), Pagination 최적화

⸻

13) 마이크로카피 예시
	•	인증 유도(게스트): “학생 인증이 필요한 정보입니다. 1분 만에 완료해요.”
	•	중복 통합: “유사 공지를 묶어 깔끔하게 정리했어요.”
	•	마감 임박: “D-2 · 오늘 시작해도 충분해요!”
	•	저장 성공: “북마크에 담았어요. 마감 전에 확인해드릴게요.”

⸻

현재 알림·실시간·분석/안정성 모듈 제외된 상태 - 패키지 에러.

⸻