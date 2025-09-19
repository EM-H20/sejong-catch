// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchSuggestionsHash() => r'eb7d3b5d64b610d2f43a8cdc7b0449a0909e480c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 🔍 검색 제안어 Provider (자동완성용)
///
/// Copied from [searchSuggestions].
@ProviderFor(searchSuggestions)
const searchSuggestionsProvider = SearchSuggestionsFamily();

/// 🔍 검색 제안어 Provider (자동완성용)
///
/// Copied from [searchSuggestions].
class SearchSuggestionsFamily extends Family<AsyncValue<List<String>>> {
  /// 🔍 검색 제안어 Provider (자동완성용)
  ///
  /// Copied from [searchSuggestions].
  const SearchSuggestionsFamily();

  /// 🔍 검색 제안어 Provider (자동완성용)
  ///
  /// Copied from [searchSuggestions].
  SearchSuggestionsProvider call(String query) {
    return SearchSuggestionsProvider(query);
  }

  @override
  SearchSuggestionsProvider getProviderOverride(
    covariant SearchSuggestionsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchSuggestionsProvider';
}

/// 🔍 검색 제안어 Provider (자동완성용)
///
/// Copied from [searchSuggestions].
class SearchSuggestionsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// 🔍 검색 제안어 Provider (자동완성용)
  ///
  /// Copied from [searchSuggestions].
  SearchSuggestionsProvider(String query)
    : this._internal(
        (ref) => searchSuggestions(ref as SearchSuggestionsRef, query),
        from: searchSuggestionsProvider,
        name: r'searchSuggestionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchSuggestionsHash,
        dependencies: SearchSuggestionsFamily._dependencies,
        allTransitiveDependencies:
            SearchSuggestionsFamily._allTransitiveDependencies,
        query: query,
      );

  SearchSuggestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(SearchSuggestionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSuggestionsProvider._internal(
        (ref) => create(ref as SearchSuggestionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _SearchSuggestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSuggestionsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchSuggestionsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchSuggestionsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with SearchSuggestionsRef {
  _SearchSuggestionsProviderElement(super.provider);

  @override
  String get query => (origin as SearchSuggestionsProvider).query;
}

String _$popularKeywordsHash() => r'0bc2c0b41493ae9bde64dd02fa9c4ebaae93b095';

/// 📊 검색 통계 Provider (인기 키워드 업데이트용)
///
/// Copied from [popularKeywords].
@ProviderFor(popularKeywords)
final popularKeywordsProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      popularKeywords,
      name: r'popularKeywordsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$popularKeywordsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PopularKeywordsRef = AutoDisposeFutureProviderRef<List<String>>;
String _$searchControllerHash() => r'60c149fde2a5d9f5461a26fafa51eeee89d3cbcc';

/// 🔍 검색 컨트롤러 (Riverpod + Freezed 없이!)
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod 어노테이션으로 자동 생성
/// ✅ 모든 상태 관리 로직 중앙 집중
/// ✅ copyWith로 불변 상태 변경
/// ✅ 컴파일 타임 안전성 보장
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
