/// 🔄 Access Token 갱신 요청 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - POST /api/auth/refresh
/// Refresh Token으로 새로운 Access Token 발급
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (toJson)

class RefreshRequest {
  final String refreshToken;

  const RefreshRequest({
    required this.refreshToken,
  });

  /// RefreshRequest → JSON 변환
  ///
  /// API 요청 시 사용:
  /// ```dart
  /// final request = RefreshRequest(refreshToken: 'eyJhbGc...');
  /// final json = request.toJson(); // {'refresh_token': 'eyJhbGc...'}
  /// ```
  Map<String, dynamic> toJson() => {
        'refresh_token': refreshToken,
      };
}
