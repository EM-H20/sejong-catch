/// 🔐 로그인 성공 응답 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - POST /api/auth/login 성공 응답 (201)
/// Access Token, Refresh Token, 사용자 정보 포함
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)
/// ✅ 중첩 객체 처리 (UserDto)

import 'user_dto.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserDto user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  /// JSON → AuthResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final authResponse = AuthResponse.fromJson(response.data);
  /// print(authResponse.user.name); // "홍길동"
  /// ```
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  /// AuthResponse → JSON 변환
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user': user.toJson(),
      };
}
