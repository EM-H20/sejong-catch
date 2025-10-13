import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 로그인 API 응답 모델
///
/// Freezed + JsonSerializable로 JSON 직렬화 자동화
/// snake_case ↔ camelCase 자동 변환
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,   // → access_token
    required String refreshToken,  // → refresh_token
    required UserDto user,
    required bool linked,
    required SsoDto sso,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 사용자 정보 DTO
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String studentId,  // → student_id
    required String role,
    required String name,
    required String major,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// SSO 정보 DTO
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class SsoDto with _$SsoDto {
  const factory SsoDto({
    required bool success,
    required bool isAuth,  // → is_auth
    required String code,
    required SsoBodyDto body,
  }) = _SsoDto;

  factory SsoDto.fromJson(Map<String, dynamic> json) =>
      _$SsoDtoFromJson(json);
}

/// SSO Body DTO
@freezed
class SsoBodyDto with _$SsoBodyDto {
  const factory SsoBodyDto({
    required String name,
    required String major,
  }) = _SsoBodyDto;

  factory SsoBodyDto.fromJson(Map<String, dynamic> json) =>
      _$SsoBodyDtoFromJson(json);
}
