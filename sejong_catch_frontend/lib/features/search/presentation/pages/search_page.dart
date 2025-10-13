import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';

/// 🔍 검색 페이지 - 정보 검색 및 필터링
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지 (Profile 패턴 적용!)
/// ✅ 검색바 + 인기 키워드
/// ✅ 고급 필터 바텀시트
/// ✅ AppColors, AppSpacing, AppShadows 공용 컴포넌트 100% 적용
/// ✅ 프로페셔널 디자인 폴리시
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<String> _searchResults = [];

  // 인기 키워드
  final List<String> _popularKeywords = [
    '공모전',
    'AI 해커톤',
    '취업박람회',
    '장학금',
    '세종대',
    '논문 공모',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 검색바 (필터 버튼 포함)
            _buildSearchBar(),

            // 구분선
            Divider(height: 1, thickness: 1, color: AppColors.divider),

            // 검색 결과 또는 인기 키워드
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildPopularSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔎 검색바 - 깔끔한 버전!
  Widget _buildSearchBar() {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          // 검색 입력 필드 (확장)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.divider),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '공모전, 취업, 논문 검색...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AppColors.textSecondary,
                            size: 20.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _isSearching = false;
                              _searchResults.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: AppSpacing.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _isSearching = value.isNotEmpty;
                    if (_isSearching) {
                      // 임시 검색 로직
                      _searchResults = [
                        '🔥 AI 해커톤 대회 - $value 관련',
                        '📌 $value 취업 박람회',
                        '🎓 $value 관련 논문 공모',
                      ];
                    }
                  });
                },
                onSubmitted: (value) => _performSearch(value),
              ),
            ),
          ),

          AppSpacing.horizontalSpaceMD,

          // 고급 필터 버튼 (검색바 옆으로 이동!) 🎯
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.brandCrimsonLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.brandCrimson.withValues(alpha: 0.2),
                ),
                boxShadow: AppShadows.basic,
              ),
              child: Icon(
                Icons.tune,
                size: 20.sp,
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 인기 키워드 섹션
  Widget _buildPopularSection() {
    return SingleChildScrollView(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인기 키워드 제목
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 20.sp,
                color: AppColors.brandCrimson,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                '인기 검색어',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceLG,

          // 인기 키워드 칩들
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm.h,
            children: _popularKeywords.asMap().entries.map((entry) {
              final index = entry.key;
              final keyword = entry.value;
              return _buildKeywordChip(keyword, index + 1);
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXXL,

          // 구분선 추가
          Divider(thickness: 1, color: AppColors.divider),

          AppSpacing.verticalSpaceXL,

          // 최근 검색 (빈 상태)
          _buildRecentSearchSection(),
        ],
      ),
    );
  }

  /// 🏷️ 키워드 칩 - 프로 디자인 버전!
  Widget _buildKeywordChip(String keyword, int rank) {
    final isTopRank = rank <= 3;

    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.text = keyword;
          _isSearching = true;
          _searchResults = [
            '$keyword 관련 공모전 정보',
            '$keyword 취업 기회',
            '$keyword 연구 프로젝트',
          ];
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm.h + 2.h,
        ),
        decoration: BoxDecoration(
          color: isTopRank ? AppColors.brandCrimsonLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isTopRank
                ? AppColors.brandCrimson.withValues(alpha: 0.3)
                : AppColors.divider,
          ),
          boxShadow: AppShadows.basic,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: isTopRank ? AppColors.brandCrimson : AppColors.disabled,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            AppSpacing.horizontalSpaceSM,
            Text(
              keyword,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📜 최근 검색 섹션
  Widget _buildRecentSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, size: 20.sp, color: AppColors.textSecondary),
            AppSpacing.horizontalSpaceSM,
            Text(
              '최근 검색',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        AppSpacing.verticalSpaceLG,
        Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48.sp, color: AppColors.disabled),
              AppSpacing.verticalSpaceSM,
              Text(
                '최근 검색 내역이 없어요',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 📊 검색 결과
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return _buildEmptyResults();
    }

    return ListView.separated(
      padding: AppSpacing.cardPadding,
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
      itemBuilder: (context, index) {
        return _buildResultCard(_searchResults[index]);
      },
    );
  }

  /// 📇 결과 카드 - 프로 디자인 버전!
  Widget _buildResultCard(String title) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$title 상세보기 (준비 중)')));
      },
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider),
          boxShadow: AppShadows.medium,
        ),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 24.sp,
              color: AppColors.brandCrimson,
            ),
            AppSpacing.horizontalSpaceMD,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.disabled,
            ),
          ],
        ),
      ),
    );
  }

  /// 📭 빈 검색 결과
  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: AppColors.disabled),
          AppSpacing.verticalSpaceLG,
          Text(
            '검색 결과가 없어요',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            '다른 키워드로 시도해보세요',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// 🎛️ 고급 필터 바텀시트
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _FilterBottomSheet(),
    );
  }

  /// 🔍 검색 실행
  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = ['$query 관련 공모전', '$query 취업 정보', '$query 연구 기회'];
    });
  }
}

/// 🎛️ 필터 바텀시트 위젯 - 프로 디자인 버전!
class _FilterBottomSheet extends StatefulWidget {
  const _FilterBottomSheet();

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String _selectedCategory = '전체';
  String _selectedTrust = '전체';
  RangeValues _deadlineRange = const RangeValues(0, 30);

  final List<String> _categories = ['전체', '공모전', '취업', '논문', '공지사항'];
  final List<String> _trustLevels = ['전체', '공식', '학술', '언론', '커뮤니티'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: AppShadows.strong,
      ),
      padding: AppSpacing.modalPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(
                '고급 필터',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          AppSpacing.verticalSpaceXXL,

          // 카테고리
          Text(
            '카테고리',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm.h,
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandCrimson
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.divider,
                    ),
                    boxShadow: isSelected ? AppShadows.crimsonGlow : null,
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXL,

          // 구분선 추가
          Divider(thickness: 1, color: AppColors.divider),

          AppSpacing.verticalSpaceXL,

          // 신뢰도
          Text(
            '신뢰도',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm.h,
            children: _trustLevels.map((trust) {
              final isSelected = trust == _selectedTrust;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTrust = trust;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandCrimson
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.divider,
                    ),
                    boxShadow: isSelected ? AppShadows.crimsonGlow : null,
                  ),
                  child: Text(
                    trust,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          AppSpacing.verticalSpaceXXL,

          // 구분선 추가
          Divider(thickness: 1, color: AppColors.divider),

          AppSpacing.verticalSpaceXL,

          // 마감일
          Text(
            '마감일 (D-${_deadlineRange.end.toInt()}일 이내)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          RangeSlider(
            values: _deadlineRange,
            min: 0,
            max: 90,
            divisions: 18,
            activeColor: AppColors.brandCrimson,
            inactiveColor: AppColors.divider,
            onChanged: (values) {
              setState(() {
                _deadlineRange = values;
              });
            },
          ),

          AppSpacing.verticalSpaceXXL,

          // 적용 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('필터가 적용되었어요! 🎯')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCrimson,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                '필터 적용',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
