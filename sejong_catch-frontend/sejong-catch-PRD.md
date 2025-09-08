**Flutter 프론트엔드 전체 구조 + 디자인 시스템(크림슨 레드 기반)**
(아키텍처 → 라우팅/권한 → 화면/컴포넌트 → 온보딩 → 디자인 토큰/테마 → 접근성/모션 → 품질/테스트 순으로 구성)

⸻

# 세종 크롤링 & 세종 캐치 – Flutter 프론트엔드 최종 설계

0) 핵심 목표 요약
	•	정보 허브화: 공모전·취업·논문·공지 등 분산 정보를 통합·정돈된 리스트로 제공
	•	맞춤형 최적화: 학과/관심사/키워드(+제외어) 기반의 추천 & 알림
	•	신뢰·우선순위 신호: 출처/공식성/마감 임박/중복 통합을 시각적으로 명확히

⸻

1) 앱 아키텍처 & 폴더 구조

권장 기술 스택
	•	상태관리: Riverpod(or Provider)
	•	라우팅: GoRouter (권한 기반 가드)
	•	네트워킹: dio (+ retrofit 선택)
	•	직렬화: json_serializable + freezed (불변 모델)
	•	스토리지: flutter_secure_storage(토큰), hive/sqflite(캐시)
	•	알림: firebase_messaging
	•	분석/크래시: firebase_analytics, firebase_crashlytics(or sentry)

폴더 구조 (예시)

lib/
  core/
    config/        # 상수, 환경, flavor
    theme/         # ColorScheme, TextTheme, ThemeData
    routing/       # GoRouter, route guard (RBAC)
    utils/         # 공통 유틸, validators
    widgets/       # 공용 위젯(CTAButton, AppCard, Empty/Error/Skeleton 등)
  data/
    models/        # freezed 모델 (Item, Source, User, Role, Filter 등)
    sources/       # remote(dio/retrofit), local(hive/sqflite)
    repository/    # 도메인별 Repo (items, auth, notify, stats)
  domain/
    services/      # 비즈 로직(우선순위 계산, 중복 병합, 신뢰도 산정)
  features/
    onboarding/    # 온보딩(페이지, 상태, 저장)
    auth/          # 로그인/학생인증/게스트
    feed/          # 홈 피드(추천/임박/최신 탭)
    search/        # 검색/필터/저장필터
    detail/        # 상세(출처/마감/신뢰 뱃지/외부링크)
    bookmarks/     # 북마크
    notifications/ # 알림함, 설정
    profile/       # 내 정보/관심사/권한 표시
    console/       # 운영/관리 콘솔(규칙, 제외어, 통계)


⸻

2) 라우팅 & 권한(RBAC)

역할
	•	Guest: 공개 정보 열람(일부 상세 마스킹), 인증 유도 배너
	•	Student: 맞춤 추천/알림/북마크/히스토리
	•	Operator: 수집 규칙·제외어·중복 규칙 UI 접근
	•	Admin: 통계/정책/권한 변경 로그

GoRouter 가드 로직(개념)
	•	authGuard: 로그인/학생 인증 여부 확인 → 미충족 시 온보딩/로그인으로 유도
	•	roleGuard(requiredRole): 라우트 접근 시 Role 체크 → 미충족 시 안내

⸻

3) 화면 구성(IA) & 핵심 UX

하단 탭(5개)
	1.	홈: 추천 / 마감임박 / 최신(탭) + 카드 리스트 + 무한 스크롤
	2.	검색: 검색바 + 저장필터칩 + 고급 필터 바텀시트(공식/중복제거/기간/학과/제외어)
	3.	북마크: 저장 항목 + 마감 임박 우선 정렬
	4.	알림: 카테고리 탭 + 알림 카드(스와이프: 읽음/삭제) + 알림 설정 진입
	5.	내 정보: 권한/인증 상태, 학과·관심사, 알림/언어/테마, 온보딩 다시보기

상세 화면(공통 요소)
	•	제목(2줄), 출처 로고/도메인, 신뢰 뱃지, 등록일, 마감 D-n, 본문 요약, 외부 링크, 액션(북마크/공유)
	•	중복 통합 표시: “유사 n건 통합” 칩 → 펼치면 출처별 라인업

