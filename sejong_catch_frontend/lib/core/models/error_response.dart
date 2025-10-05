/// 🚨 공통 에러 응답 모델
///
/// 참조: claudedocs/AUTH_API_SPEC.md - 에러 응답 표준
/// 모든 API 에러 응답은 동일한 구조를 가짐
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)
/// ✅ 불변 객체 (final 필드)

class ErrorResponse {
  final String error;

  const ErrorResponse({
    required this.error,
  });

  /// JSON → ErrorResponse 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final errorResponse = ErrorResponse.fromJson(response.data);
  /// ```
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'] as String,
    );
  }

  /// ErrorResponse → JSON 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final json = errorResponse.toJson();
  /// ```
  Map<String, dynamic> toJson() => {
        'error': error,
      };

  @override
  String toString() => 'ErrorResponse(error: $error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorResponse &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
