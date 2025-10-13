import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// 로그인 API 요청 모델
///
/// Freezed + JsonSerializable로 JSON 직렬화 자동화
/// snake_case ↔ camelCase 자동 변환
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String studentId,  // → student_id
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