운영/관리 콘솔(앱 내 진입)
	•	운영자: 키워드/제외어/중복 규칙 관리, 수집 로그
	•	관리자: KPI 카드(수집·중복제거율·공식비율·CTR), 차트(일별/카테고리별/키워드), 권한 변경 로그

⸻

4) 온보딩 플로우(5화면)
	1.	Intro – “세종인을 위한 단 하나의 정보 허브”
	2.	수집·필터링 – “자동 수집 & 중복 제거, 신뢰·중요도 반영”
	3.	권한 안내 – 학생/게스트/운영자/관리자 각각의 혜택
	4.	개인화 – 학과 드롭다운 + 관심사 칩(저장 필터 시드)
	5.	알림 권한 요청 – “마감 임박, 맞춤 알림으로 기회 놓치지 마세요”

패턴: PageView + dot indicator, 상단 Skip, 최초 실행 시에만 노출(shared_preferences)

⸻

5) 디자인 시스템(크림슨 레드 & 화이트)

5.1 컬러 토큰(제안)
	•	Brand Crimson: #DC143C (Crimson)
	•	Brand Crimson Dark: #B0102F (다크 모드/프레스 상태)
	•	Brand Crimson Light: #F7E3E8 (크림슨의 very light tint, 강조 배경)
	•	White: #FFFFFF
	•	Surface: #F7F7F8 (라이트), #121212 (다크)
	•	Text Primary: #111111 (라이트), #EDEDED (다크)
	•	Text Secondary: #6B7280 (Gray-500)
	•	Success #16A34A, Warning #F59E0B, Error #DC2626
	•	Divider: #E5E7EB (라이트), #2A2A2A (다크)

포인트: CTA/Active/우선순위/Badge에 크림슨을 일관 사용. 과포화 방지 위해 배경은 화이트·서페이스 계열로 정돈.

5.2 타이포그래피(Material 3 권장)
	•	Title Large: 20–24 sp / Bold (섹션 타이틀, 온보딩 타이틀)
	•	Title Medium: 18 sp / Semi-Bold (카드 타이틀)
	•	Body Medium: 14–16 sp / Regular (본문/메타)
	•	Label Large: 14 sp / Medium (버튼/칩/배지)

5.3 레이아웃/스페이싱
	•	4pt Grid: 4/8/12/16/20/24/32
	•	Radius: 8dp(카드), 12dp(모달/시트), 999dp(FAB/칩)
	•	Elevation: 카드 1–2, 고정 헤더/탭바 2–3

5.4 컴포넌트 상태 규칙
	•	버튼: 기본=Crimson / Pressed=Crimson Dark / Disabled=Gray
	•	칩: 선택=Crimson Light 배경 + Crimson 텍스트, 선택해제=Surface
	•	카드: 읽음 처리 시 텍스트 Secondary, 만료는 라벨 “Expired” + 60% 불투명

⸻

6) 신뢰·우선순위 시각화
	•	신뢰 뱃지
	•	Official(공식): 실드(Shield) 아이콘 + Crimson Outline
	•	Academic(논문/학내): 캡 모티프 + Neutral Outline
	•	Press(언론): 미니 기사 아이콘 + Gray Outline
	•	우선순위 바/칩
	•	카드 상단 2–3px Bar(High=Crimson, Mid=Crimson Light, Low=Surface)
	•	혹은 HOT, TREND, Recommended 칩(크림슨/라이트 보색)

⸻

7) 리스트/검색/필터 UX 디테일
	•	리스트 그룹: 추천 / 마감임박 / 최신
	•	메타 정렬: 좌측(카테고리/출처/마감), 우측(북마크/공유/더보기)
	•	검색바 고정 + 저장필터칩 (내 필터 1,2…)
	•	고급 필터 바텀시트:
	•	토글: 공식만, 중복 제거
	•	라디오: 정렬(추천/최신/마감/신뢰)
	•	범위: 등록일/마감일, 학과/키워드/제외어
	•	빈/로딩/에러: Skeleton(3–5개) / 친절한 메시지 + “필터 초기화” / 오프라인 캐시

