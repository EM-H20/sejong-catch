// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crawler_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CrawlerResultsResponse _$CrawlerResultsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _CrawlerResultsResponse.fromJson(json);
}

/// @nodoc
mixin _$CrawlerResultsResponse {
  List<CrawlerResult> get data => throw _privateConstructorUsedError;

  /// Serializes this CrawlerResultsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CrawlerResultsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CrawlerResultsResponseCopyWith<CrawlerResultsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrawlerResultsResponseCopyWith<$Res> {
  factory $CrawlerResultsResponseCopyWith(
    CrawlerResultsResponse value,
    $Res Function(CrawlerResultsResponse) then,
  ) = _$CrawlerResultsResponseCopyWithImpl<$Res, CrawlerResultsResponse>;
  @useResult
  $Res call({List<CrawlerResult> data});
}

/// @nodoc
class _$CrawlerResultsResponseCopyWithImpl<
  $Res,
  $Val extends CrawlerResultsResponse
>
    implements $CrawlerResultsResponseCopyWith<$Res> {
  _$CrawlerResultsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CrawlerResultsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<CrawlerResult>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CrawlerResultsResponseImplCopyWith<$Res>
    implements $CrawlerResultsResponseCopyWith<$Res> {
  factory _$$CrawlerResultsResponseImplCopyWith(
    _$CrawlerResultsResponseImpl value,
    $Res Function(_$CrawlerResultsResponseImpl) then,
  ) = __$$CrawlerResultsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CrawlerResult> data});
}

