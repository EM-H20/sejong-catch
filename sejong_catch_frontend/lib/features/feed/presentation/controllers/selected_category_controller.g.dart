// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_category_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryListHash() => r'47ddaf94cc0179916c9a37a33104f7d9fdab6e1e';

/// 카테고리 목록 Provider
///
/// **반환**:
/// - Mock 모드: ['전체', '공모전', '취업', '논문', '학교공지', '축제']
/// - Real 모드: ['전체', '일반공지', '입학공지', '학사공지', ...]
///
/// Copied from [categoryList].
@ProviderFor(categoryList)
final categoryListProvider = AutoDisposeProvider<List<String>>.internal(
  categoryList,
  name: r'categoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryListRef = AutoDisposeProviderRef<List<String>>;
String _$selectedCategoryHash() => r'00d9c03046f4e945a727e0e648820dff92d0500b';

/// 선택된 카테고리 상태 관리
///
/// **용도**: 카테고리 필터링 UI 상태 제어
/// **기본값**: '전체' (모든 카테고리 표시)
///
/// Copied from [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
      SelectedCategory.new,
      name: r'selectedCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
