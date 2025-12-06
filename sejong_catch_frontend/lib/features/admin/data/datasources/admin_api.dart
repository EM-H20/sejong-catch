import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart';
import '../models/request/change_role_request.dart';

part 'admin_api.g.dart';

/// 관리자 API 인터페이스 (Retrofit)
///
/// 백엔드 API 명세서 기반:
/// - 유저 역할 변경: PATCH /core/admin/users/{userId}/role
@RestApi()
abstract class AdminApi {
  factory AdminApi(Dio dio, {String baseUrl}) = _AdminApi;

  /// 유저 역할 변경 🔒 (admin only)
  ///
  /// **Path**: `/core/admin/users/{userId}/role`
  /// **Request**: `{ "role": "admin" | "student" }`
  /// **Response**: 204 No Content
  @PATCH('/core/admin/users/{userId}/role')
  Future<void> changeUserRole(
    @Path('userId') String userId,
    @Body() ChangeRoleRequest request,
  );
}

/// AdminApi Provider
@riverpod
AdminApi adminApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AdminApi(dio);
}
