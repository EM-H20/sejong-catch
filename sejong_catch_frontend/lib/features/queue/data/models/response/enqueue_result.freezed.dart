// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enqueue_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EnqueueResult _$EnqueueResultFromJson(Map<String, dynamic> json) {
  return _EnqueueResult.fromJson(json);
}

/// @nodoc
mixin _$EnqueueResult {
  String get mode => throw _privateConstructorUsedError; // IN_SERVICE | WAITING
  int get remainingSeats => throw _privateConstructorUsedError;
  QueueEntry get entry => throw _privateConstructorUsedError;

  /// Serializes this EnqueueResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnqueueResultCopyWith<EnqueueResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnqueueResultCopyWith<$Res> {
  factory $EnqueueResultCopyWith(
    EnqueueResult value,
    $Res Function(EnqueueResult) then,
  ) = _$EnqueueResultCopyWithImpl<$Res, EnqueueResult>;
  @useResult
  $Res call({String mode, int remainingSeats, QueueEntry entry});

  $QueueEntryCopyWith<$Res> get entry;
}

/// @nodoc
class _$EnqueueResultCopyWithImpl<$Res, $Val extends EnqueueResult>
    implements $EnqueueResultCopyWith<$Res> {
  _$EnqueueResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? remainingSeats = null,
    Object? entry = null,
  }) {
    return _then(
      _value.copyWith(
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as String,
            remainingSeats: null == remainingSeats
                ? _value.remainingSeats
                : remainingSeats // ignore: cast_nullable_to_non_nullable
                      as int,
            entry: null == entry
                ? _value.entry
                : entry // ignore: cast_nullable_to_non_nullable
                      as QueueEntry,
          )
          as $Val,
    );
  }

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueueEntryCopyWith<$Res> get entry {
    return $QueueEntryCopyWith<$Res>(_value.entry, (value) {
      return _then(_value.copyWith(entry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EnqueueResultImplCopyWith<$Res>
    implements $EnqueueResultCopyWith<$Res> {
  factory _$$EnqueueResultImplCopyWith(
    _$EnqueueResultImpl value,
    $Res Function(_$EnqueueResultImpl) then,
  ) = __$$EnqueueResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mode, int remainingSeats, QueueEntry entry});

  @override
  $QueueEntryCopyWith<$Res> get entry;
}

/// @nodoc
class __$$EnqueueResultImplCopyWithImpl<$Res>
    extends _$EnqueueResultCopyWithImpl<$Res, _$EnqueueResultImpl>
    implements _$$EnqueueResultImplCopyWith<$Res> {
  __$$EnqueueResultImplCopyWithImpl(
    _$EnqueueResultImpl _value,
    $Res Function(_$EnqueueResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? remainingSeats = null,
    Object? entry = null,
  }) {
    return _then(
      _$EnqueueResultImpl(
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        remainingSeats: null == remainingSeats
            ? _value.remainingSeats
            : remainingSeats // ignore: cast_nullable_to_non_nullable
                  as int,
        entry: null == entry
            ? _value.entry
            : entry // ignore: cast_nullable_to_non_nullable
                  as QueueEntry,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnqueueResultImpl implements _EnqueueResult {
  const _$EnqueueResultImpl({
    required this.mode,
    required this.remainingSeats,
    required this.entry,
  });

  factory _$EnqueueResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnqueueResultImplFromJson(json);

  @override
  final String mode;
  // IN_SERVICE | WAITING
  @override
  final int remainingSeats;
  @override
  final QueueEntry entry;

  @override
  String toString() {
    return 'EnqueueResult(mode: $mode, remainingSeats: $remainingSeats, entry: $entry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnqueueResultImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.remainingSeats, remainingSeats) ||
                other.remainingSeats == remainingSeats) &&
            (identical(other.entry, entry) || other.entry == entry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mode, remainingSeats, entry);

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnqueueResultImplCopyWith<_$EnqueueResultImpl> get copyWith =>
      __$$EnqueueResultImplCopyWithImpl<_$EnqueueResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnqueueResultImplToJson(this);
  }
}

abstract class _EnqueueResult implements EnqueueResult {
  const factory _EnqueueResult({
    required final String mode,
    required final int remainingSeats,
    required final QueueEntry entry,
  }) = _$EnqueueResultImpl;

  factory _EnqueueResult.fromJson(Map<String, dynamic> json) =
      _$EnqueueResultImpl.fromJson;

  @override
  String get mode; // IN_SERVICE | WAITING
  @override
  int get remainingSeats;
  @override
  QueueEntry get entry;

  /// Create a copy of EnqueueResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnqueueResultImplCopyWith<_$EnqueueResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
