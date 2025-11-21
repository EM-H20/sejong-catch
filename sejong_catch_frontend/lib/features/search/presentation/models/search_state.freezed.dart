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

  /// 검색 결과 목록
  List<String> get searchResults => throw _privateConstructorUsedError;

  /// 인기 키워드
  List<String> get popularKeywords => throw _privateConstructorUsedError;

  /// 선택된 카테고리 필터
  String get selectedCategory => throw _privateConstructorUsedError;

  /// 선택된 신뢰도 필터
  String get selectedTrust => throw _privateConstructorUsedError;

  /// 마감일 범위 필터
  RangeValues get deadlineRange => throw _privateConstructorUsedError;

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
    List<String> searchResults,
    List<String> popularKeywords,
    String selectedCategory,
    String selectedTrust,
    RangeValues deadlineRange,
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
    Object? popularKeywords = null,
    Object? selectedCategory = null,
    Object? selectedTrust = null,
    Object? deadlineRange = null,
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
                      as List<String>,
            popularKeywords: null == popularKeywords
                ? _value.popularKeywords
                : popularKeywords // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            selectedCategory: null == selectedCategory
                ? _value.selectedCategory
                : selectedCategory // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedTrust: null == selectedTrust
                ? _value.selectedTrust
                : selectedTrust // ignore: cast_nullable_to_non_nullable
                      as String,
            deadlineRange: null == deadlineRange
                ? _value.deadlineRange
                : deadlineRange // ignore: cast_nullable_to_non_nullable
                      as RangeValues,
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
    List<String> searchResults,
    List<String> popularKeywords,
    String selectedCategory,
    String selectedTrust,
    RangeValues deadlineRange,
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
    Object? popularKeywords = null,
    Object? selectedCategory = null,
    Object? selectedTrust = null,
    Object? deadlineRange = null,
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
                  as List<String>,
        popularKeywords: null == popularKeywords
            ? _value._popularKeywords
            : popularKeywords // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        selectedCategory: null == selectedCategory
            ? _value.selectedCategory
            : selectedCategory // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedTrust: null == selectedTrust
            ? _value.selectedTrust
            : selectedTrust // ignore: cast_nullable_to_non_nullable
                  as String,
        deadlineRange: null == deadlineRange
            ? _value.deadlineRange
            : deadlineRange // ignore: cast_nullable_to_non_nullable
                  as RangeValues,
      ),
    );
  }
}

/// @nodoc

class _$SearchStateImpl implements _SearchState {
  const _$SearchStateImpl({
    this.query = '',
    this.isSearching = false,
    final List<String> searchResults = const [],
    final List<String> popularKeywords = const [
      '공모전',
      'AI 해커톤',
      '취업박람회',
      '장학금',
      '세종대',
      '논문 공모',
    ],
    this.selectedCategory = '전체',
    this.selectedTrust = '전체',
    this.deadlineRange = const RangeValues(0, 30),
  }) : _searchResults = searchResults,
       _popularKeywords = popularKeywords;

  /// 검색어
  @override
  @JsonKey()
  final String query;

  /// 검색 중 여부
  @override
  @JsonKey()
  final bool isSearching;

  /// 검색 결과 목록
  final List<String> _searchResults;

  /// 검색 결과 목록
  @override
  @JsonKey()
  List<String> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  /// 인기 키워드
  final List<String> _popularKeywords;

  /// 인기 키워드
  @override
  @JsonKey()
  List<String> get popularKeywords {
    if (_popularKeywords is EqualUnmodifiableListView) return _popularKeywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularKeywords);
  }

  /// 선택된 카테고리 필터
  @override
  @JsonKey()
  final String selectedCategory;

  /// 선택된 신뢰도 필터
  @override
  @JsonKey()
  final String selectedTrust;

  /// 마감일 범위 필터
  @override
  @JsonKey()
  final RangeValues deadlineRange;

  @override
  String toString() {
    return 'SearchState(query: $query, isSearching: $isSearching, searchResults: $searchResults, popularKeywords: $popularKeywords, selectedCategory: $selectedCategory, selectedTrust: $selectedTrust, deadlineRange: $deadlineRange)';
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
              other._popularKeywords,
              _popularKeywords,
            ) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedTrust, selectedTrust) ||
                other.selectedTrust == selectedTrust) &&
            (identical(other.deadlineRange, deadlineRange) ||
                other.deadlineRange == deadlineRange));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    query,
    isSearching,
    const DeepCollectionEquality().hash(_searchResults),
    const DeepCollectionEquality().hash(_popularKeywords),
    selectedCategory,
    selectedTrust,
    deadlineRange,
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
    final List<String> searchResults,
    final List<String> popularKeywords,
    final String selectedCategory,
    final String selectedTrust,
    final RangeValues deadlineRange,
  }) = _$SearchStateImpl;

  /// 검색어
  @override
  String get query;

  /// 검색 중 여부
  @override
  bool get isSearching;

  /// 검색 결과 목록
  @override
  List<String> get searchResults;

  /// 인기 키워드
  @override
  List<String> get popularKeywords;

  /// 선택된 카테고리 필터
  @override
  String get selectedCategory;

  /// 선택된 신뢰도 필터
  @override
  String get selectedTrust;

  /// 마감일 범위 필터
  @override
  RangeValues get deadlineRange;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchStateImplCopyWith<_$SearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
