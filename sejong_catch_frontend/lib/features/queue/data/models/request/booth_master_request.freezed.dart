// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booth_master_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateBoothMasterRequest _$CreateBoothMasterRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateBoothMasterRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBoothMasterRequest {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CreateBoothMasterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBoothMasterRequestCopyWith<CreateBoothMasterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBoothMasterRequestCopyWith<$Res> {
  factory $CreateBoothMasterRequestCopyWith(
    CreateBoothMasterRequest value,
    $Res Function(CreateBoothMasterRequest) then,
  ) = _$CreateBoothMasterRequestCopyWithImpl<$Res, CreateBoothMasterRequest>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$CreateBoothMasterRequestCopyWithImpl<
  $Res,
  $Val extends CreateBoothMasterRequest
>
    implements $CreateBoothMasterRequestCopyWith<$Res> {
  _$CreateBoothMasterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateBoothMasterRequestImplCopyWith<$Res>
    implements $CreateBoothMasterRequestCopyWith<$Res> {
  factory _$$CreateBoothMasterRequestImplCopyWith(
    _$CreateBoothMasterRequestImpl value,
    $Res Function(_$CreateBoothMasterRequestImpl) then,
  ) = __$$CreateBoothMasterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$CreateBoothMasterRequestImplCopyWithImpl<$Res>
    extends
        _$CreateBoothMasterRequestCopyWithImpl<
          $Res,
          _$CreateBoothMasterRequestImpl
        >
    implements _$$CreateBoothMasterRequestImplCopyWith<$Res> {
  __$$CreateBoothMasterRequestImplCopyWithImpl(
    _$CreateBoothMasterRequestImpl _value,
    $Res Function(_$CreateBoothMasterRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$CreateBoothMasterRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBoothMasterRequestImpl implements _CreateBoothMasterRequest {
  const _$CreateBoothMasterRequestImpl({required this.name});

  factory _$CreateBoothMasterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBoothMasterRequestImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'CreateBoothMasterRequest(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBoothMasterRequestImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of CreateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBoothMasterRequestImplCopyWith<_$CreateBoothMasterRequestImpl>
  get copyWith =>
      __$$CreateBoothMasterRequestImplCopyWithImpl<
        _$CreateBoothMasterRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBoothMasterRequestImplToJson(this);
  }
}

abstract class _CreateBoothMasterRequest implements CreateBoothMasterRequest {
  const factory _CreateBoothMasterRequest({required final String name}) =
      _$CreateBoothMasterRequestImpl;

  factory _CreateBoothMasterRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBoothMasterRequestImpl.fromJson;

  @override
  String get name;

  /// Create a copy of CreateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBoothMasterRequestImplCopyWith<_$CreateBoothMasterRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateBoothMasterRequest _$UpdateBoothMasterRequestFromJson(
  Map<String, dynamic> json,
) {
  return _UpdateBoothMasterRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateBoothMasterRequest {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this UpdateBoothMasterRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateBoothMasterRequestCopyWith<UpdateBoothMasterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateBoothMasterRequestCopyWith<$Res> {
  factory $UpdateBoothMasterRequestCopyWith(
    UpdateBoothMasterRequest value,
    $Res Function(UpdateBoothMasterRequest) then,
  ) = _$UpdateBoothMasterRequestCopyWithImpl<$Res, UpdateBoothMasterRequest>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$UpdateBoothMasterRequestCopyWithImpl<
  $Res,
  $Val extends UpdateBoothMasterRequest
>
    implements $UpdateBoothMasterRequestCopyWith<$Res> {
  _$UpdateBoothMasterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateBoothMasterRequestImplCopyWith<$Res>
    implements $UpdateBoothMasterRequestCopyWith<$Res> {
  factory _$$UpdateBoothMasterRequestImplCopyWith(
    _$UpdateBoothMasterRequestImpl value,
    $Res Function(_$UpdateBoothMasterRequestImpl) then,
  ) = __$$UpdateBoothMasterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$UpdateBoothMasterRequestImplCopyWithImpl<$Res>
    extends
        _$UpdateBoothMasterRequestCopyWithImpl<
          $Res,
          _$UpdateBoothMasterRequestImpl
        >
    implements _$$UpdateBoothMasterRequestImplCopyWith<$Res> {
  __$$UpdateBoothMasterRequestImplCopyWithImpl(
    _$UpdateBoothMasterRequestImpl _value,
    $Res Function(_$UpdateBoothMasterRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$UpdateBoothMasterRequestImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateBoothMasterRequestImpl implements _UpdateBoothMasterRequest {
  const _$UpdateBoothMasterRequestImpl({required this.name});

  factory _$UpdateBoothMasterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateBoothMasterRequestImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'UpdateBoothMasterRequest(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBoothMasterRequestImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of UpdateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBoothMasterRequestImplCopyWith<_$UpdateBoothMasterRequestImpl>
  get copyWith =>
      __$$UpdateBoothMasterRequestImplCopyWithImpl<
        _$UpdateBoothMasterRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateBoothMasterRequestImplToJson(this);
  }
}

abstract class _UpdateBoothMasterRequest implements UpdateBoothMasterRequest {
  const factory _UpdateBoothMasterRequest({required final String name}) =
      _$UpdateBoothMasterRequestImpl;

  factory _UpdateBoothMasterRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateBoothMasterRequestImpl.fromJson;

  @override
  String get name;

  /// Create a copy of UpdateBoothMasterRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBoothMasterRequestImplCopyWith<_$UpdateBoothMasterRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
