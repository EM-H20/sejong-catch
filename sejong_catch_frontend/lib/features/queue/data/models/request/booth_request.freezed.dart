// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateBoothRequest _$CreateBoothRequestFromJson(Map<String, dynamic> json) {
  return _CreateBoothRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBoothRequest {
  String get masterId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int? get seatCount => throw _privateConstructorUsedError;
  int? get avgWaitMinutes => throw _privateConstructorUsedError;

  /// Serializes this CreateBoothRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBoothRequestCopyWith<CreateBoothRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBoothRequestCopyWith<$Res> {
  factory $CreateBoothRequestCopyWith(
    CreateBoothRequest value,
    $Res Function(CreateBoothRequest) then,
  ) = _$CreateBoothRequestCopyWithImpl<$Res, CreateBoothRequest>;
  @useResult
  $Res call({
    String masterId,
    String title,
    int? seatCount,
    int? avgWaitMinutes,
  });
}

/// @nodoc
class _$CreateBoothRequestCopyWithImpl<$Res, $Val extends CreateBoothRequest>
    implements $CreateBoothRequestCopyWith<$Res> {
  _$CreateBoothRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? title = null,
    Object? seatCount = freezed,
    Object? avgWaitMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            masterId: null == masterId
                ? _value.masterId
                : masterId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            seatCount: freezed == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            avgWaitMinutes: freezed == avgWaitMinutes
                ? _value.avgWaitMinutes
                : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateBoothRequestImplCopyWith<$Res>
    implements $CreateBoothRequestCopyWith<$Res> {
  factory _$$CreateBoothRequestImplCopyWith(
    _$CreateBoothRequestImpl value,
    $Res Function(_$CreateBoothRequestImpl) then,
  ) = __$$CreateBoothRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String masterId,
    String title,
    int? seatCount,
    int? avgWaitMinutes,
  });
}

