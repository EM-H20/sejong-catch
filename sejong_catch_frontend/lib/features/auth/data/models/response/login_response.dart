import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 로그인 API 응답 모델
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    required UserDto user,
    required bool linked,
    required SsoDto sso,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 사용자 정보 DTO
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    @JsonKey(name: 'student_id') required String studentId,
    required String role,
    required String name,
    required String major,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

/// SSO 정보 DTO
@freezed
class SsoDto with _$SsoDto {
  const factory SsoDto({
    required bool success,
    @JsonKey(name: 'is_auth') required bool isAuth,
    required String code,
    required SsoBodyDto body,
  }) = _SsoDto;

  factory SsoDto.fromJson(Map<String, dynamic> json) => _$SsoDtoFromJson(json);
}

/// SSO Body DTO
@freezed
class SsoBodyDto with _$SsoBodyDto {
  const factory SsoBodyDto({required String name, required String major}) =
      _SsoBodyDto;

  factory SsoBodyDto.fromJson(Map<String, dynamic> json) =>
      _$SsoBodyDtoFromJson(json);
}
