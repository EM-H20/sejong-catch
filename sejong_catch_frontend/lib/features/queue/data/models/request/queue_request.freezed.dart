// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoothIdRequest _$BoothIdRequestFromJson(Map<String, dynamic> json) {
  return _BoothIdRequest.fromJson(json);
}

/// @nodoc
mixin _$BoothIdRequest {
  String get boothId => throw _privateConstructorUsedError;

  /// Serializes this BoothIdRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoothIdRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoothIdRequestCopyWith<BoothIdRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoothIdRequestCopyWith<$Res> {
  factory $BoothIdRequestCopyWith(
    BoothIdRequest value,
    $Res Function(BoothIdRequest) then,
  ) = _$BoothIdRequestCopyWithImpl<$Res, BoothIdRequest>;
  @useResult
  $Res call({String boothId});
}

/// @nodoc
class _$BoothIdRequestCopyWithImpl<$Res, $Val extends BoothIdRequest>
    implements $BoothIdRequestCopyWith<$Res> {
  _$BoothIdRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoothIdRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? boothId = null}) {
    return _then(
      _value.copyWith(
            boothId: null == boothId
                ? _value.boothId
                : boothId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoothIdRequestImplCopyWith<$Res>
    implements $BoothIdRequestCopyWith<$Res> {
  factory _$$BoothIdRequestImplCopyWith(
    _$BoothIdRequestImpl value,
    $Res Function(_$BoothIdRequestImpl) then,
  ) = __$$BoothIdRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String boothId});
}

/// @nodoc
class __$$BoothIdRequestImplCopyWithImpl<$Res>
    extends _$BoothIdRequestCopyWithImpl<$Res, _$BoothIdRequestImpl>
    implements _$$BoothIdRequestImplCopyWith<$Res> {
  __$$BoothIdRequestImplCopyWithImpl(
    _$BoothIdRequestImpl _value,
    $Res Function(_$BoothIdRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoothIdRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? boothId = null}) {
    return _then(
      _$BoothIdRequestImpl(
        boothId: null == boothId
            ? _value.boothId
            : boothId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoothIdRequestImpl implements _BoothIdRequest {
  const _$BoothIdRequestImpl({required this.boothId});

  factory _$BoothIdRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoothIdRequestImplFromJson(json);

  @override
  final String boothId;

  @override
  String toString() {
    return 'BoothIdRequest(boothId: $boothId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoothIdRequestImpl &&
            (identical(other.boothId, boothId) || other.boothId == boothId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, boothId);

  /// Create a copy of BoothIdRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoothIdRequestImplCopyWith<_$BoothIdRequestImpl> get copyWith =>
      __$$BoothIdRequestImplCopyWithImpl<_$BoothIdRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BoothIdRequestImplToJson(this);
  }
}

abstract class _BoothIdRequest implements BoothIdRequest {
  const factory _BoothIdRequest({required final String boothId}) =
      _$BoothIdRequestImpl;

  factory _BoothIdRequest.fromJson(Map<String, dynamic> json) =
      _$BoothIdRequestImpl.fromJson;

  @override
  String get boothId;

  /// Create a copy of BoothIdRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoothIdRequestImplCopyWith<_$BoothIdRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
