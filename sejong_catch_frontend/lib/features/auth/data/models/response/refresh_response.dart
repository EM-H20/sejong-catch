/// 🔄 Access Token 갱신 응답 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - POST /api/auth/refresh 성공 응답 (200)
/// 새로운 Access Token만 반환 (Refresh Token은 재사용)
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)

class RefreshResponse {
  final String accessToken;

  const RefreshResponse({
    required this.accessToken,
  });

  /// JSON → RefreshResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final refreshResponse = RefreshResponse.fromJson(response.data);
  /// await tokenRepository.saveAccessToken(refreshResponse.accessToken);
  /// ```
  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['access_token'] as String,
    );
  }

  /// RefreshResponse → JSON 변환
  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
      };
}
