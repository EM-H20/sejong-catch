// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booth_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BoothManager _$BoothManagerFromJson(Map<String, dynamic> json) {
  return _BoothManager.fromJson(json);
}

/// @nodoc
mixin _$BoothManager {
  String get id => throw _privateConstructorUsedError;
  String get boothId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // 조인된 사용자 정보 (API 응답에 포함될 수 있음)
  String? get userName => throw _privateConstructorUsedError;
  String? get userEmail => throw _privateConstructorUsedError;

  /// Serializes this BoothManager to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoothManager
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoothManagerCopyWith<BoothManager> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoothManagerCopyWith<$Res> {
  factory $BoothManagerCopyWith(
    BoothManager value,
    $Res Function(BoothManager) then,
  ) = _$BoothManagerCopyWithImpl<$Res, BoothManager>;
  @useResult
  $Res call({
    String id,
    String boothId,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    String? userName,
    String? userEmail,
  });
}

/// @nodoc
class _$BoothManagerCopyWithImpl<$Res, $Val extends BoothManager>
    implements $BoothManagerCopyWith<$Res> {
  _$BoothManagerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoothManager
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boothId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userName = freezed,
    Object? userEmail = freezed,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            userName: freezed == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String?,
            userEmail: freezed == userEmail
                ? _value.userEmail
                : userEmail // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoothManagerImplCopyWith<$Res>
    implements $BoothManagerCopyWith<$Res> {
  factory _$$BoothManagerImplCopyWith(
    _$BoothManagerImpl value,
    $Res Function(_$BoothManagerImpl) then,
  ) = __$$BoothManagerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String boothId,
    String userId,
    DateTime createdAt,
    DateTime updatedAt,
    String? userName,
    String? userEmail,
  });
}

/// @nodoc
class __$$BoothManagerImplCopyWithImpl<$Res>
    extends _$BoothManagerCopyWithImpl<$Res, _$BoothManagerImpl>
    implements _$$BoothManagerImplCopyWith<$Res> {
  __$$BoothManagerImplCopyWithImpl(
    _$BoothManagerImpl _value,
    $Res Function(_$BoothManagerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BoothManager
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? boothId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userName = freezed,
    Object? userEmail = freezed,
  }) {
    return _then(
      _$BoothManagerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        boothId: null == boothId
            ? _value.boothId
            : boothId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userName: freezed == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String?,
        userEmail: freezed == userEmail
            ? _value.userEmail
            : userEmail // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoothManagerImpl implements _BoothManager {
  const _$BoothManagerImpl({
    required this.id,
    required this.boothId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userEmail,
  });

  factory _$BoothManagerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoothManagerImplFromJson(json);

  @override
  final String id;
  @override
  final String boothId;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  // 조인된 사용자 정보 (API 응답에 포함될 수 있음)
  @override
  final String? userName;
  @override
  final String? userEmail;

  @override
  String toString() {
    return 'BoothManager(id: $id, boothId: $boothId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, userName: $userName, userEmail: $userEmail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoothManagerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.boothId, boothId) || other.boothId == boothId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userEmail, userEmail) ||
                other.userEmail == userEmail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    boothId,
    userId,
    createdAt,
    updatedAt,
    userName,
    userEmail,
  );

  /// Create a copy of BoothManager
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoothManagerImplCopyWith<_$BoothManagerImpl> get copyWith =>
      __$$BoothManagerImplCopyWithImpl<_$BoothManagerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoothManagerImplToJson(this);
  }
}

abstract class _BoothManager implements BoothManager {
  const factory _BoothManager({
    required final String id,
    required final String boothId,
    required final String userId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? userName,
    final String? userEmail,
  }) = _$BoothManagerImpl;

  factory _BoothManager.fromJson(Map<String, dynamic> json) =
      _$BoothManagerImpl.fromJson;

  @override
  String get id;
  @override
  String get boothId;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt; // 조인된 사용자 정보 (API 응답에 포함될 수 있음)
  @override
  String? get userName;
  @override
  String? get userEmail;

  /// Create a copy of BoothManager
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoothManagerImplCopyWith<_$BoothManagerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddBoothManagerRequest _$AddBoothManagerRequestFromJson(
  Map<String, dynamic> json,
) {
  return _AddBoothManagerRequest.fromJson(json);
}

/// @nodoc
mixin _$AddBoothManagerRequest {
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this AddBoothManagerRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddBoothManagerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddBoothManagerRequestCopyWith<AddBoothManagerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddBoothManagerRequestCopyWith<$Res> {
  factory $AddBoothManagerRequestCopyWith(
    AddBoothManagerRequest value,
    $Res Function(AddBoothManagerRequest) then,
  ) = _$AddBoothManagerRequestCopyWithImpl<$Res, AddBoothManagerRequest>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$AddBoothManagerRequestCopyWithImpl<
  $Res,
  $Val extends AddBoothManagerRequest
>
    implements $AddBoothManagerRequestCopyWith<$Res> {
  _$AddBoothManagerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddBoothManagerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddBoothManagerRequestImplCopyWith<$Res>
    implements $AddBoothManagerRequestCopyWith<$Res> {
  factory _$$AddBoothManagerRequestImplCopyWith(
    _$AddBoothManagerRequestImpl value,
    $Res Function(_$AddBoothManagerRequestImpl) then,
  ) = __$$AddBoothManagerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$AddBoothManagerRequestImplCopyWithImpl<$Res>
    extends
        _$AddBoothManagerRequestCopyWithImpl<$Res, _$AddBoothManagerRequestImpl>
    implements _$$AddBoothManagerRequestImplCopyWith<$Res> {
  __$$AddBoothManagerRequestImplCopyWithImpl(
    _$AddBoothManagerRequestImpl _value,
    $Res Function(_$AddBoothManagerRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddBoothManagerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$AddBoothManagerRequestImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddBoothManagerRequestImpl implements _AddBoothManagerRequest {
  const _$AddBoothManagerRequestImpl({required this.userId});

  factory _$AddBoothManagerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddBoothManagerRequestImplFromJson(json);

  @override
  final String userId;

  @override
  String toString() {
    return 'AddBoothManagerRequest(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddBoothManagerRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of AddBoothManagerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddBoothManagerRequestImplCopyWith<_$AddBoothManagerRequestImpl>
  get copyWith =>
      __$$AddBoothManagerRequestImplCopyWithImpl<_$AddBoothManagerRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AddBoothManagerRequestImplToJson(this);
  }
}

abstract class _AddBoothManagerRequest implements AddBoothManagerRequest {
  const factory _AddBoothManagerRequest({required final String userId}) =
      _$AddBoothManagerRequestImpl;

  factory _AddBoothManagerRequest.fromJson(Map<String, dynamic> json) =
      _$AddBoothManagerRequestImpl.fromJson;

  @override
  String get userId;

  /// Create a copy of AddBoothManagerRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddBoothManagerRequestImplCopyWith<_$AddBoothManagerRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
