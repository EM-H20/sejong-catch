
(GoRouter 라우트 구조 → 공통 레이아웃 → 각 기능 화면 순서. *는 재사용 컴포넌트, #는 상태/서비스 의존)

⸻

0) 라우팅(GoRouter) 개요

GoRouter
└─ routes
   ├─ /onboarding        -> OnboardingFlowPage   [guard: firstRunGuard]
   ├─ /auth               -> AuthPage
   ├─ /                   -> RootShell (BottomNav)
   │   ├─ /home          -> HomeFeedPage
   │   ├─ /search        -> SearchPage
   │   ├─ /bookmarks     -> BookmarksPage        [guard: role>=Student]
   │   ├─ /notifications -> NotificationsPage    [guard: role>=Student]
   │   └─ /profile       -> ProfilePage
   ├─ /detail/:id         -> DetailPage
   ├─ /console            -> ConsoleShell        [guard: role>=Operator]
   │   ├─ /console/rules -> RulesPage            [guard: role>=Operator]
   │   └─ /console/stats -> StatsDashboardPage   [guard: role>=Admin]
   └─ /settings           -> SettingsPage

가드 의존성
	•	authGuard(로그인/학생인증), roleGuard(requiredRole), firstRunGuard(shared_preferences)
	•	#AuthState, #RoleService, #OnboardingState

⸻

1) 루트 & 공통 레이아웃

App (MaterialApp.router with AppTheme)
└─ ProviderScope / RiverpodScope
   └─ Router (GoRouter)
      └─ RootShell (Scaffold)
         ├─ body: IndexedStack
         │  ├─ HomeFeedPage
         │  ├─ SearchPage
         │  ├─ BookmarksPage
         │  ├─ NotificationsPage
         │  └─ ProfilePage
         └─ bottomNavigationBar: *AppBottomNav

공용 위젯

*AppBottomNav (BottomNavigationBar)
*AppCard (정보 카드: 신뢰뱃지/우선순위바 포함)
*PriorityBar (2~3px)
*TrustBadge (Outlined)
*FilterChipGroup
*EmptyView / *ErrorView / *SkeletonList
*CTAButton (Crimson 테마)


⸻

2) 온보딩 플로우 (5화면)

OnboardingFlowPage
└─ Scaffold
   ├─ AppBar(actions: [TextButton("건너뛰기")])
   └─ Column
      ├─ Expanded(
      │   child: PageView(controller)
      │     ├─ _IntroPage(illustration, title, subtitle)
      │     ├─ _CollectFilterPage(...)
      │     ├─ _RolesPage(...)
      │     ├─ _PersonalizePage(DeptDropdown, InterestChips)
      │     └─ _NotificationConsentPage(AllowButton)
      ├─ *SmoothPageIndicator
      └─ Padding(
          child: *CTAButton(next/완료)
         )

상태/저장: #OnboardingState, shared_preferences(완료 플래그), #ProfilePref(학과/관심사), FCM 권한

⸻

3) 홈 피드(추천/마감임박/최신)

HomeFeedPage
└─ Scaffold
   ├─ appBar: *SearchAppBar (readonly, 탭 이동/검색 진입)
   └─ Column
      ├─ *SegmentedTabs(Recommended | Deadline | Latest)
      └─ Expanded
         └─ TabBarView
            ├─ _RecommendedList
            │   └─ *PagedListView<Item>
            │      ├─ itemBuilder: *AppCard(Item)
            │      ├─ firstPageProgress: *SkeletonList
            │      └─ emptyBuilder: *EmptyView("추천 항목 없음")
            ├─ _DeadlineList (동일)
            └─ _LatestList (동일)

의존성: #FeedController (pagination, caching), #PriorityService, #TrustService, #BookmarkService

⸻

4) 검색 & 필터

SearchPage
└─ Scaffold
   ├─ appBar: *SearchBar(
   │    onSubmitted -> controller.search(query)
   │    actions: [IconButton(Filter)]
   │  )
   └─ Column
      ├─ *SavedFilterChips (horizontal, scroll)
      ├─ *RecentPopularKeywords
      ├─ Divider
      └─ Expanded
         └─ *PagedListView<Item> (결과)
             ├─ itemBuilder: *AppCard
             └─ empty/error/skeleton 핸들

FilterBottomSheet (showModalBottomSheet)
└─ ListView
   ├─ Section("기본")
   │  ├─ SwitchTile("공식 출처만")
   │  ├─ SwitchTile("중복 제거")
   │  └─ RadioGroup("정렬", [추천/최신/마감/신뢰])
   ├─ Section("범위")
   │  ├─ DateRangePicker("등록일")
   │  ├─ DateRangePicker("마감일")
   │  └─ DeptDropdown
   ├─ Section("키워드")
   │  ├─ TextField("포함 키워드")
   │  └─ TextField("제외어")
   └─ *CTAButton("필터 적용")

의존성: #SearchController, #FilterState, #SavedFilterRepo, #DedupService

⸻

5) 상세 화면

DetailPage(itemId)
└─ Scaffold
   ├─ appBar: AppBar(Back, Share, Bookmark)
   └─ CustomScrollView
      ├─ SliverToBoxAdapter: Padding
      │  ├─ Row
      │  │  ├─ *SourceAvatarLogo
      │  │  ├─ Column
      │  │  │  ├─ Text(item.sourceDomain)
      │  │  │  └─ Row( *TrustBadge, *PriorityChip? )
      │  ├─ SizedBox(h8)
      │  ├─ Text(item.title, style: TitleMedium, maxLines:2)
      │  ├─ Row( Icon(calendar), Text("등록 · 마감 D-n") )
      │  ├─ Divider
      │  ├─ *RichContent(item.summary/description)
      │  ├─ *LinkButton("출처 열기")
      │  └─ if (item.duplicates>0) *DuplicateFoldableList(items)
      └─ SliverFillRemaining(hasScrollBody:false)
         └─ Padding(child: *CTAButton("북마크" / "지원하기"))

