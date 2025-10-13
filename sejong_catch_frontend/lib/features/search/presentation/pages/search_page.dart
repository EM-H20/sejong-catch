import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 🔍 검색 페이지 - 정보 검색 및 필터링
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지 (Profile 패턴 적용!)
/// ✅ 검색바 + 인기 키워드
/// ✅ 고급 필터 바텀시트
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
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('검색'),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // 검색바
        _buildSearchBar(),

        // 검색 결과 또는 인기 키워드
        Expanded(
          child: _isSearching ? _buildSearchResults() : _buildPopularSection(),
        ),
      ],
    );
  }

  /// 🔎 검색바
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 검색 입력 필드
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '공모전, 취업, 논문 검색...',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFF6B7280),
                  size: 20.sp,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: const Color(0xFF6B7280),
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
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

          SizedBox(height: 12.h),

          // 고급 필터 버튼
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.tune,
                  size: 16.sp,
                  color: const Color(0xFFDC143C),
                ),
                SizedBox(width: 6.w),
                Text(
                  '고급 필터',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFDC143C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 인기 키워드 섹션
  Widget _buildPopularSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인기 키워드 제목
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 20.sp,
                color: const Color(0xFFDC143C),
              ),
              SizedBox(width: 8.w),
              Text(
                '인기 검색어',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 인기 키워드 칩들
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _popularKeywords.asMap().entries.map((entry) {
              final index = entry.key;
              final keyword = entry.value;
              return _buildKeywordChip(keyword, index + 1);
            }).toList(),
          ),

          SizedBox(height: 32.h),

          // 최근 검색 (빈 상태)
          _buildRecentSearchSection(),
        ],
      ),
    );
  }

  /// 🏷️ 키워드 칩
  Widget _buildKeywordChip(String keyword, int rank) {
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: rank <= 3 ? const Color(0xFFFEF2F2) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: rank <= 3
                ? const Color(0xFFDC143C).withValues(alpha: 0.3)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: rank <= 3
                    ? const Color(0xFFDC143C)
                    : const Color(0xFF9CA3AF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              keyword,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
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
            Icon(
              Icons.history,
              size: 20.sp,
              color: const Color(0xFF6B7280),
            ),
            SizedBox(width: 8.w),
            Text(
              '최근 검색',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48.sp,
                color: const Color(0xFF9CA3AF),
              ),
              SizedBox(height: 8.h),
              Text(
                '최근 검색 내역이 없어요',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
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
      padding: EdgeInsets.all(16.w),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildResultCard(_searchResults[index]);
      },
    );
  }

  /// 📇 결과 카드
  Widget _buildResultCard(String title) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 상세보기 (준비 중)')),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 24.sp,
              color: const Color(0xFFDC143C),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: const Color(0xFF9CA3AF),
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
          Icon(
            Icons.search_off,
            size: 64.sp,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16.h),
          Text(
            '검색 결과가 없어요',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '다른 키워드로 시도해보세요',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => _FilterBottomSheet(),
    );
  }

  /// 🔍 검색 실행
  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [
        '$query 관련 공모전',
        '$query 취업 정보',
        '$query 연구 기회',
      ];
    });
  }
}

/// 🎛️ 필터 바텀시트 위젯
class _FilterBottomSheet extends StatefulWidget {
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
      padding: EdgeInsets.all(24.w),
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
                  color: const Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // 카테고리
          Text(
            '카테고리',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _categories.map((category) {
              final isSelected = category == _selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFDC143C)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFDC143C)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24.h),

          // 신뢰도
          Text(
            '신뢰도',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _trustLevels.map((trust) {
              final isSelected = trust == _selectedTrust;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTrust = trust;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFDC143C)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFDC143C)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Text(
                    trust,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24.h),

          // 마감일
          Text(
            '마감일 (D-${_deadlineRange.end.toInt()}일 이내)',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          RangeSlider(
            values: _deadlineRange,
            min: 0,
            max: 90,
            divisions: 18,
            activeColor: const Color(0xFFDC143C),
            onChanged: (values) {
              setState(() {
                _deadlineRange = values;
              });
            },
          ),

          SizedBox(height: 24.h),

          // 적용 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('필터가 적용되었어요! 🎯')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC143C),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                '필터 적용',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
