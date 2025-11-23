// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRepositoryHash() => r'050f6da31f2ecb32fd0209179d0f170cf690e726';

/// 검색 Repository
///
/// **2가지 모드 자동 전환**:
/// - **Mock 모드** (개발): `USE_MOCK_AUTH=true` → 하드코딩 더미 검색 결과
/// - **Real 모드** (프로덕션): `USE_MOCK_AUTH=false` → 크롤러 캐시 데이터 검색
///
/// Copied from [SearchRepository].
@ProviderFor(SearchRepository)
final searchRepositoryProvider =
    AutoDisposeNotifierProvider<SearchRepository, void>.internal(
      SearchRepository.new,
      name: r'searchRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchRepository = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
