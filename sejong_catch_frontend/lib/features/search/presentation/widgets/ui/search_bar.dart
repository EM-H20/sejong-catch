import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../controllers/search_controller.dart';
import 'filter_button.dart';

/// 🔎 검색바 - Riverpod 연동 버전
///
/// CLAUDE.md 원칙:
/// ✅ DRY 원칙 - FilterButton 재사용
/// ✅ ConsumerStatefulWidget으로 Riverpod + TextEditingController 관리
/// ✅ AppColors, AppSpacing 100% 사용
class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({
    required this.onShowFilter,
    super.key,
  });

  final VoidCallback onShowFilter;

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    EasyDebounce.cancel('search'); // 디바운서 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);

    // 상태와 텍스트 컨트롤러 동기화
    if (_textController.text != state.query) {
      _textController.text = state.query;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }

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
                controller: _textController,
                decoration: InputDecoration(
                  hintText: '공모전, 취업, 논문 검색...',
                  hintStyle: AppTextStyles.bodyRegular14.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                  suffixIcon: state.isSearching
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.brandCrimson,
                            ),
                          ),
                        )
                      : (state.query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.textSecondary,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                _textController.clear();
                                controller.clearSearch();
                              },
                            )
                          : null),
                  border: InputBorder.none,
                  contentPadding: AppSpacing.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                onChanged: (value) {
                  // 1. 상태 즉시 업데이트 (입력 반응성)
                  controller.updateQuery(value);

                  // 2. 500ms 디바운싱 후 실시간 검색!
                  EasyDebounce.debounce(
                    'search',
                    const Duration(milliseconds: 500),
                    () => controller.performRealtimeSearch(value),
                  );
                },
                onSubmitted: (value) {
                  // 엔터키는 기존 로직 유지 (히스토리 추가!)
                  EasyDebounce.cancel('search');
                  controller.performSearch(value);
                },
              ),
            ),
          ),

          AppSpacing.horizontalSpaceMD,

          // 고급 필터 버튼
          FilterButton(onTap: widget.onShowFilter),
        ],
      ),
    );
  }
}
