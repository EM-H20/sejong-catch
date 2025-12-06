// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booth_master.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoothMaster _$BoothMasterFromJson(Map<String, dynamic> json) {
  return _BoothMaster.fromJson(json);
}

/// @nodoc
mixin _$BoothMaster {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BoothMaster to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoothMaster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoothMasterCopyWith<BoothMaster> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoothMasterCopyWith<$Res> {
  factory $BoothMasterCopyWith(
    BoothMaster value,
    $Res Function(BoothMaster) then,
  ) = _$BoothMasterCopyWithImpl<$Res, BoothMaster>;
  @useResult
  $Res call({String id, String name, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class _$BoothMasterCopyWithImpl<$Res, $Val extends BoothMaster>
    implements $BoothMasterCopyWith<$Res> {
  _$BoothMasterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoothMaster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BoothMasterImplCopyWith<$Res>
    implements $BoothMasterCopyWith<$Res> {
  factory _$$BoothMasterImplCopyWith(
    _$BoothMasterImpl value,
    $Res Function(_$BoothMasterImpl) then,
  ) = __$$BoothMasterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, DateTime createdAt, DateTime updatedAt});
}

/// @nodoc
class __$$BoothMasterImplCopyWithImpl<$Res>
    extends _$BoothMasterCopyWithImpl<$Res, _$BoothMasterImpl>
    implements _$$BoothMasterImplCopyWith<$Res> {
  __$$BoothMasterImplCopyWithImpl(
    _$BoothMasterImpl _value,
    $Res Function(_$BoothMasterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoothMaster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$BoothMasterImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
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
class _$BoothMasterImpl implements _BoothMaster {
  const _$BoothMasterImpl({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$BoothMasterImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoothMasterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BoothMaster(id: $id, name: $name, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoothMasterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, createdAt, updatedAt);

  /// Create a copy of BoothMaster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoothMasterImplCopyWith<_$BoothMasterImpl> get copyWith =>
      __$$BoothMasterImplCopyWithImpl<_$BoothMasterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoothMasterImplToJson(this);
  }
}

abstract class _BoothMaster implements BoothMaster {
  const factory _BoothMaster({
    required final String id,
    required final String name,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$BoothMasterImpl;

  factory _BoothMaster.fromJson(Map<String, dynamic> json) =
      _$BoothMasterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of BoothMaster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoothMasterImplCopyWith<_$BoothMasterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
