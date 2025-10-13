import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// 로그인 API 요청 모델
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @JsonKey(name: 'student_id') required String studentId,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
