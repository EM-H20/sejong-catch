// 🔐 로그인 성공 응답 모델
//
// 참조: INTEGRATION_GUIDE.md - Node.js 서버 POST /api/auth/login 응답
// Access Token, Refresh Token, 사용자 정보, SSO 연동 정보 포함
//
// CLAUDE.md 원칙:
// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
// ✅ JSON 수동 파싱 (fromJson, toJson)
// ✅ 중첩 객체 처리 (UserDto, SsoResponse)
//
// Node.js 서버 응답 구조:
// ```json
// {
//   "access_token": "...",
//   "refresh_token": "...",
//   "user": { "id": "u_21011572", ... },
//   "linked": false,
//   "sso": { "success": true, ... }
// }
// ```

import 'user_dto.dart';
import 'sso_response.dart';

/// 로그인 성공 응답 모델
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserDto user;
  final bool linked;
  final SsoResponse sso;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.linked,
    required this.sso,
  });

  /// JSON → AuthResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final authResponse = AuthResponse.fromJson(response.data);
  /// print(authResponse.user.role); // "student"
  /// if (authResponse.linked) {
  ///   print('SSO 연동 완료!');
  /// }
  /// ```
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      linked: json['linked'] as bool,
      sso: SsoResponse.fromJson(json['sso'] as Map<String, dynamic>),
    );
  }

  /// AuthResponse → JSON 변환
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user': user.toJson(),
        'linked': linked,
        'sso': sso.toJson(),
      };

  @override
  String toString() =>
      'AuthResponse(accessToken: ${accessToken.substring(0, 20)}..., user: $user, linked: $linked)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResponse &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          user == other.user;

  @override
  int get hashCode => accessToken.hashCode ^ user.hashCode;
}
