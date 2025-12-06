// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_queue_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyQueueStatus _$MyQueueStatusFromJson(Map<String, dynamic> json) {
  return _MyQueueStatus.fromJson(json);
}

/// @nodoc
mixin _$MyQueueStatus {
  String get boothId => throw _privateConstructorUsedError;
  String get visitorId => throw _privateConstructorUsedError;
  int get ticketNo => throw _privateConstructorUsedError;
  String get state =>
      throw _privateConstructorUsedError; // WAITING | IN_SERVICE | COMPLETED | CANCELED
  int get teamsAhead => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;

  /// Serializes this MyQueueStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyQueueStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyQueueStatusCopyWith<MyQueueStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyQueueStatusCopyWith<$Res> {
  factory $MyQueueStatusCopyWith(
    MyQueueStatus value,
    $Res Function(MyQueueStatus) then,
  ) = _$MyQueueStatusCopyWithImpl<$Res, MyQueueStatus>;
  @useResult
  $Res call({
    String boothId,
    String visitorId,
    int ticketNo,
    String state,
    int teamsAhead,
    int position,
  });
}

/// @nodoc
class _$MyQueueStatusCopyWithImpl<$Res, $Val extends MyQueueStatus>
    implements $MyQueueStatusCopyWith<$Res> {
  _$MyQueueStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyQueueStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boothId = null,
    Object? visitorId = null,
    Object? ticketNo = null,
    Object? state = null,
    Object? teamsAhead = null,
    Object? position = null,
  }) {
    return _then(
      _value.copyWith(
            boothId: null == boothId
                ? _value.boothId
                : boothId // ignore: cast_nullable_to_non_nullable
                      as String,
            visitorId: null == visitorId
                ? _value.visitorId
                : visitorId // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketNo: null == ticketNo
                ? _value.ticketNo
                : ticketNo // ignore: cast_nullable_to_non_nullable
                      as int,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            teamsAhead: null == teamsAhead
                ? _value.teamsAhead
                : teamsAhead // ignore: cast_nullable_to_non_nullable
                      as int,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyQueueStatusImplCopyWith<$Res>
    implements $MyQueueStatusCopyWith<$Res> {
  factory _$$MyQueueStatusImplCopyWith(
    _$MyQueueStatusImpl value,
    $Res Function(_$MyQueueStatusImpl) then,
  ) = __$$MyQueueStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String boothId,
    String visitorId,
    int ticketNo,
    String state,
    int teamsAhead,
    int position,
  });
}

/// @nodoc
class __$$MyQueueStatusImplCopyWithImpl<$Res>
    extends _$MyQueueStatusCopyWithImpl<$Res, _$MyQueueStatusImpl>
    implements _$$MyQueueStatusImplCopyWith<$Res> {
  __$$MyQueueStatusImplCopyWithImpl(
    _$MyQueueStatusImpl _value,
    $Res Function(_$MyQueueStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyQueueStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boothId = null,
    Object? visitorId = null,
    Object? ticketNo = null,
    Object? state = null,
    Object? teamsAhead = null,
    Object? position = null,
  }) {
    return _then(
      _$MyQueueStatusImpl(
        boothId: null == boothId
            ? _value.boothId
            : boothId // ignore: cast_nullable_to_non_nullable
                  as String,
        visitorId: null == visitorId
            ? _value.visitorId
            : visitorId // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketNo: null == ticketNo
            ? _value.ticketNo
            : ticketNo // ignore: cast_nullable_to_non_nullable
                  as int,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        teamsAhead: null == teamsAhead
            ? _value.teamsAhead
            : teamsAhead // ignore: cast_nullable_to_non_nullable
                  as int,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyQueueStatusImpl implements _MyQueueStatus {
  const _$MyQueueStatusImpl({
    required this.boothId,
    required this.visitorId,
    required this.ticketNo,
    required this.state,
    required this.teamsAhead,
    required this.position,
  });

  factory _$MyQueueStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyQueueStatusImplFromJson(json);

  @override
  final String boothId;
  @override
  final String visitorId;
  @override
  final int ticketNo;
  @override
  final String state;
  // WAITING | IN_SERVICE | COMPLETED | CANCELED
  @override
  final int teamsAhead;
  @override
  final int position;

  @override
  String toString() {
    return 'MyQueueStatus(boothId: $boothId, visitorId: $visitorId, ticketNo: $ticketNo, state: $state, teamsAhead: $teamsAhead, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyQueueStatusImpl &&
            (identical(other.boothId, boothId) || other.boothId == boothId) &&
            (identical(other.visitorId, visitorId) ||
                other.visitorId == visitorId) &&
            (identical(other.ticketNo, ticketNo) ||
                other.ticketNo == ticketNo) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.teamsAhead, teamsAhead) ||
                other.teamsAhead == teamsAhead) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    boothId,
    visitorId,
    ticketNo,
    state,
    teamsAhead,
    position,
  );

  /// Create a copy of MyQueueStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyQueueStatusImplCopyWith<_$MyQueueStatusImpl> get copyWith =>
      __$$MyQueueStatusImplCopyWithImpl<_$MyQueueStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyQueueStatusImplToJson(this);
  }
}

abstract class _MyQueueStatus implements MyQueueStatus {
  const factory _MyQueueStatus({
    required final String boothId,
    required final String visitorId,
    required final int ticketNo,
    required final String state,
    required final int teamsAhead,
    required final int position,
  }) = _$MyQueueStatusImpl;

  factory _MyQueueStatus.fromJson(Map<String, dynamic> json) =
      _$MyQueueStatusImpl.fromJson;

  @override
  String get boothId;
  @override
  String get visitorId;
  @override
  int get ticketNo;
  @override
  String get state; // WAITING | IN_SERVICE | COMPLETED | CANCELED
  @override
  int get teamsAhead;
  @override
  int get position;

  /// Create a copy of MyQueueStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyQueueStatusImplCopyWith<_$MyQueueStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