⸻

8) Flutter 테마 매핑(예시 코드 스니펫)

// core/theme/app_theme.dart
import 'package:flutter/material.dart';

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
      error: const Color(0xFFDC2626),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        elevation: 2,
        backgroundColor: scheme.surface,
        foregroundColor: Colors.black87,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 15, height: 1.35),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      chipTheme: ChipThemeData(
        selectedColor: _crimsonLight,
        disabledColor: const Color(0xFFE5E7EB),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
      listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.all(12)),
      dividerColor: const Color(0xFFE5E7EB),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: scheme.primary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _crimson,
      brightness: Brightness.dark,
      primary: _crimson,
      secondary: _crimson,
      background: const Color(0xFF121212),
      surface: const Color(0xFF121212),
      error: const Color(0xFFEF4444),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 15, height: 1.35),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

포인트: ColorScheme.fromSeed + 크림슨 시드로 톤 일관성 확보. 컴포넌트별 라운드/여백/텍스트 굵기 통일.

⸻

9) 공용 컴포넌트 스펙(발췌)
	•	AppCard (정보 카드)
	•	상단: 출처 로고/도메인 + 신뢰 뱃지
	•	본문: 제목(2줄) + 카테고리/등록일/마감 D-n
	•	하단: 북마크/공유/더보기
	•	상태: default / pressed / read / bookmarked / expired
	•	PriorityBar (2–3px): 카드 상단 얇은 바(High=Crimson, Mid=Crimson Light)
	•	TrustBadge (Outlined): Official / Academic / Press / Community
	•	FilterChips: 선택 시 Crimson Light 배경 + Crimson 라벨
	•	Empty/Skeleton/Error: 일관된 아이콘/문구/버튼

⸻

10) 온보딩 와이어 구조(요약)
	•	공통: SafeArea + PageView(5), 상단 Skip, 하단 dot, Primary CTA
	•	(1) Intro: 타이틀/부제 + 통합 가치, 일러스트
	•	(2) 수집·필터링: 자동/중복제거/신뢰
	•	(3) 권한: 학생/게스트/운영/관리
	•	(4) 개인화: 학과 드롭다운 + 관심사 칩
	•	(5) 알림 권한: “기회 놓치지 마세요” + 허용 CTA

⸻

11) 접근성/모션/국제화
	•	대비: 텍스트 4.5:1 이상(크림슨·화이트 대비 충분)
	•	터치 타겟: 44×44dp 이상, 아이콘 버튼 최소 40dp
	•	모션: 탭 전환 200ms, 시트/FAB 220ms, Skeleton→콘텐츠 140ms 페이드
	•	다크 모드: 배경 딥그레이, 크림슨 채도 약간 낮춤, 눈부심 방지
	•	i18n: 한·영 혼용 시 줄바꿈/말줄임 테스트(2줄 ellipsis)

⸻

12) 품질 보증 & 테스트
	•	Golden Test: 핵심 화면(카드/리스트/필터/온보딩) 스냅샷 비교
	•	Widget/Integration Test: 권한 가드, 검색→결과, 북마크/알림 액션
	•	Lint: flutter_lints or very_good_analysis
	•	성능: 이미지 캐싱(cached_network_image), Pagination/Infinite scroll, 메모이제이션

⸻

13) 마이크로카피(샘플)
	•	인증 유도(게스트): “학생 인증이 필요한 정보입니다. 1분 만에 완료해요.”
	•	중복 통합: “유사 공지를 묶어 깔끔하게 정리했어요.”
	•	마감 임박: “D-2 · 오늘 시작해도 충분해요!”
	•	저장 성공: “북마크에 담았어요. 마감 전에 알림을 드릴게요.”

⸻

마무리 한 줄

크림슨 레드 × 화이트를 기반으로, “정돈된 리스트 경험 + 신뢰/우선순위 신호 + 역할별 가시성”을 일관된 토큰과 컴포넌트로 구현하면, 정보 탐색 피로를 크게 낮추고 기회 포착률을 극대화할 수 있습니다.