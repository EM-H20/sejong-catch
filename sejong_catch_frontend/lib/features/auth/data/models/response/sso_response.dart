/// 🔐 SSO(세종대 포털) 인증 응답 모델
///
/// Node.js 서버에서 세종대 SSO 인증 결과를 포함한 응답
/// 로그인 성공 시 AuthResponse의 sso 필드에 포함됨
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)
/// ✅ 중첩 객체 처리 (SsoBody)

/// SSO 인증 응답 모델
class SsoResponse {
  final bool success;
  final bool isAuth;
  final String code;
  final SsoBody? body;

  const SsoResponse({
    required this.success,
    required this.isAuth,
    required this.code,
    this.body,
  });

  /// JSON → SsoResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final ssoResponse = SsoResponse.fromJson(json['sso']);
  /// if (ssoResponse.isAuth) {
  ///   print('세종대 인증 성공: ${ssoResponse.body?.name}');
  /// }
  /// ```
  factory SsoResponse.fromJson(Map<String, dynamic> json) {
    return SsoResponse(
      success: json['success'] as bool,
      isAuth: json['is_auth'] as bool,
      code: json['code'] as String,
      body: json['body'] != null
          ? SsoBody.fromJson(json['body'] as Map<String, dynamic>)
          : null,
    );
  }

  /// SsoResponse → JSON 변환
  Map<String, dynamic> toJson() => {
        'success': success,
        'is_auth': isAuth,
        'code': code,
        if (body != null) 'body': body!.toJson(),
      };

  @override
  String toString() =>
      'SsoResponse(success: $success, isAuth: $isAuth, code: $code, body: $body)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SsoResponse &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          isAuth == other.isAuth &&
          code == other.code &&
          body == other.body;

  @override
  int get hashCode =>
      success.hashCode ^ isAuth.hashCode ^ code.hashCode ^ body.hashCode;
}

/// SSO 인증 성공 시 사용자 정보
class SsoBody {
  final String name;
  final String major;

  const SsoBody({
    required this.name,
    required this.major,
  });

  /// JSON → SsoBody 변환
  factory SsoBody.fromJson(Map<String, dynamic> json) {
    return SsoBody(
      name: json['name'] as String,
      major: json['major'] as String,
    );
  }

  /// SsoBody → JSON 변환
  Map<String, dynamic> toJson() => {
        'name': name,
        'major': major,
      };

  @override
  String toString() => 'SsoBody(name: $name, major: $major)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SsoBody &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          major == other.major;

  @override
  int get hashCode => name.hashCode ^ major.hashCode;
}