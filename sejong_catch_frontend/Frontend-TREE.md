(*는 재사용 컴포넌트, #는 상태/서비스 의존)

```
GoRouter
└─ routes
   ├─ /onboarding        -> OnboardingFlowPage     [guard: firstRunGuard]
   ├─ /auth              -> AuthPage
   ├─ /                  -> RootShell (BottomNav)
   │   ├─ /feed          -> FeedPage
   │   ├─ /search        -> SearchPage
   │   ├─ /queue         -> QueuePage             [guard: role>=Student]
   │   └─ /profile       -> ProfilePage
   ├─ /detail/:id        -> DetailPage
   ├─ /console           -> ConsoleShell           [guard: role>=Operator]
   │   ├─ /console/rules -> RulesPage             [guard: role>=Operator]
   │   └─ /console/stats -> StatsDashboardPage    [guard: role>=Admin]
   └─ /settings          -> SettingsPage
```

**가드 의존성**

- authGuard(로그인/학생인증), roleGuard(requiredRole), firstRunGuard(shared_preferences)
- **#AuthState**, **#RoleService**, **#OnboardingState**

> 변경점: /notifications 관련 라우트/화면
> 
> 
> **제거**
> 

---

# **1) 루트 & 공통 레이아웃**

```
App (MaterialApp.router with AppTheme)
└─ MultiProvider (provider)
   └─ Router (GoRouter)
      └─ RootShell (Scaffold)
         ├─ body: IndexedStack
         │  ├─ FeedPage
         │  ├─ SearchPage
         │  ├─ QueuePage
         │  └─ ProfilePage
         └─ bottomNavigationBar: *AppBottomNav
```

**공용 위젯**

```
*AppBottomNav (BottomNavigationBar)
*AppCard (정보 카드: 신뢰뱃지/우선순위바 포함)
*PriorityBar (2~3px)
*TrustBadge (Outlined)
*FilterChipGroup
*EmptyView / *ErrorView / *SkeletonList
*CTAButton (Crimson 테마)
*SearchAppBar / *SearchBar
```

> 변경점: ProviderScope/RiverpodScope →
> 
> 
> **MultiProvider**
> 

---

# **2) 온보딩 플로우 (4화면)**

```
OnboardingFlowPage
└─ Scaffold
   ├─ AppBar(actions: [TextButton("건너뛰기")])
   └─ Column
      ├─ Expanded(
      │   child: PageView(controller)
      │     ├─ _IntroPage(illustration, title, subtitle)
      │     ├─ _CollectFilterPage(자동 수집·중복 제거·신뢰)
      │     ├─ _RolesPage(학생/게스트/운영/관리)
      │     └─ _PersonalizePage(DeptDropdown, InterestChips)
      ├─ *SmoothPageIndicator
      └─ Padding(child: *CTAButton(next/완료))
```

상태/저장: **#OnboardingState**, **shared_preferences(완료 플래그)**, **#ProfilePref(학과/관심사)**

> 변경점: 알림 권한 단계 삭제
> 
> 
> **4화면으로 단축**
> 

---

# **3) 피드(추천/마감임박/최신)**

```
FeedPage
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
```

의존성: **#FeedController (pagination)**, **#PriorityService**, **#TrustService**, **#BookmarkService**

> 변경점: 캐시/오프라인 미지원 → #FeedController는
> 
> 
> **서버 페이지네이션**
> 

---

# **4) 검색 & 필터**

```
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
```

```
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
```

의존성: **#SearchController**, **#FilterState**, **#SavedFilterRepo**, **#DedupService**

---

# **5) 상세 화면**

```
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
```

의존성: **#ItemRepo.getById**, **#BookmarkService**, **#ShareService**, **#DedupService**

---

# **6) 줄서기**

```
QueuePage
└─ Scaffold
   ├─ appBar: AppBar(title: "줄서기")
   └─ Column
      ├─ *SegmentedTabs(대기중 | 진행중 | 완료)
      └─ Expanded
         └─ TabBarView
            ├─ _WaitingList
            │   └─ *PagedListView<QueueItem>
            │      ├─ itemBuilder: *QueueCard(순번, D-day, 진행률)
            │      └─ swipeActions: Remove / Settings
            ├─ _InProgressList (동일)
            └─ _CompletedList (동일)
```

의존성: **#QueueService** *(대기열 관리, 순번 계산, 알림 스케줄링)*

> 변경점: 북마크 → 줄서기로 완전 전환
> 
> 
> **대기열 시스템 도입**
> 

---

# **7) 프로필(내 정보)**

```
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
```

의존성: **#AuthState**, **#ProfilePref**, **#ThemeController**, **#I18n**

---

# **8) 운영/관리 콘솔**

```
ConsoleShell (role>=Operator)
└─ Scaffold
   ├─ appBar: AppBar(title:"콘솔", actions:[IconButton(Stats)])
   └─ ListView
      ├─ *ConsoleCard("수집 규칙", trailing: CTA -> RulesPage)
      ├─ *ConsoleCard("제외어 관리", trailing: CTA)
      ├─ *ConsoleCard("중복 규칙", trailing: CTA)
      └─ if (role==Admin) *ConsoleCard("통계/대시보드", trailing: CTA -> StatsDashboardPage)
```

```
RulesPage
└─ Scaffold
   └─ ListView
      ├─ *RuleEditorList (Add/Edit/Delete)
      └─ *CTAButton("저장")
```

```
StatsDashboardPage (role>=Admin)
└─ CustomScrollView
   ├─ SliverToBoxAdapter: *KpiCardsRow
   ├─ SliverToBoxAdapter: *LineChart("일별 등록/노출/클릭")
   ├─ SliverToBoxAdapter: *BarChart("카테고리별 조회 Top5")
   └─ SliverToBoxAdapter: *Heatmap("요일/시간대 클릭")
```

의존성: **#RulesRepo**, **#StatsRepo**, **syncfusion_flutter_charts**

> 변경점: 알림/분석 패키지 제거와 무관 —
> 
> 
> **대시보드 기능 유지**
> 

---

# **9) 공용 위젯 상세(발췌)**

```
*AppCard(Item)
└─ Container(decoration: card + radius 8)
   └─ Column(spacing: 8~12)
      ├─ Row(align: spaceBetween)
      │  ├─ Row( *SourceLogo, Text(domain), *TrustBadge )
      │  └─ IconButton(Bookmark)
      ├─ Text(title, maxLines:2, style: TitleMedium)
      ├─ Row( Icon(category), Text(category), Dot, Text("D-n"), Dot, Text(createdAtAgo) )
      └─ *PriorityBar(level: High/Mid/Low)
```

```
*FilterChipGroup
└─ Wrap(spacing: 8, runSpacing: 8)
   └─ ChoiceChip/FilterChip (selectedColor: CrimsonLight, labelColor: Crimson)
```

```
*SkeletonList
└─ ListView.builder
   └─ *SkeletonCard (shimmer)
```

---

# **10) 상태/서비스 의존 그래프(요약) — 업데이트 반영**

- **#AuthState → #RoleService → Router Guards**
- **#FeedController → #ItemRepo(remote: dio)** *(로컬 DB 미사용)*
- **#SearchController ↔ #FilterState ↔ #SavedFilterRepo**
- **#QueueService** *(대기열 관리, 순번 계산, 알림 스케줄링)*
- **#PriorityService / #TrustService / #DedupService** *(도메인 로직)*
- **#StatsRepo(관리 대시보드)**

> 변경점: #BookmarkService → #QueueService 전환
> 
> 
> **대기열 시스템 도입**
> 

---

# **11) 테마 연결(크림슨 레드)**

- AppTheme.light() / AppTheme.dark()에서 **Crimson 계열 ColorScheme.fromSeed**
- 버튼/칩/탭/인디케이터: **primary = Crimson**, 선택 상태 **CrimsonLight**
- 카드/바텀시트 **라운드 8/12dp** 일관

---

## **보너스: 구현 우선순위(스프린트 제안)**

1. 온보딩(4화면) + shared_preferences 플래그
2. 하단 탭/라우팅 가드 + 피드 페이지 infinite_scroll_pagination
3. 검색/필터 바텀시트 + shimmer 로딩
4. 상세/줄서기 흐름(서버 연동)
5. 콘솔 Rules/Stats 목업 → 실제 API 연결

---