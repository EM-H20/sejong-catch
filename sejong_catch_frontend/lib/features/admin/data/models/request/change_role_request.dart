import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_role_request.freezed.dart';
part 'change_role_request.g.dart';

/// 유저 역할 변경 요청 (PATCH /core/admin/users/{userId}/role)
@freezed
class ChangeRoleRequest with _$ChangeRoleRequest {
  const factory ChangeRoleRequest({
    required String role, // "student" | "admin"
  }) = _ChangeRoleRequest;

  factory ChangeRoleRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangeRoleRequestFromJson(json);
}
