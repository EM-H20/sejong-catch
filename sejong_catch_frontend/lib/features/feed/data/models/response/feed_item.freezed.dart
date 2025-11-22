// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedItem _$FeedItemFromJson(Map<String, dynamic> json) {
  return _FeedItem.fromJson(json);
}

/// @nodoc
mixin _$FeedItem {
  /// 고유 ID
  String get id => throw _privateConstructorUsedError;

  /// 제목
  String get title => throw _privateConstructorUsedError;

  /// 짧은 설명 (리스트용) - Real 모드(크롤러)에서는 빈 문자열
  String get description => throw _privateConstructorUsedError;

  /// 카테고리 (공모전, 취업, 논문, 학교공지, 축제)
  String get category => throw _privateConstructorUsedError;

  /// 썸네일 이미지 URL (선택사항)
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// 게시 경과일 (양수: N일 전 게시됨)
  /// 예: 0 = 오늘, 1 = 1일 전, 7 = 1주일 전
  int get dDay => throw _privateConstructorUsedError;

  /// 조회수
  int get viewCount => throw _privateConstructorUsedError;

  /// 우선순위 (high, mid, low)
  String get priority => throw _privateConstructorUsedError;

  /// 북마크 여부
  bool get isBookmarked =>
      throw _privateConstructorUsedError; // --- 상세보기 전용 필드 ---
  /// 본문 내용 (Markdown 또는 일반 텍스트)
  String? get content => throw _privateConstructorUsedError;

  /// 주최 기관/단체
  String? get organizerName => throw _privateConstructorUsedError;

  /// 문의 이메일
  String? get contactEmail => throw _privateConstructorUsedError;

  /// 문의 전화번호
  String? get contactPhone => throw _privateConstructorUsedError;

  /// 마감일 (DateTime)
  DateTime? get deadline => throw _privateConstructorUsedError;

  /// 외부 링크 (공식 사이트, 지원 페이지 등)
  String? get externalUrl => throw _privateConstructorUsedError;

  /// 첨부파일 URL 목록
  List<String> get attachmentUrls => throw _privateConstructorUsedError;

  /// 태그 목록
  List<String> get tags => throw _privateConstructorUsedError;

  /// 생성일
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 수정일
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FeedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedItemCopyWith<FeedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedItemCopyWith<$Res> {
  factory $FeedItemCopyWith(FeedItem value, $Res Function(FeedItem) then) =
      _$FeedItemCopyWithImpl<$Res, FeedItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String? thumbnailUrl,
    int dDay,
    int viewCount,
    String priority,
    bool isBookmarked,
    String? content,
    String? organizerName,
    String? contactEmail,
    String? contactPhone,
    DateTime? deadline,
    String? externalUrl,
    List<String> attachmentUrls,
    List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$FeedItemCopyWithImpl<$Res, $Val extends FeedItem>
    implements $FeedItemCopyWith<$Res> {
  _$FeedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? thumbnailUrl = freezed,
    Object? dDay = null,
    Object? viewCount = null,
    Object? priority = null,
    Object? isBookmarked = null,
    Object? content = freezed,
    Object? organizerName = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? deadline = freezed,
    Object? externalUrl = freezed,
    Object? attachmentUrls = null,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            dDay: null == dDay
                ? _value.dDay
                : dDay // ignore: cast_nullable_to_non_nullable
                      as int,
            viewCount: null == viewCount
                ? _value.viewCount
                : viewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
            isBookmarked: null == isBookmarked
                ? _value.isBookmarked
                : isBookmarked // ignore: cast_nullable_to_non_nullable
                      as bool,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            organizerName: freezed == organizerName
                ? _value.organizerName
                : organizerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactEmail: freezed == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactPhone: freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            deadline: freezed == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            externalUrl: freezed == externalUrl
                ? _value.externalUrl
                : externalUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            attachmentUrls: null == attachmentUrls
                ? _value.attachmentUrls
                : attachmentUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedItemImplCopyWith<$Res>
    implements $FeedItemCopyWith<$Res> {
  factory _$$FeedItemImplCopyWith(
    _$FeedItemImpl value,
    $Res Function(_$FeedItemImpl) then,
  ) = __$$FeedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    String? thumbnailUrl,
    int dDay,
    int viewCount,
    String priority,
    bool isBookmarked,
    String? content,
    String? organizerName,
    String? contactEmail,
    String? contactPhone,
    DateTime? deadline,
    String? externalUrl,
    List<String> attachmentUrls,
    List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FeedItemImplCopyWithImpl<$Res>
    extends _$FeedItemCopyWithImpl<$Res, _$FeedItemImpl>
    implements _$$FeedItemImplCopyWith<$Res> {
  __$$FeedItemImplCopyWithImpl(
    _$FeedItemImpl _value,
    $Res Function(_$FeedItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? thumbnailUrl = freezed,
    Object? dDay = null,
    Object? viewCount = null,
    Object? priority = null,
    Object? isBookmarked = null,
    Object? content = freezed,
    Object? organizerName = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? deadline = freezed,
    Object? externalUrl = freezed,
    Object? attachmentUrls = null,
    Object? tags = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FeedItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        dDay: null == dDay
            ? _value.dDay
            : dDay // ignore: cast_nullable_to_non_nullable
                  as int,
        viewCount: null == viewCount
            ? _value.viewCount
            : viewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        isBookmarked: null == isBookmarked
            ? _value.isBookmarked
            : isBookmarked // ignore: cast_nullable_to_non_nullable
                  as bool,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        organizerName: freezed == organizerName
            ? _value.organizerName
            : organizerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactEmail: freezed == contactEmail
            ? _value.contactEmail
            : contactEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactPhone: freezed == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        deadline: freezed == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        externalUrl: freezed == externalUrl
            ? _value.externalUrl
            : externalUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        attachmentUrls: null == attachmentUrls
            ? _value._attachmentUrls
            : attachmentUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedItemImpl implements _FeedItem {
  const _$FeedItemImpl({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    this.thumbnailUrl,
    required this.dDay,
    this.viewCount = 0,
    this.priority = 'low',
    this.isBookmarked = false,
    this.content,
    this.organizerName,
    this.contactEmail,
    this.contactPhone,
    this.deadline,
    this.externalUrl,
    final List<String> attachmentUrls = const [],
    final List<String> tags = const [],
    this.createdAt,
    this.updatedAt,
  }) : _attachmentUrls = attachmentUrls,
       _tags = tags;

  factory _$FeedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedItemImplFromJson(json);

  /// 고유 ID
  @override
  final String id;

  /// 제목
  @override
  final String title;

  /// 짧은 설명 (리스트용) - Real 모드(크롤러)에서는 빈 문자열
  @override
  @JsonKey()
  final String description;

  /// 카테고리 (공모전, 취업, 논문, 학교공지, 축제)
  @override
  final String category;

  /// 썸네일 이미지 URL (선택사항)
  @override
  final String? thumbnailUrl;

  /// 게시 경과일 (양수: N일 전 게시됨)
  /// 예: 0 = 오늘, 1 = 1일 전, 7 = 1주일 전
  @override
  final int dDay;

  /// 조회수
  @override
  @JsonKey()
  final int viewCount;

  /// 우선순위 (high, mid, low)
  @override
  @JsonKey()
  final String priority;

  /// 북마크 여부
  @override
  @JsonKey()
  final bool isBookmarked;
  // --- 상세보기 전용 필드 ---
  /// 본문 내용 (Markdown 또는 일반 텍스트)
  @override
  final String? content;

  /// 주최 기관/단체
  @override
  final String? organizerName;

  /// 문의 이메일
  @override
  final String? contactEmail;

  /// 문의 전화번호
  @override
  final String? contactPhone;

  /// 마감일 (DateTime)
  @override
  final DateTime? deadline;

  /// 외부 링크 (공식 사이트, 지원 페이지 등)
  @override
  final String? externalUrl;

  /// 첨부파일 URL 목록
  final List<String> _attachmentUrls;

  /// 첨부파일 URL 목록
  @override
  @JsonKey()
  List<String> get attachmentUrls {
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachmentUrls);
  }

  /// 태그 목록
  final List<String> _tags;

  /// 태그 목록
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// 생성일
  @override
  final DateTime? createdAt;

  /// 수정일
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FeedItem(id: $id, title: $title, description: $description, category: $category, thumbnailUrl: $thumbnailUrl, dDay: $dDay, viewCount: $viewCount, priority: $priority, isBookmarked: $isBookmarked, content: $content, organizerName: $organizerName, contactEmail: $contactEmail, contactPhone: $contactPhone, deadline: $deadline, externalUrl: $externalUrl, attachmentUrls: $attachmentUrls, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.dDay, dDay) || other.dDay == dDay) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.isBookmarked, isBookmarked) ||
                other.isBookmarked == isBookmarked) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.organizerName, organizerName) ||
                other.organizerName == organizerName) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.externalUrl, externalUrl) ||
                other.externalUrl == externalUrl) &&
            const DeepCollectionEquality().equals(
              other._attachmentUrls,
              _attachmentUrls,
            ) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    thumbnailUrl,
    dDay,
    viewCount,
    priority,
    isBookmarked,
    content,
    organizerName,
    contactEmail,
    contactPhone,
    deadline,
    externalUrl,
    const DeepCollectionEquality().hash(_attachmentUrls),
    const DeepCollectionEquality().hash(_tags),
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of FeedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedItemImplCopyWith<_$FeedItemImpl> get copyWith =>
      __$$FeedItemImplCopyWithImpl<_$FeedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedItemImplToJson(this);
  }
}

