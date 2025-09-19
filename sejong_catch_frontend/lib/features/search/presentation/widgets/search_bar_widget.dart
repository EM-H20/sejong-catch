import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../controllers/search_controller.dart';

/// 🔍 검색바 위젯 (애니메이션 포함)
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 Riverpod 상태 연동
/// ✅ ScreenUtil로 반응형 크기
/// ✅ 깔끔한 애니메이션과 사용자 경험
class SearchBarWidget extends ConsumerStatefulWidget {
  final VoidCallback? onFilterPressed;

  const SearchBarWidget({
    super.key,
    this.onFilterPressed,
  });

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();

    // 애니메이션 컨트롤러 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: AppColors.brandCrimson,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // 포커스 상태에 따른 애니메이션
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final searchController = ref.read(searchControllerProvider.notifier);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Row(
            children: [
              // 🔍 검색 입력 필드
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _colorAnimation.value ?? Colors.grey[300]!,
                      width: 2.w,
                    ),
                    boxShadow: _focusNode.hasFocus
                        ? [
                            BoxShadow(
                              color: AppColors.brandCrimson.withOpacity(0.1),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ]
                        : null,
                  ),
                  child: AppTextField.search(
                    controller: _textController,
                    focusNode: _focusNode,
                    hintText: searchState.isLoading
                        ? '검색 중...'
                        : '공모전, 취업 정보를 검색해보세요',
                    enabled: !searchState.isLoading,
                    onChanged: (value) {
                      searchController.updateQuery(value);

                      // 실시간 검색 제안어 (디바운싱 효과)
                      if (value.length >= 2) {
                        // TODO: 제안어 Provider 연동
                      }
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        searchController.search(value.trim());
                        _focusNode.unfocus();
                      }
                    },
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // 🎛️ 필터 버튼
              _buildFilterButton(searchState),
            ],
          ),
        );
      },
    );
  }

  /// 🎛️ 필터 버튼 빌드
  Widget _buildFilterButton(searchState) {
    final hasActiveFilter = searchState.filter.isActive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: hasActiveFilter ? AppColors.brandCrimson : Colors.grey[100],
        border: Border.all(
          color: hasActiveFilter ? AppColors.brandCrimson : Colors.grey[300]!,
          width: 1.w,
        ),
      ),
      child: IconButton(
        icon: Stack(
          children: [
            Icon(
              Icons.tune,
              size: 24.r,
              color: hasActiveFilter ? Colors.white : AppColors.brandCrimson,
            ),
            if (hasActiveFilter)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        onPressed: widget.onFilterPressed,
      ),
    );
  }
}

/// 🔍 검색 제안어 드롭다운 위젯
class SearchSuggestionsWidget extends ConsumerWidget {
  final String query;
  final Function(String) onSuggestionTap;

  const SearchSuggestionsWidget({
    super.key,
    required this.query,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (query.length < 2) return const SizedBox.shrink();

    final suggestionsAsync = ref.watch(searchSuggestionsProvider(query));

    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: EdgeInsets.only(top: 4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: suggestions.map((suggestion) {
              return ListTile(
                dense: true,
                leading: Icon(
                  Icons.search,
                  size: 18.r,
                  color: Colors.grey[600],
                ),
                title: RichText(
                  text: TextSpan(
                    children: _highlightMatches(suggestion, query),
                  ),
                ),
                onTap: () => onSuggestionTap(suggestion),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 검색어와 일치하는 부분 하이라이트
  List<TextSpan> _highlightMatches(String text, String query) {
    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // 매칭 전 텍스트
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ));
      }

      // 매칭 텍스트 (하이라이트)
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.brandCrimson,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // 남은 텍스트
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black87,
        ),
      ));
    }

    return spans;
  }
}