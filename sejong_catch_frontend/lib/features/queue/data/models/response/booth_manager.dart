import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/json_converters.dart';

part 'booth_manager.freezed.dart';
part 'booth_manager.g.dart';

/// 👨‍💼 부스 관리자 모델 (API: CatchBoothManager)
///
/// 부스와 사용자 간의 N:M 관계를 나타냅니다.
/// 특정 부스에 할당된 관리자 정보를 담고 있습니다.
///
/// **백엔드 스키마**:
/// ```typescript
/// {
///   id: string;
///   boothObjectId: string;  // 프론트에서는 boothId로 사용
///   userId: string;
///   createdAt: string;
/// }
/// ```
///
/// **API**:
/// - GET /catch/booths/{boothId}/managers
/// - POST /catch/booths/{boothId}/managers
/// - DELETE /catch/booths/{boothId}/managers/{userId}
@freezed
class BoothManager with _$BoothManager {
  const factory BoothManager({
    required String id,
    // 백엔드: boothObjectId → 프론트: boothId로 매핑
    @JsonKey(name: 'boothObjectId') required String boothId,
    required String userId,
    @FlexibleDateTimeConverter() required DateTime createdAt,
    // updatedAt은 백엔드에 없지만 UI에서 사용할 수 있도록 nullable로 유지
    @NullableFlexibleDateTimeConverter() DateTime? updatedAt,
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
  const factory AddBoothManagerRequest({required String userId}) =
      _AddBoothManagerRequest;

  factory AddBoothManagerRequest.fromJson(Map<String, dynamic> json) =>
      _$AddBoothManagerRequestFromJson(json);
}
