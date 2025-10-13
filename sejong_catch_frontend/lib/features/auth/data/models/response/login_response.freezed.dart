// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  UserDto get user => throw _privateConstructorUsedError;
  bool get linked => throw _privateConstructorUsedError;
  SsoDto get sso => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
    LoginResponse value,
    $Res Function(LoginResponse) then,
  ) = _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    UserDto user,
    bool linked,
    SsoDto sso,
  });

  $UserDtoCopyWith<$Res> get user;
  $SsoDtoCopyWith<$Res> get sso;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? linked = null,
    Object? sso = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserDto,
            linked: null == linked
                ? _value.linked
                : linked // ignore: cast_nullable_to_non_nullable
                      as bool,
            sso: null == sso
                ? _value.sso
                : sso // ignore: cast_nullable_to_non_nullable
                      as SsoDto,
          )
          as $Val,
    );
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get user {
    return $UserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SsoDtoCopyWith<$Res> get sso {
    return $SsoDtoCopyWith<$Res>(_value.sso, (value) {
      return _then(_value.copyWith(sso: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
    _$LoginResponseImpl value,
    $Res Function(_$LoginResponseImpl) then,
  ) = __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'access_token') String accessToken,
    @JsonKey(name: 'refresh_token') String refreshToken,
    UserDto user,
    bool linked,
    SsoDto sso,
  });

  @override
  $UserDtoCopyWith<$Res> get user;
  @override
  $SsoDtoCopyWith<$Res> get sso;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
    _$LoginResponseImpl _value,
    $Res Function(_$LoginResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? linked = null,
    Object? sso = null,
  }) {
    return _then(
      _$LoginResponseImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserDto,
        linked: null == linked
            ? _value.linked
            : linked // ignore: cast_nullable_to_non_nullable
                  as bool,
        sso: null == sso
            ? _value.sso
            : sso // ignore: cast_nullable_to_non_nullable
                  as SsoDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl({
    @JsonKey(name: 'access_token') required this.accessToken,
    @JsonKey(name: 'refresh_token') required this.refreshToken,
    required this.user,
    required this.linked,
    required this.sso,
  });

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  final UserDto user;
  @override
  final bool linked;
  @override
  final SsoDto sso;

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, linked: $linked, sso: $sso)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.linked, linked) || other.linked == linked) &&
            (identical(other.sso, sso) || other.sso == sso));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, user, linked, sso);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(this);
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse({
    @JsonKey(name: 'access_token') required final String accessToken,
    @JsonKey(name: 'refresh_token') required final String refreshToken,
    required final UserDto user,
    required final bool linked,
    required final SsoDto sso,
  }) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  UserDto get user;
  @override
  bool get linked;
  @override
  SsoDto get sso;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get major => throw _privateConstructorUsedError;

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'student_id') String studentId,
    String role,
    String name,
    String major,
  });
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? role = null,
    Object? name = null,
    Object? major = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            major: null == major
                ? _value.major
                : major // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
    _$UserDtoImpl value,
    $Res Function(_$UserDtoImpl) then,
  ) = __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'student_id') String studentId,
    String role,
    String name,
    String major,
  });
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
    _$UserDtoImpl _value,
    $Res Function(_$UserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? role = null,
    Object? name = null,
    Object? major = null,
  }) {
    return _then(
      _$UserDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        major: null == major
            ? _value.major
            : major // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl({
    required this.id,
    @JsonKey(name: 'student_id') required this.studentId,
    required this.role,
    required this.name,
    required this.major,
  });

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  final String role;
  @override
  final String name;
  @override
  final String major;

  @override
  String toString() {
    return 'UserDto(id: $id, studentId: $studentId, role: $role, name: $name, major: $major)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.major, major) || other.major == major));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, studentId, role, name, major);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(this);
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto({
    required final String id,
    @JsonKey(name: 'student_id') required final String studentId,
    required final String role,
    required final String name,
    required final String major,
  }) = _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  String get role;
  @override
  String get name;
  @override
  String get major;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SsoDto _$SsoDtoFromJson(Map<String, dynamic> json) {
  return _SsoDto.fromJson(json);
}

/// @nodoc
mixin _$SsoDto {
  bool get success => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_auth')
  bool get isAuth => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  SsoBodyDto get body => throw _privateConstructorUsedError;

  /// Serializes this SsoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SsoDtoCopyWith<SsoDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SsoDtoCopyWith<$Res> {
  factory $SsoDtoCopyWith(SsoDto value, $Res Function(SsoDto) then) =
      _$SsoDtoCopyWithImpl<$Res, SsoDto>;
  @useResult
  $Res call({
    bool success,
    @JsonKey(name: 'is_auth') bool isAuth,
    String code,
    SsoBodyDto body,
  });

  $SsoBodyDtoCopyWith<$Res> get body;
}

/// @nodoc
class _$SsoDtoCopyWithImpl<$Res, $Val extends SsoDto>
    implements $SsoDtoCopyWith<$Res> {
  _$SsoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? isAuth = null,
    Object? code = null,
    Object? body = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAuth: null == isAuth
                ? _value.isAuth
                : isAuth // ignore: cast_nullable_to_non_nullable
                      as bool,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as SsoBodyDto,
          )
          as $Val,
    );
  }

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SsoBodyDtoCopyWith<$Res> get body {
    return $SsoBodyDtoCopyWith<$Res>(_value.body, (value) {
      return _then(_value.copyWith(body: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SsoDtoImplCopyWith<$Res> implements $SsoDtoCopyWith<$Res> {
  factory _$$SsoDtoImplCopyWith(
    _$SsoDtoImpl value,
    $Res Function(_$SsoDtoImpl) then,
  ) = __$$SsoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    @JsonKey(name: 'is_auth') bool isAuth,
    String code,
    SsoBodyDto body,
  });

  @override
  $SsoBodyDtoCopyWith<$Res> get body;
}

/// @nodoc
class __$$SsoDtoImplCopyWithImpl<$Res>
    extends _$SsoDtoCopyWithImpl<$Res, _$SsoDtoImpl>
    implements _$$SsoDtoImplCopyWith<$Res> {
  __$$SsoDtoImplCopyWithImpl(
    _$SsoDtoImpl _value,
    $Res Function(_$SsoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? isAuth = null,
    Object? code = null,
    Object? body = null,
  }) {
    return _then(
      _$SsoDtoImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAuth: null == isAuth
            ? _value.isAuth
            : isAuth // ignore: cast_nullable_to_non_nullable
                  as bool,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as SsoBodyDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SsoDtoImpl implements _SsoDto {
  const _$SsoDtoImpl({
    required this.success,
    @JsonKey(name: 'is_auth') required this.isAuth,
    required this.code,
    required this.body,
  });

  factory _$SsoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SsoDtoImplFromJson(json);

  @override
  final bool success;
  @override
  @JsonKey(name: 'is_auth')
  final bool isAuth;
  @override
  final String code;
  @override
  final SsoBodyDto body;

  @override
  String toString() {
    return 'SsoDto(success: $success, isAuth: $isAuth, code: $code, body: $body)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SsoDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.isAuth, isAuth) || other.isAuth == isAuth) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, isAuth, code, body);

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SsoDtoImplCopyWith<_$SsoDtoImpl> get copyWith =>
      __$$SsoDtoImplCopyWithImpl<_$SsoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SsoDtoImplToJson(this);
  }
}

abstract class _SsoDto implements SsoDto {
  const factory _SsoDto({
    required final bool success,
    @JsonKey(name: 'is_auth') required final bool isAuth,
    required final String code,
    required final SsoBodyDto body,
  }) = _$SsoDtoImpl;

  factory _SsoDto.fromJson(Map<String, dynamic> json) = _$SsoDtoImpl.fromJson;

  @override
  bool get success;
  @override
  @JsonKey(name: 'is_auth')
  bool get isAuth;
  @override
  String get code;
  @override
  SsoBodyDto get body;

  /// Create a copy of SsoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SsoDtoImplCopyWith<_$SsoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SsoBodyDto _$SsoBodyDtoFromJson(Map<String, dynamic> json) {
  return _SsoBodyDto.fromJson(json);
}

/// @nodoc
mixin _$SsoBodyDto {
  String get name => throw _privateConstructorUsedError;
  String get major => throw _privateConstructorUsedError;

  /// Serializes this SsoBodyDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SsoBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SsoBodyDtoCopyWith<SsoBodyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SsoBodyDtoCopyWith<$Res> {
  factory $SsoBodyDtoCopyWith(
    SsoBodyDto value,
    $Res Function(SsoBodyDto) then,
  ) = _$SsoBodyDtoCopyWithImpl<$Res, SsoBodyDto>;
  @useResult
  $Res call({String name, String major});
}

/// @nodoc
class _$SsoBodyDtoCopyWithImpl<$Res, $Val extends SsoBodyDto>
    implements $SsoBodyDtoCopyWith<$Res> {
  _$SsoBodyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SsoBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? major = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            major: null == major
                ? _value.major
                : major // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SsoBodyDtoImplCopyWith<$Res>
    implements $SsoBodyDtoCopyWith<$Res> {
  factory _$$SsoBodyDtoImplCopyWith(
    _$SsoBodyDtoImpl value,
    $Res Function(_$SsoBodyDtoImpl) then,
  ) = __$$SsoBodyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String major});
}

/// @nodoc
class __$$SsoBodyDtoImplCopyWithImpl<$Res>
    extends _$SsoBodyDtoCopyWithImpl<$Res, _$SsoBodyDtoImpl>
    implements _$$SsoBodyDtoImplCopyWith<$Res> {
  __$$SsoBodyDtoImplCopyWithImpl(
    _$SsoBodyDtoImpl _value,
    $Res Function(_$SsoBodyDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SsoBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? major = null}) {
    return _then(
      _$SsoBodyDtoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        major: null == major
            ? _value.major
            : major // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SsoBodyDtoImpl implements _SsoBodyDto {
  const _$SsoBodyDtoImpl({required this.name, required this.major});

  factory _$SsoBodyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SsoBodyDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String major;

  @override
  String toString() {
    return 'SsoBodyDto(name: $name, major: $major)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SsoBodyDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.major, major) || other.major == major));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, major);

  /// Create a copy of SsoBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SsoBodyDtoImplCopyWith<_$SsoBodyDtoImpl> get copyWith =>
      __$$SsoBodyDtoImplCopyWithImpl<_$SsoBodyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SsoBodyDtoImplToJson(this);
  }
}

abstract class _SsoBodyDto implements SsoBodyDto {
  const factory _SsoBodyDto({
    required final String name,
    required final String major,
  }) = _$SsoBodyDtoImpl;

  factory _SsoBodyDto.fromJson(Map<String, dynamic> json) =
      _$SsoBodyDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get major;

  /// Create a copy of SsoBodyDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SsoBodyDtoImplCopyWith<_$SsoBodyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
