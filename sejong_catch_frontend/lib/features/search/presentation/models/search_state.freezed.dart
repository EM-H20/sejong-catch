// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SearchState {
  /// 검색어
  String get query => throw _privateConstructorUsedError;

  /// 검색 중 여부
  bool get isSearching => throw _privateConstructorUsedError;

  /// 검색 결과 목록 (FeedItem)
  List<FeedItem> get searchResults => throw _privateConstructorUsedError;

  /// 최근 검색어
  List<String> get recentSearches => throw _privateConstructorUsedError;

  /// 에러 메시지
  String? get error => throw _privateConstructorUsedError;

  /// 선택된 카테고리 필터
  String get selectedCategory => throw _privateConstructorUsedError;

  /// 선택된 시간 범위 필터
  String get selectedTimeRange => throw _privateConstructorUsedError;

  /// 조회수 범위 필터 (프리셋 방식)
  String get selectedViewsRange => throw _privateConstructorUsedError;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchStateCopyWith<SearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
    SearchState value,
    $Res Function(SearchState) then,
  ) = _$SearchStateCopyWithImpl<$Res, SearchState>;
  @useResult
  $Res call({
    String query,
    bool isSearching,
    List<FeedItem> searchResults,
    List<String> recentSearches,
    String? error,
    String selectedCategory,
    String selectedTimeRange,
    String selectedViewsRange,
  });
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? isSearching = null,
    Object? searchResults = null,
    Object? recentSearches = null,
    Object? error = freezed,
    Object? selectedCategory = null,
    Object? selectedTimeRange = null,
    Object? selectedViewsRange = null,
  }) {
    return _then(
      _value.copyWith(
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
            isSearching: null == isSearching
                ? _value.isSearching
                : isSearching // ignore: cast_nullable_to_non_nullable
                      as bool,
            searchResults: null == searchResults
                ? _value.searchResults
                : searchResults // ignore: cast_nullable_to_non_nullable
                      as List<FeedItem>,
            recentSearches: null == recentSearches
                ? _value.recentSearches
                : recentSearches // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedCategory: null == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedTimeRange: null == selectedTimeRange
                ? _value.selectedTimeRange
                : selectedTimeRange // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedViewsRange: null == selectedViewsRange
                ? _value.selectedViewsRange
                : selectedViewsRange // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchStateImplCopyWith<$Res>
    implements $SearchStateCopyWith<$Res> {
  factory _$$SearchStateImplCopyWith(
    _$SearchStateImpl value,
    $Res Function(_$SearchStateImpl) then,
  ) = __$$SearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String query,
    bool isSearching,
    List<FeedItem> searchResults,
    List<String> recentSearches,
    String? error,
    String selectedCategory,
    String selectedTimeRange,
    String selectedViewsRange,
  });
}

/// @nodoc
class __$$SearchStateImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchStateImpl>
    implements _$$SearchStateImplCopyWith<$Res> {
  __$$SearchStateImplCopyWithImpl(
    _$SearchStateImpl _value,
    $Res Function(_$SearchStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? isSearching = null,
    Object? searchResults = null,
    Object? recentSearches = null,
    Object? error = freezed,
    Object? selectedCategory = null,
    Object? selectedTimeRange = null,
    Object? selectedViewsRange = null,
  }) {
    return _then(
      _$SearchStateImpl(
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        isSearching: null == isSearching
            ? _value.isSearching
            : isSearching // ignore: cast_nullable_to_non_nullable
                  as bool,
        searchResults: null == searchResults
            ? _value._searchResults
            : searchResults // ignore: cast_nullable_to_non_nullable
                  as List<FeedItem>,
        recentSearches: null == recentSearches
            ? _value._recentSearches
            : recentSearches // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedTimeRange: null == selectedTimeRange
            ? _value.selectedTimeRange
            : selectedTimeRange // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedViewsRange: null == selectedViewsRange
            ? _value.selectedViewsRange
            : selectedViewsRange // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl({
    this.query = '',
    this.isSearching = false,
    final List<FeedItem> searchResults = const [],
    final List<String> recentSearches = const [],
    this.error,
    this.selectedCategory = '전체',
    this.selectedTimeRange = '전체',
    this.selectedViewsRange = '전체',
  }) : _searchResults = searchResults,
       _recentSearches = recentSearches;

  /// 검색어
  @override
  @JsonKey()
  final String query;

  /// 검색 중 여부
  @override
  @JsonKey()
  final bool isSearching;

  /// 검색 결과 목록 (FeedItem)
  final List<FeedItem> _searchResults;

  /// 검색 결과 목록 (FeedItem)
  @override
  @JsonKey()
  List<FeedItem> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  /// 최근 검색어
  final List<String> _recentSearches;

  /// 최근 검색어
  @override
  @JsonKey()
  List<String> get recentSearches {
    if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentSearches);
  }

  /// 에러 메시지
  @override
  final String? error;

  /// 선택된 카테고리 필터
  @override
  @JsonKey()
  final String selectedCategory;

  /// 선택된 시간 범위 필터
  @override
  @JsonKey()
  final String selectedTimeRange;

  /// 조회수 범위 필터 (프리셋 방식)
  @override
  @JsonKey()
  final String selectedViewsRange;

  @override
  String toString() {
    return 'SearchState(query: $query, isSearching: $isSearching, searchResults: $searchResults, recentSearches: $recentSearches, error: $error, selectedCategory: $selectedCategory, selectedTimeRange: $selectedTimeRange, selectedViewsRange: $selectedViewsRange)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchStateImpl &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            const DeepCollectionEquality().equals(
              other._searchResults,
              _searchResults,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentSearches,
              _recentSearches,
            ) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedTimeRange, selectedTimeRange) ||
                other.selectedTimeRange == selectedTimeRange) &&
            (identical(other.selectedViewsRange, selectedViewsRange) ||
                other.selectedViewsRange == selectedViewsRange));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    isSearching,
    const DeepCollectionEquality().hash(_searchResults),
    const DeepCollectionEquality().hash(_recentSearches),
    error,
    selectedCategory,
    selectedTimeRange,
    selectedViewsRange,
  );

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      __$$SearchStateImplCopyWithImpl<_$SearchStateImpl>(this, _$identity);
}

abstract class _SearchState implements SearchState {
  const factory _SearchState({
    final String query,
    final bool isSearching,
    final List<FeedItem> searchResults,
    final List<String> recentSearches,
    final String? error,
    final String selectedCategory,
    final String selectedTimeRange,
    final String selectedViewsRange,
  }) = _$SearchStateImpl;

  /// 검색어
  @override
  String get query;

  /// 검색 중 여부
  @override
  bool get isSearching;

  /// 검색 결과 목록 (FeedItem)
  @override
  List<FeedItem> get searchResults;

  /// 최근 검색어
  @override
  List<String> get recentSearches;

  /// 에러 메시지
  @override
  String? get error;

  /// 선택된 카테고리 필터
  @override
  String get selectedCategory;

  /// 선택된 시간 범위 필터
  @override
  String get selectedTimeRange;

  /// 조회수 범위 필터 (프리셋 방식)
  @override
  String get selectedViewsRange;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
