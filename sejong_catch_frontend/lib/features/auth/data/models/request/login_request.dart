/// 🔐 로그인 요청 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - POST /api/auth/login
/// 세종대 포털 계정으로 로그인 요청
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (toJson)
/// ✅ 보안 고려 toString (비밀번호 마스킹)

class LoginRequest {
  final String studentId;
  final String password;

  const LoginRequest({
    required this.studentId,
    required this.password,
  });

  /// LoginRequest → JSON 변환
  ///
  /// API 요청 시 사용:
  /// ```dart
  /// final request = LoginRequest(studentId: '20231234', password: 'pw123');
  /// final json = request.toJson(); // {'student_id': '20231234', 'password': 'pw123'}
  /// ```
  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'password': password,
      };

  /// 보안을 위한 toString (비밀번호 마스킹)
  @override
  String toString() =>
      'LoginRequest(studentId: ${studentId.substring(0, 4)}***)';
}
