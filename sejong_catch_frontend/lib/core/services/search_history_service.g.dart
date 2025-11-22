// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHistoryServiceHash() =>
    r'54d1b072f52f92c98229da82679eef331fc107b8';

/// 🔍 검색 히스토리 서비스
///
/// **기능**:
/// - 최근 검색어 저장/조회/삭제
/// - 최대 10개 제한
/// - SharedPreferences 사용
///
/// Copied from [SearchHistoryService].
@ProviderFor(SearchHistoryService)
final searchHistoryServiceProvider =
    AutoDisposeNotifierProvider<SearchHistoryService, void>.internal(
      SearchHistoryService.new,
      name: r'searchHistoryServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchHistoryServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchHistoryService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
