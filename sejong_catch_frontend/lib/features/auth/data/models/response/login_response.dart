import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// 로그인 API 응답 모델 (백엔드 스펙 일치!)
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,   // camelCase
    required String refreshToken,  // camelCase
    required UserDto user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 사용자 정보 DTO (백엔드 스펙 일치!)
@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    required String role,
    required String name,
    required String major,
    int? year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
