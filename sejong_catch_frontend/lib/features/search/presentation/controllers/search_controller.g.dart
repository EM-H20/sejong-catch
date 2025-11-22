// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchControllerHash() => r'64502f53344b3f4f1f4d6dab6b8fdccee0283873';

/// 🔍 검색 컨트롤러
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod로 상태 관리
/// ✅ state.copyWith()로 불변 업데이트
/// ✅ 검색, 필터 로직 중앙화
/// ✅ async 검색 + 히스토리 연동
///
/// Copied from [SearchController].
@ProviderFor(SearchController)
final searchControllerProvider =
    AutoDisposeNotifierProvider<SearchController, SearchState>.internal(
      SearchController.new,
      name: r'searchControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchController = AutoDisposeNotifier<SearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