abstract class _FeedItem implements FeedItem {
  const factory _FeedItem({
    required final String id,
    required final String title,
    final String description,
    required final String category,
    final String? thumbnailUrl,
    required final int dDay,
    final int viewCount,
    final String priority,
    final bool isBookmarked,
    final String? content,
    final String? organizerName,
    final String? contactEmail,
    final String? contactPhone,
    final DateTime? deadline,
    final String? externalUrl,
    final List<String> attachmentUrls,
    final List<String> tags,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$FeedItemImpl;

  factory _FeedItem.fromJson(Map<String, dynamic> json) =
      _$FeedItemImpl.fromJson;

  /// 고유 ID
  @override
  String get id;

  /// 제목
  @override
  String get title;

  /// 짧은 설명 (리스트용) - Real 모드(크롤러)에서는 빈 문자열
  @override
  String get description;

  /// 카테고리 (공모전, 취업, 논문, 학교공지, 축제)
  @override
  String get category;

  /// 썸네일 이미지 URL (선택사항)
  @override
  String? get thumbnailUrl;

  /// 게시 경과일 (양수: N일 전 게시됨)
  /// 예: 0 = 오늘, 1 = 1일 전, 7 = 1주일 전
  @override
  int get dDay;

  /// 조회수
  @override
  int get viewCount;

  /// 우선순위 (high, mid, low)
  @override
  String get priority;

  /// 북마크 여부
  @override
  bool get isBookmarked; // --- 상세보기 전용 필드 ---
  /// 본문 내용 (Markdown 또는 일반 텍스트)
  @override
  String? get content;

  /// 주최 기관/단체
  @override
  String? get organizerName;

  /// 문의 이메일
  @override
  String? get contactEmail;

  /// 문의 전화번호
  @override
  String? get contactPhone;

  /// 마감일 (DateTime)
  @override
  DateTime? get deadline;

  /// 외부 링크 (공식 사이트, 지원 페이지 등)
  @override
  String? get externalUrl;

  /// 첨부파일 URL 목록
  @override
  List<String> get attachmentUrls;

  /// 태그 목록
  @override
  List<String> get tags;

  /// 생성일
  @override
  DateTime? get createdAt;

  /// 수정일
  @override
  DateTime? get updatedAt;

  /// Create a copy of FeedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedItemImplCopyWith<_$FeedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
