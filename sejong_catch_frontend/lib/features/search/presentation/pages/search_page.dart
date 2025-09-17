import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 🔍 검색 페이지
///
/// CLAUDE.md 원칙:
/// ✅ 검색바 + 고급 필터 바텀시트 구현 예정
/// ✅ UI만 담당, 상태 관리는 별도 Controller에서
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(context));
  }

  /// 📱 검색 전용 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        '검색',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // 🔍 검색바
          _buildSearchBar(context),

          SizedBox(height: 24.h),

          // 🏷️ 인기 키워드
          _buildPopularKeywords(),

          SizedBox(height: 24.h),

          // 📰 최근 검색 기록
          _buildRecentSearches(),
        ],
      ),
    );
  }

  /// 🔍 검색바 위젯
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: '공모전, 취업 정보를 검색해보세요',
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              prefixIcon: Icon(
                Icons.search,
                size: 20.r,
                color: Colors.grey[600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.brandCrimson),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        IconButton(
          icon: Icon(Icons.tune, size: 24.r, color: AppColors.brandCrimson),
          onPressed: () {
            // TODO: 고급 필터 바텀시트 열기
            _showFilterBottomSheet(context);
          },
        ),
      ],
    );
  }

  /// 🏷️ 인기 키워드 섹션
  Widget _buildPopularKeywords() {
    final keywords = ['창업경진대회', '인턴십', '논문공모', '취업박람회', '해외연수'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔥 인기 키워드',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: keywords.map((keyword) {
            return ActionChip(
              label: Text(keyword),
              onPressed: () {
                // TODO: 키워드 검색 실행
              },
              backgroundColor: AppColors.brandCrimsonLight,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.brandCrimson,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 📰 최근 검색 기록
  Widget _buildRecentSearches() {
    final recentSearches = ['AI 공모전', '대학생 인턴', '졸업논문'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '최근 검색',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: 검색 기록 전체 삭제
              },
              child: Text(
                '전체 삭제',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ...recentSearches.map((search) {
          return ListTile(
            leading: Icon(Icons.history, size: 20.r, color: Colors.grey[600]),
            title: Text(search, style: TextStyle(fontSize: 14.sp)),
            trailing: IconButton(
              icon: Icon(Icons.close, size: 18.r, color: Colors.grey[500]),
              onPressed: () {
                // TODO: 개별 검색 기록 삭제
              },
            ),
            onTap: () {
              // TODO: 해당 키워드로 검색 실행
            },
          );
        }),
      ],
    );
  }

  /// 🎛️ 고급 필터 바텀시트
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎛️ 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '상세 필터',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // 필터 옵션들 (임시)
              Text(
                '카테고리',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              const Text('📋 공모전, 🏢 취업, 📝 논문, 📢 공지사항'),

              SizedBox(height: 20.h),

              Text(
                '마감일',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              const Text('⏰ 1주일 이내, 1개월 이내, 기간 없음'),

              const Spacer(),

              // 적용 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: 필터 적용 로직
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandCrimson,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    '필터 적용',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
