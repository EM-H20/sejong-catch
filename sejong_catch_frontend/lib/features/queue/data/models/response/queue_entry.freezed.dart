// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueueEntry _$QueueEntryFromJson(Map<String, dynamic> json) {
  return _QueueEntry.fromJson(json);
}

/// @nodoc
mixin _$QueueEntry {
  String get id => throw _privateConstructorUsedError;
  String get boothId => throw _privateConstructorUsedError;
  String? get visitorId =>
      throw _privateConstructorUsedError; // nullable: 서버에서 null일 수 있음
  int get ticketNo => throw _privateConstructorUsedError;
  String get state =>
      throw _privateConstructorUsedError; // WAITING | IN_SERVICE | COMPLETED | CANCELED
  @FlexibleDateTimeConverter()
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this QueueEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueEntryCopyWith<QueueEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueEntryCopyWith<$Res> {
  factory $QueueEntryCopyWith(
    QueueEntry value,
    $Res Function(QueueEntry) then,
  ) = _$QueueEntryCopyWithImpl<$Res, QueueEntry>;
  @useResult
  $Res call({
    String id,
    String boothId,
    String? visitorId,
    int ticketNo,
    String state,
    @FlexibleDateTimeConverter() DateTime joinedAt,
  });
}

/// @nodoc
class _$QueueEntryCopyWithImpl<$Res, $Val extends QueueEntry>
    implements $QueueEntryCopyWith<$Res> {
  _$QueueEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boothId = null,
    Object? visitorId = freezed,
    Object? ticketNo = null,
    Object? state = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            boothId: null == boothId
                ? _value.boothId
                : boothId // ignore: cast_nullable_to_non_nullable
                      as String,
            visitorId: freezed == visitorId
                ? _value.visitorId
                : visitorId // ignore: cast_nullable_to_non_nullable
                      as String?,
            ticketNo: null == ticketNo
                ? _value.ticketNo
                : ticketNo // ignore: cast_nullable_to_non_nullable
                      as int,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QueueEntryImplCopyWith<$Res>
    implements $QueueEntryCopyWith<$Res> {
  factory _$$QueueEntryImplCopyWith(
    _$QueueEntryImpl value,
    $Res Function(_$QueueEntryImpl) then,
  ) = __$$QueueEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String boothId,
    String? visitorId,
    int ticketNo,
    String state,
    @FlexibleDateTimeConverter() DateTime joinedAt,
  });
}

/// @nodoc
class __$$QueueEntryImplCopyWithImpl<$Res>
    extends _$QueueEntryCopyWithImpl<$Res, _$QueueEntryImpl>
    implements _$$QueueEntryImplCopyWith<$Res> {
  __$$QueueEntryImplCopyWithImpl(
    _$QueueEntryImpl _value,
    $Res Function(_$QueueEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boothId = null,
    Object? visitorId = freezed,
    Object? ticketNo = null,
    Object? state = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$QueueEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        boothId: null == boothId
            ? _value.boothId
            : boothId // ignore: cast_nullable_to_non_nullable
                  as String,
        visitorId: freezed == visitorId
            ? _value.visitorId
            : visitorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ticketNo: null == ticketNo
            ? _value.ticketNo
            : ticketNo // ignore: cast_nullable_to_non_nullable
                  as int,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueueEntryImpl implements _QueueEntry {
  const _$QueueEntryImpl({
    required this.id,
    required this.boothId,
    this.visitorId,
    required this.ticketNo,
    this.state = 'WAITING',
    @FlexibleDateTimeConverter() required this.joinedAt,
  });

  factory _$QueueEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueueEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String boothId;
  @override
  final String? visitorId;
  // nullable: 서버에서 null일 수 있음
  @override
  final int ticketNo;
  @override
  @JsonKey()
  final String state;
  // WAITING | IN_SERVICE | COMPLETED | CANCELED
  @override
  @FlexibleDateTimeConverter()
  final DateTime joinedAt;

  @override
  String toString() {
    return 'QueueEntry(id: $id, boothId: $boothId, visitorId: $visitorId, ticketNo: $ticketNo, state: $state, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boothId, boothId) || other.boothId == boothId) &&
            (identical(other.visitorId, visitorId) ||
                other.visitorId == visitorId) &&
            (identical(other.ticketNo, ticketNo) ||
                other.ticketNo == ticketNo) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    boothId,
    visitorId,
    ticketNo,
    state,
    joinedAt,
  );

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueEntryImplCopyWith<_$QueueEntryImpl> get copyWith =>
      __$$QueueEntryImplCopyWithImpl<_$QueueEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueueEntryImplToJson(this);
  }
}

abstract class _QueueEntry implements QueueEntry {
  const factory _QueueEntry({
    required final String id,
    required final String boothId,
    final String? visitorId,
    required final int ticketNo,
    final String state,
    @FlexibleDateTimeConverter() required final DateTime joinedAt,
  }) = _$QueueEntryImpl;

  factory _QueueEntry.fromJson(Map<String, dynamic> json) =
      _$QueueEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get boothId;
  @override
  String? get visitorId; // nullable: 서버에서 null일 수 있음
  @override
  int get ticketNo;
  @override
  String get state; // WAITING | IN_SERVICE | COMPLETED | CANCELED
  @override
  @FlexibleDateTimeConverter()
  DateTime get joinedAt;

  /// Create a copy of QueueEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueEntryImplCopyWith<_$QueueEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
