// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booth _$BoothFromJson(Map<String, dynamic> json) {
  return _Booth.fromJson(json);
}

/// @nodoc
mixin _$Booth {
  String get id => throw _privateConstructorUsedError;
  String get masterId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get seatCount => throw _privateConstructorUsedError;
  int get avgWaitMinutes => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // PREPARING | OPERATING | ENDED
  @FlexibleDateTimeConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @FlexibleDateTimeConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Booth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoothCopyWith<Booth> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoothCopyWith<$Res> {
  factory $BoothCopyWith(Booth value, $Res Function(Booth) then) =
      _$BoothCopyWithImpl<$Res, Booth>;
  @useResult
  $Res call({
    String id,
    String masterId,
    String title,
    int seatCount,
    int avgWaitMinutes,
    String status,
    @FlexibleDateTimeConverter() DateTime createdAt,
    @FlexibleDateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$BoothCopyWithImpl<$Res, $Val extends Booth>
    implements $BoothCopyWith<$Res> {
  _$BoothCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? title = null,
    Object? seatCount = null,
    Object? avgWaitMinutes = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            masterId: null == masterId
                ? _value.masterId
                : masterId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            seatCount: null == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            avgWaitMinutes: null == avgWaitMinutes
                ? _value.avgWaitMinutes
                : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoothImplCopyWith<$Res> implements $BoothCopyWith<$Res> {
  factory _$$BoothImplCopyWith(
    _$BoothImpl value,
    $Res Function(_$BoothImpl) then,
  ) = __$$BoothImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String masterId,
    String title,
    int seatCount,
    int avgWaitMinutes,
    String status,
    @FlexibleDateTimeConverter() DateTime createdAt,
    @FlexibleDateTimeConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$BoothImplCopyWithImpl<$Res>
    extends _$BoothCopyWithImpl<$Res, _$BoothImpl>
    implements _$$BoothImplCopyWith<$Res> {
  __$$BoothImplCopyWithImpl(
    _$BoothImpl _value,
    $Res Function(_$BoothImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? masterId = null,
    Object? title = null,
    Object? seatCount = null,
    Object? avgWaitMinutes = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BoothImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        masterId: null == masterId
            ? _value.masterId
            : masterId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        seatCount: null == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        avgWaitMinutes: null == avgWaitMinutes
            ? _value.avgWaitMinutes
            : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoothImpl implements _Booth {
  const _$BoothImpl({
    required this.id,
    required this.masterId,
    required this.title,
    required this.seatCount,
    required this.avgWaitMinutes,
    required this.status,
    @FlexibleDateTimeConverter() required this.createdAt,
    @FlexibleDateTimeConverter() required this.updatedAt,
  });

  factory _$BoothImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoothImplFromJson(json);

  @override
  final String id;
  @override
  final String masterId;
  @override
  final String title;
  @override
  final int seatCount;
  @override
  final int avgWaitMinutes;
  @override
  final String status;
  // PREPARING | OPERATING | ENDED
  @override
  @FlexibleDateTimeConverter()
  final DateTime createdAt;
  @override
  @FlexibleDateTimeConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Booth(id: $id, masterId: $masterId, title: $title, seatCount: $seatCount, avgWaitMinutes: $avgWaitMinutes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoothImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.avgWaitMinutes, avgWaitMinutes) ||
                other.avgWaitMinutes == avgWaitMinutes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    masterId,
    title,
    seatCount,
    avgWaitMinutes,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Booth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoothImplCopyWith<_$BoothImpl> get copyWith =>
      __$$BoothImplCopyWithImpl<_$BoothImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoothImplToJson(this);
  }
}

abstract class _Booth implements Booth {
  const factory _Booth({
    required final String id,
    required final String masterId,
    required final String title,
    required final int seatCount,
    required final int avgWaitMinutes,
    required final String status,
    @FlexibleDateTimeConverter() required final DateTime createdAt,
    @FlexibleDateTimeConverter() required final DateTime updatedAt,
  }) = _$BoothImpl;

  factory _Booth.fromJson(Map<String, dynamic> json) = _$BoothImpl.fromJson;

  @override
  String get id;
  @override
  String get masterId;
  @override
  String get title;
  @override
  int get seatCount;
  @override
  int get avgWaitMinutes;
  @override
  String get status; // PREPARING | OPERATING | ENDED
  @override
  @FlexibleDateTimeConverter()
  DateTime get createdAt;
  @override
  @FlexibleDateTimeConverter()
  DateTime get updatedAt;

  /// Create a copy of Booth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoothImplCopyWith<_$BoothImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
