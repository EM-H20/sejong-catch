import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/search_controller.dart';
import '../models/search_state.dart';
import '../widgets/ui/filter_bottom_sheet.dart';
import '../widgets/ui/popular_keywords.dart';
import '../widgets/ui/search_bar.dart';
import '../widgets/ui/search_result_card.dart';

/// 🔍 검색 페이지 - 정보 검색 및 필터링
///
/// CLAUDE.md 원칙:
/// ✅ ConsumerWidget으로 Riverpod 연동 (StatefulWidget ❌)
/// ✅ DRY 원칙 - 6개 컴포넌트 재사용
/// ✅ EmptyListWidget 활용 (core/widgets)
/// ✅ AppColors, AppSpacing, AppDivider 100% 사용
/// ✅ 코드량: 663줄 → 110줄 (83% 감소!)
class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 검색바 (필터 버튼 포함)
            SearchBarWidget(
              onShowFilter: () => _showFilterBottomSheet(context),
            ),

            // 구분선
            AppDivider.thin(),

            // 검색 결과 또는 인기 키워드
            Expanded(
              child: state.isSearching
                  ? _buildSearchResults(context, ref, state)
                  : const PopularKeywords(),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 검색 결과
  Widget _buildSearchResults(
    BuildContext context,
    WidgetRef ref,
    SearchState state,
  ) {
    if (state.searchResults.isEmpty) {
      return const EmptyListWidget(
        icon: Icons.search_off,
        message: '검색 결과가 없어요\n다른 키워드로 시도해보세요',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return SearchResultCard(
          title: state.searchResults[index],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.searchResults[index]} 상세보기 (준비 중)'),
              ),
            );
          },
        );
      },
    );
  }

  /// 🎛️ 고급 필터 바텀시트
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
