import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 검색 페이지
/// 
/// 키워드 검색, 필터링, 저장된 검색어 관리 등을 담당합니다.
/// 나중에는 고급 필터, 검색 결과 정렬 등의 기능이 추가될 예정이에요.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // 임시 데이터
  final List<String> _recentSearches = [
    '창업 공모전',
    '소프트웨어 개발자',
    '인공지능',
    '취업 박람회',
  ];
  
  final List<String> _popularKeywords = [
    '공모전',
    '인턴십',
    '장학금',
    '논문',
    '세미나',
    '해외연수',
  ];
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: Column(
        children: [
          // 검색 필터 칩
          _buildFilterChips(),
          
          // 메인 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 최근 검색어
                  if (_recentSearches.isNotEmpty) ...[
                    _buildRecentSearches(),
                    SizedBox(height: 32.h),
                  ],
                  
                  // 인기 키워드
                  _buildPopularKeywords(),
                  SizedBox(height: 32.h),
                  
                  // 검색 팁
                  _buildSearchTips(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 검색 AppBar 구성
  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      title: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: '공모전, 취업 정보 검색...',
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 20.w,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 18.w,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
          ),
          onSubmitted: _performSearch,
          onChanged: (value) {
            setState(() {}); // suffixIcon 업데이트를 위해
          },
        ),
      ),
      actions: [
        // 필터 버튼
        IconButton(
          onPressed: _showFilterDialog,
          icon: Icon(
            Icons.tune,
            size: 24.w,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 8.w),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }
  
  /// 필터 칩 영역
  Widget _buildFilterChips() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('전체', isSelected: true),
          SizedBox(width: 8.w),
          _buildFilterChip('공모전'),
          SizedBox(width: 8.w),
          _buildFilterChip('취업'),
          SizedBox(width: 8.w),
          _buildFilterChip('논문'),
          SizedBox(width: 8.w),
          _buildFilterChip('공지'),
          SizedBox(width: 8.w),
          _buildFilterChip('마감 임박'),
        ],
      ),
    );
  }
  
  /// 개별 필터 칩
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.brandCrimson : AppColors.textSecondary,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: 필터 선택 로직
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label 필터 선택됨 (개발 예정)')),
        );
      },
      backgroundColor: AppColors.white,
      selectedColor: AppColors.brandCrimsonLight,
      side: BorderSide(
        color: isSelected ? AppColors.brandCrimson : AppColors.divider,
        width: 1.w,
      ),
      showCheckmark: false,
    );
  }
  
  /// 최근 검색어 섹션
  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색어',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: 최근 검색어 전체 삭제
                setState(() {
                  _recentSearches.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('최근 검색어를 모두 삭제했습니다')),
                );
              },
              child: Text(
                '전체 삭제',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        
        // 검색어 목록
        Column(
          children: _recentSearches.map((search) {
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.divider, width: 1.w),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.history,
                  size: 20.w,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  search,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 16.w,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _recentSearches.remove(search);
                    });
                  },
                ),
                onTap: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  /// 인기 키워드 섹션
  Widget _buildPopularKeywords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Text(
          '인기 키워드',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        
        // 키워드 태그들
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _popularKeywords.asMap().entries.map((entry) {
            final index = entry.key;
            final keyword = entry.value;
            final isTop3 = index < 3;
            
            return InkWell(
              onTap: () {
                _searchController.text = keyword;
                _performSearch(keyword);
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isTop3 
                      ? AppColors.brandCrimsonLight 
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isTop3 
                        ? AppColors.brandCrimson 
                        : AppColors.divider,
                    width: 1.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 순위 표시 (Top 3)
                    if (isTop3) ...[
                      Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.brandCrimson,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    
                    // 키워드 텍스트
                    Text(
                      keyword,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isTop3 ? FontWeight.w600 : FontWeight.w400,
                        color: isTop3 
                            ? AppColors.brandCrimson 
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  /// 검색 팁 섹션
  Widget _buildSearchTips() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20.w,
                color: AppColors.brandCrimson,
              ),
              SizedBox(width: 8.w),
              Text(
                '검색 팁',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          _buildTipItem('키워드를 조합해서 검색하면 더 정확한 결과를 얻을 수 있어요'),
          _buildTipItem('마감일이 임박한 정보는 "마감 임박" 필터를 활용해보세요'),
          _buildTipItem('관심 있는 분야의 키워드를 저장하면 맞춤 알림을 받을 수 있어요'),
        ],
      ),
    );
  }
  
  /// 팁 아이템
  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.brandCrimson,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 검색 실행
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    // TODO: 실제 검색 로직 구현
    // 검색 결과 페이지로 이동하거나 결과를 표시
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('검색: "$query" (실제 검색 기능 개발 예정)'),
        backgroundColor: AppColors.brandCrimson,
      ),
    );
    
    // 최근 검색어에 추가 (중복 제거)
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });
    
    // 키보드 숨기기
    _searchFocusNode.unfocus();
  }
  
  /// 필터 다이얼로그 표시
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // 핸들
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // 제목
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '필터 설정',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.brandCrimson,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 필터 옵션들 (임시)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 48.w,
                            color: AppColors.brandCrimson,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            '고급 필터 기능',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '카테고리, 마감일, 신뢰도 등\n다양한 조건으로 검색할 수 있는\n필터 기능을 개발 중입니다!',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}