import 'package:freezed_annotation/freezed_annotation.dart';

part 'booth_manager.freezed.dart';
part 'booth_manager.g.dart';

/// 👨‍💼 부스 관리자 모델 (API: catch_booth_managers)
///
/// 부스와 사용자 간의 N:M 관계를 나타냅니다.
/// 특정 부스에 할당된 관리자 정보를 담고 있습니다.
///
/// **API**:
/// - GET /catch/booths/{boothId}/managers
/// - POST /catch/booths/{boothId}/managers
/// - DELETE /catch/booths/{boothId}/managers/{userId}
@freezed
class BoothManager with _$BoothManager {
  const factory BoothManager({
    required String id,
    required String boothId,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    // 조인된 사용자 정보 (API 응답에 포함될 수 있음)
    String? userName,
    String? userEmail,
  }) = _BoothManager;

  factory BoothManager.fromJson(Map<String, dynamic> json) =>
      _$BoothManagerFromJson(json);
}

/// 부스 관리자 추가 요청
@freezed
class AddBoothManagerRequest with _$AddBoothManagerRequest {
  const factory AddBoothManagerRequest({
    required String userId,
  }) = _AddBoothManagerRequest;

  factory AddBoothManagerRequest.fromJson(Map<String, dynamic> json) =>
      _$AddBoothManagerRequestFromJson(json);
}