/// @nodoc
class __$$CreateBoothRequestImplCopyWithImpl<$Res>
    extends _$CreateBoothRequestCopyWithImpl<$Res, _$CreateBoothRequestImpl>
    implements _$$CreateBoothRequestImplCopyWith<$Res> {
  __$$CreateBoothRequestImplCopyWithImpl(
    _$CreateBoothRequestImpl _value,
    $Res Function(_$CreateBoothRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterId = null,
    Object? title = null,
    Object? seatCount = freezed,
    Object? avgWaitMinutes = freezed,
  }) {
    return _then(
      _$CreateBoothRequestImpl(
        masterId: null == masterId
            ? _value.masterId
            : masterId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        seatCount: freezed == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        avgWaitMinutes: freezed == avgWaitMinutes
            ? _value.avgWaitMinutes
            : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBoothRequestImpl implements _CreateBoothRequest {
  const _$CreateBoothRequestImpl({
    required this.masterId,
    required this.title,
    this.seatCount,
    this.avgWaitMinutes,
  });

  factory _$CreateBoothRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBoothRequestImplFromJson(json);

  @override
  final String masterId;
  @override
  final String title;
  @override
  final int? seatCount;
  @override
  final int? avgWaitMinutes;

  @override
  String toString() {
    return 'CreateBoothRequest(masterId: $masterId, title: $title, seatCount: $seatCount, avgWaitMinutes: $avgWaitMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBoothRequestImpl &&
            (identical(other.masterId, masterId) ||
                other.masterId == masterId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.avgWaitMinutes, avgWaitMinutes) ||
                other.avgWaitMinutes == avgWaitMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, masterId, title, seatCount, avgWaitMinutes);

  /// Create a copy of CreateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBoothRequestImplCopyWith<_$CreateBoothRequestImpl> get copyWith =>
      __$$CreateBoothRequestImplCopyWithImpl<_$CreateBoothRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBoothRequestImplToJson(this);
  }
}

abstract class _CreateBoothRequest implements CreateBoothRequest {
  const factory _CreateBoothRequest({
    required final String masterId,
    required final String title,
    final int? seatCount,
    final int? avgWaitMinutes,
  }) = _$CreateBoothRequestImpl;

  factory _CreateBoothRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBoothRequestImpl.fromJson;

  @override
  String get masterId;
  @override
  String get title;
  @override
  int? get seatCount;
  @override
  int? get avgWaitMinutes;

  /// Create a copy of CreateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBoothRequestImplCopyWith<_$CreateBoothRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateBoothRequest _$UpdateBoothRequestFromJson(Map<String, dynamic> json) {
  return _UpdateBoothRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateBoothRequest {
  String? get title => throw _privateConstructorUsedError;
  int? get seatCount => throw _privateConstructorUsedError;
  int? get avgWaitMinutes => throw _privateConstructorUsedError;

  /// Serializes this UpdateBoothRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateBoothRequestCopyWith<UpdateBoothRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateBoothRequestCopyWith<$Res> {
  factory $UpdateBoothRequestCopyWith(
    UpdateBoothRequest value,
    $Res Function(UpdateBoothRequest) then,
  ) = _$UpdateBoothRequestCopyWithImpl<$Res, UpdateBoothRequest>;
  @useResult
  $Res call({String? title, int? seatCount, int? avgWaitMinutes});
}

/// @nodoc
class _$UpdateBoothRequestCopyWithImpl<$Res, $Val extends UpdateBoothRequest>
    implements $UpdateBoothRequestCopyWith<$Res> {
  _$UpdateBoothRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? seatCount = freezed,
    Object? avgWaitMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            seatCount: freezed == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            avgWaitMinutes: freezed == avgWaitMinutes
                ? _value.avgWaitMinutes
                : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateBoothRequestImplCopyWith<$Res>
    implements $UpdateBoothRequestCopyWith<$Res> {
  factory _$$UpdateBoothRequestImplCopyWith(
    _$UpdateBoothRequestImpl value,
    $Res Function(_$UpdateBoothRequestImpl) then,
  ) = __$$UpdateBoothRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, int? seatCount, int? avgWaitMinutes});
}

/// @nodoc
class __$$UpdateBoothRequestImplCopyWithImpl<$Res>
    extends _$UpdateBoothRequestCopyWithImpl<$Res, _$UpdateBoothRequestImpl>
    implements _$$UpdateBoothRequestImplCopyWith<$Res> {
  __$$UpdateBoothRequestImplCopyWithImpl(
    _$UpdateBoothRequestImpl _value,
    $Res Function(_$UpdateBoothRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? seatCount = freezed,
    Object? avgWaitMinutes = freezed,
  }) {
    return _then(
      _$UpdateBoothRequestImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        seatCount: freezed == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        avgWaitMinutes: freezed == avgWaitMinutes
            ? _value.avgWaitMinutes
            : avgWaitMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateBoothRequestImpl implements _UpdateBoothRequest {
  const _$UpdateBoothRequestImpl({
    this.title,
    this.seatCount,
    this.avgWaitMinutes,
  });

  factory _$UpdateBoothRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateBoothRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final int? seatCount;
  @override
  final int? avgWaitMinutes;

  @override
  String toString() {
    return 'UpdateBoothRequest(title: $title, seatCount: $seatCount, avgWaitMinutes: $avgWaitMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBoothRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.avgWaitMinutes, avgWaitMinutes) ||
                other.avgWaitMinutes == avgWaitMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, title, seatCount, avgWaitMinutes);

  /// Create a copy of UpdateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBoothRequestImplCopyWith<_$UpdateBoothRequestImpl> get copyWith =>
      __$$UpdateBoothRequestImplCopyWithImpl<_$UpdateBoothRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateBoothRequestImplToJson(this);
  }
}

abstract class _UpdateBoothRequest implements UpdateBoothRequest {
  const factory _UpdateBoothRequest({
    final String? title,
    final int? seatCount,
    final int? avgWaitMinutes,
  }) = _$UpdateBoothRequestImpl;

  factory _UpdateBoothRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateBoothRequestImpl.fromJson;

  @override
  String? get title;
  @override
  int? get seatCount;
  @override
  int? get avgWaitMinutes;

  /// Create a copy of UpdateBoothRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBoothRequestImplCopyWith<_$UpdateBoothRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateBoothStatusRequest _$UpdateBoothStatusRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateBoothStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateBoothStatusRequest {
  String get status => throw _privateConstructorUsedError;

  /// Serializes this UpdateBoothStatusRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateBoothStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateBoothStatusRequestCopyWith<UpdateBoothStatusRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateBoothStatusRequestCopyWith<$Res> {
  factory $UpdateBoothStatusRequestCopyWith(
    UpdateBoothStatusRequest value,
    $Res Function(UpdateBoothStatusRequest) then,
  ) = _$UpdateBoothStatusRequestCopyWithImpl<$Res, UpdateBoothStatusRequest>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$UpdateBoothStatusRequestCopyWithImpl<
  $Res,
  $Val extends UpdateBoothStatusRequest
>
    implements $UpdateBoothStatusRequestCopyWith<$Res> {
  _$UpdateBoothStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateBoothStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateBoothStatusRequestImplCopyWith<$Res>
    implements $UpdateBoothStatusRequestCopyWith<$Res> {
  factory _$$UpdateBoothStatusRequestImplCopyWith(
    _$UpdateBoothStatusRequestImpl value,
    $Res Function(_$UpdateBoothStatusRequestImpl) then,
  ) = __$$UpdateBoothStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$UpdateBoothStatusRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateBoothStatusRequestCopyWithImpl<
          $Res,
          _$UpdateBoothStatusRequestImpl
        >
    implements _$$UpdateBoothStatusRequestImplCopyWith<$Res> {
  __$$UpdateBoothStatusRequestImplCopyWithImpl(
    _$UpdateBoothStatusRequestImpl _value,
    $Res Function(_$UpdateBoothStatusRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateBoothStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$UpdateBoothStatusRequestImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateBoothStatusRequestImpl implements _UpdateBoothStatusRequest {
  const _$UpdateBoothStatusRequestImpl({required this.status});

  factory _$UpdateBoothStatusRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateBoothStatusRequestImplFromJson(json);

  @override
  final String status;

  @override
  String toString() {
    return 'UpdateBoothStatusRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBoothStatusRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UpdateBoothStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBoothStatusRequestImplCopyWith<_$UpdateBoothStatusRequestImpl>
  get copyWith =>
      __$$UpdateBoothStatusRequestImplCopyWithImpl<
        _$UpdateBoothStatusRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateBoothStatusRequestImplToJson(this);
  }
}

abstract class _UpdateBoothStatusRequest implements UpdateBoothStatusRequest {
  const factory _UpdateBoothStatusRequest({required final String status}) =
      _$UpdateBoothStatusRequestImpl;

  factory _UpdateBoothStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateBoothStatusRequestImpl.fromJson;

  @override
  String get status;

  /// Create a copy of UpdateBoothStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBoothStatusRequestImplCopyWith<_$UpdateBoothStatusRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
