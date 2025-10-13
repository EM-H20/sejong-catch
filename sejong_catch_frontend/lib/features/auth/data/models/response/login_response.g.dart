// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      linked: json['linked'] as bool,
      sso: SsoDto.fromJson(json['sso'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
      'linked': instance.linked,
      'sso': instance.sso,
    };

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'role': instance.role,
      'name': instance.name,
      'major': instance.major,
    };

_$SsoDtoImpl _$$SsoDtoImplFromJson(Map<String, dynamic> json) => _$SsoDtoImpl(
  success: json['success'] as bool,
  isAuth: json['is_auth'] as bool,
  code: json['code'] as String,
  body: SsoBodyDto.fromJson(json['body'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SsoDtoImplToJson(_$SsoDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'is_auth': instance.isAuth,
      'code': instance.code,
      'body': instance.body,
    };

_$SsoBodyDtoImpl _$$SsoBodyDtoImplFromJson(Map<String, dynamic> json) =>
    _$SsoBodyDtoImpl(
      name: json['name'] as String,
      major: json['major'] as String,
    );

Map<String, dynamic> _$$SsoBodyDtoImplToJson(_$SsoBodyDtoImpl instance) =>
    <String, dynamic>{'name': instance.name, 'major': instance.major};