/// @nodoc
class __$$CrawlerResultsResponseImplCopyWithImpl<$Res>
    extends
        _$CrawlerResultsResponseCopyWithImpl<$Res, _$CrawlerResultsResponseImpl>
    implements _$$CrawlerResultsResponseImplCopyWith<$Res> {
  __$$CrawlerResultsResponseImplCopyWithImpl(
    _$CrawlerResultsResponseImpl _value,
    $Res Function(_$CrawlerResultsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CrawlerResultsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$CrawlerResultsResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<CrawlerResult>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CrawlerResultsResponseImpl implements _CrawlerResultsResponse {
  const _$CrawlerResultsResponseImpl({required final List<CrawlerResult> data})
    : _data = data;

  factory _$CrawlerResultsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrawlerResultsResponseImplFromJson(json);

  final List<CrawlerResult> _data;
  @override
  List<CrawlerResult> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'CrawlerResultsResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrawlerResultsResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of CrawlerResultsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CrawlerResultsResponseImplCopyWith<_$CrawlerResultsResponseImpl>
  get copyWith =>
      __$$CrawlerResultsResponseImplCopyWithImpl<_$CrawlerResultsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CrawlerResultsResponseImplToJson(this);
  }
}

abstract class _CrawlerResultsResponse implements CrawlerResultsResponse {
  const factory _CrawlerResultsResponse({
    required final List<CrawlerResult> data,
  }) = _$CrawlerResultsResponseImpl;

  factory _CrawlerResultsResponse.fromJson(Map<String, dynamic> json) =
      _$CrawlerResultsResponseImpl.fromJson;

  @override
  List<CrawlerResult> get data;

  /// Create a copy of CrawlerResultsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CrawlerResultsResponseImplCopyWith<_$CrawlerResultsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CrawlerResult _$CrawlerResultFromJson(Map<String, dynamic> json) {
  return _CrawlerResult.fromJson(json);
}

/// @nodoc
mixin _$CrawlerResult {
  String get id => throw _privateConstructorUsedError;
  String get noticeKey => throw _privateConstructorUsedError;
  String get articleNo => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get views => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;

  /// Serializes this CrawlerResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CrawlerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CrawlerResultCopyWith<CrawlerResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CrawlerResultCopyWith<$Res> {
  factory $CrawlerResultCopyWith(
    CrawlerResult value,
    $Res Function(CrawlerResult) then,
  ) = _$CrawlerResultCopyWithImpl<$Res, CrawlerResult>;
  @useResult
  $Res call({
    String id,
    String noticeKey,
    String articleNo,
    String title,
    String url,
    String category,
    int views,
    DateTime publishedAt,
  });
}

/// @nodoc
class _$CrawlerResultCopyWithImpl<$Res, $Val extends CrawlerResult>
    implements $CrawlerResultCopyWith<$Res> {
  _$CrawlerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CrawlerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noticeKey = null,
    Object? articleNo = null,
    Object? title = null,
    Object? url = null,
    Object? category = null,
    Object? views = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            noticeKey: null == noticeKey
                ? _value.noticeKey
                : noticeKey // ignore: cast_nullable_to_non_nullable
                      as String,
            articleNo: null == articleNo
                ? _value.articleNo
                : articleNo // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            views: null == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as int,
            publishedAt: null == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CrawlerResultImplCopyWith<$Res>
    implements $CrawlerResultCopyWith<$Res> {
  factory _$$CrawlerResultImplCopyWith(
    _$CrawlerResultImpl value,
    $Res Function(_$CrawlerResultImpl) then,
  ) = __$$CrawlerResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String noticeKey,
    String articleNo,
    String title,
    String url,
    String category,
    int views,
    DateTime publishedAt,
  });
}

/// @nodoc
class __$$CrawlerResultImplCopyWithImpl<$Res>
    extends _$CrawlerResultCopyWithImpl<$Res, _$CrawlerResultImpl>
    implements _$$CrawlerResultImplCopyWith<$Res> {
  __$$CrawlerResultImplCopyWithImpl(
    _$CrawlerResultImpl _value,
    $Res Function(_$CrawlerResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CrawlerResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? noticeKey = null,
    Object? articleNo = null,
    Object? title = null,
    Object? url = null,
    Object? category = null,
    Object? views = null,
    Object? publishedAt = null,
  }) {
    return _then(
      _$CrawlerResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        noticeKey: null == noticeKey
            ? _value.noticeKey
            : noticeKey // ignore: cast_nullable_to_non_nullable
                  as String,
        articleNo: null == articleNo
            ? _value.articleNo
            : articleNo // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        views: null == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as int,
        publishedAt: null == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CrawlerResultImpl implements _CrawlerResult {
  const _$CrawlerResultImpl({
    required this.id,
    required this.noticeKey,
    required this.articleNo,
    required this.title,
    required this.url,
    required this.category,
    required this.views,
    required this.publishedAt,
  });

  factory _$CrawlerResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$CrawlerResultImplFromJson(json);

  @override
  final String id;
  @override
  final String noticeKey;
  @override
  final String articleNo;
  @override
  final String title;
  @override
  final String url;
  @override
  final String category;
  @override
  final int views;
  @override
  final DateTime publishedAt;

  @override
  String toString() {
    return 'CrawlerResult(id: $id, noticeKey: $noticeKey, articleNo: $articleNo, title: $title, url: $url, category: $category, views: $views, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CrawlerResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.noticeKey, noticeKey) ||
                other.noticeKey == noticeKey) &&
            (identical(other.articleNo, articleNo) ||
                other.articleNo == articleNo) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    noticeKey,
    articleNo,
    title,
    url,
    category,
    views,
    publishedAt,
  );

  /// Create a copy of CrawlerResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CrawlerResultImplCopyWith<_$CrawlerResultImpl> get copyWith =>
      __$$CrawlerResultImplCopyWithImpl<_$CrawlerResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CrawlerResultImplToJson(this);
  }
}

abstract class _CrawlerResult implements CrawlerResult {
  const factory _CrawlerResult({
    required final String id,
    required final String noticeKey,
    required final String articleNo,
    required final String title,
    required final String url,
    required final String category,
    required final int views,
    required final DateTime publishedAt,
  }) = _$CrawlerResultImpl;

  factory _CrawlerResult.fromJson(Map<String, dynamic> json) =
      _$CrawlerResultImpl.fromJson;

  @override
  String get id;
  @override
  String get noticeKey;
  @override
  String get articleNo;
  @override
  String get title;
  @override
  String get url;
  @override
  String get category;
  @override
  int get views;
  @override
  DateTime get publishedAt;

  /// Create a copy of CrawlerResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CrawlerResultImplCopyWith<_$CrawlerResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