의존성: #ItemRepo.getById, #BookmarkService, #ShareService, #DedupService

⸻

6) 북마크

BookmarksPage
└─ Scaffold
   ├─ appBar: AppBar(title: "북마크")
   └─ *PagedListView<Item>
      ├─ sort: DeadlineFirst
      ├─ itemBuilder: *AppCard
      └─ swipeActions: Remove / Share

의존성: #BookmarkService (local+remote sync), #FeedCache

⸻

7) 알림(함) & 설정

NotificationsPage
└─ Scaffold
   ├─ appBar: AppBar(actions: [IconButton(Setting)])
   └─ Column
      ├─ *CategoryTabs(All | 공모전 | 취업 | 논문)
      └─ Expanded
         └─ ListView.separated
            ├─ *NotificationCard(
            │    title, snippet, timeAgo,
            │    actions: [Bookmark, OpenDetail]
            │  )
            └─ Divider

NotificationSettingsPage
└─ ListView
   ├─ SwitchTile("마감 임박 즉시 알림")
   ├─ SwitchTile("일일 요약")
   ├─ ChipGroup("구독 키워드", add/remove)
   └─ SwitchTile("학과 공지 우선")

의존성: #NotificationRepo (FCM topic/subscription), #Prefs

⸻

8) 프로필(내 정보)

ProfilePage
└─ Scaffold
   ├─ appBar: AppBar(title: "내 정보")
   └─ ListView
      ├─ *UserHeader(name, roleBadge, dept)
      ├─ Section("계정/권한")
      │  ├─ ListTile("역할", trailing: RoleBadge)
      │  └─ ListTile("학생 인증", trailing: StatusSwitch/CTA)
      ├─ Section("개인화")
      │  ├─ DeptDropdown
      │  ├─ InterestChips(editable)
      │  └─ SavedFiltersManager
      ├─ Section("환경")
      │  ├─ SwitchTile("다크 모드 따라가기")
      │  ├─ ListTile("언어", trailing: Picker)
      │  └─ ListTile("온보딩 다시 보기", trailing: CTA)
      └─ Section("기타") …

의존성: #AuthState, #ProfilePref, #ThemeController, #I18n

⸻

9) 운영/관리 콘솔

ConsoleShell (role>=Operator)
└─ Scaffold
   ├─ appBar: AppBar(title:"콘솔", actions:[IconButton(Stats)])
   └─ ListView
      ├─ *ConsoleCard("수집 규칙", trailing: CTA -> RulesPage)
      ├─ *ConsoleCard("제외어 관리", trailing: CTA)
      ├─ *ConsoleCard("중복 규칙", trailing: CTA)
      └─ if (role==Admin) *ConsoleCard("통계/대시보드", trailing: CTA -> StatsDashboardPage)

RulesPage
└─ Scaffold
   └─ ListView
      ├─ *RuleEditorList (Add/Edit/Delete)
      └─ *CTAButton("저장")

StatsDashboardPage (role>=Admin)
└─ CustomScrollView
   ├─ SliverToBoxAdapter: *KpiCardsRow
   ├─ SliverToBoxAdapter: *LineChart("일별 등록/노출/클릭")
   ├─ SliverToBoxAdapter: *BarChart("카테고리별 조회 Top5")
   └─ SliverToBoxAdapter: *Heatmap("요일/시간대 클릭")

의존성: #RulesRepo, #StatsRepo, charts_flutter or syncfusion_flutter_charts

⸻

10) 공용 위젯 상세(발췌)

*AppCard(Item)
└─ Container(decoration: card + radius 8)
   └─ Column(spacing: 8~12)
      ├─ Row(align: spaceBetween)
      │  ├─ Row( *SourceLogo, Text(domain), *TrustBadge )
      │  └─ IconButton(Bookmark)
      ├─ Text(title, maxLines:2, style: TitleMedium)
      ├─ Row( Icon(category), Text(category), Dot, Text("D-n"), Dot, Text(createdAtAgo) )
      └─ *PriorityBar(level: High/Mid/Low)

*FilterChipGroup
└─ Wrap(spacing: 8, runSpacing: 8)
   └─ ChoiceChip/FilterChip (selectedColor: CrimsonLight, labelColor: Crimson)

*SkeletonList
└─ ListView.builder
   └─ *SkeletonCard (shimmer)


⸻

11) 상태/서비스 의존 그래프(요약)
	•	#AuthState → #RoleService → Router Guards
	•	#FeedController → #ItemRepo(remote: dio, local: hive/sqflite)
	•	#SearchController ↔ #FilterState ↔ #SavedFilterRepo
	•	#BookmarkService(local cache + sync)
	•	#NotificationRepo(FCM topic) ↔ #Prefs
	•	#PriorityService / #TrustService / #DedupService (도메인 로직)
	•	#StatsRepo(관리 대시보드)

⸻

12) 테마 연결(크림슨 레드)
	•	AppTheme.light() / AppTheme.dark()에서 Crimson 계열 ColorScheme.fromSeed
	•	버튼/칩/탭/인디케이터는 primary=Crimson, 선택 상태는 CrimsonLight
	•	카드/바텀시트 라운드 8/12dp 일관

⸻

