/// 🚪 로그아웃 응답 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - POST /api/auth/logout 성공 응답 (200)
/// 로그아웃 성공 메시지 반환
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)

class LogoutResponse {
  final String message;

  const LogoutResponse({
    required this.message,
  });

  /// JSON → LogoutResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final logoutResponse = LogoutResponse.fromJson(response.data);
  /// print(logoutResponse.message); // "로그아웃 되었습니다."
  /// ```
  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String,
    );
  }

  /// LogoutResponse → JSON 변환
  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
