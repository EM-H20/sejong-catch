import 'package:freezed_annotation/freezed_annotation.dart';

part 'booth_master_request.freezed.dart';
part 'booth_master_request.g.dart';

/// 부스 타입 생성 요청 (POST /catch/booth-masters)
@freezed
class CreateBoothMasterRequest with _$CreateBoothMasterRequest {
  const factory CreateBoothMasterRequest({required String name}) =
      _CreateBoothMasterRequest;

  factory CreateBoothMasterRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBoothMasterRequestFromJson(json);
}

/// 부스 타입 수정 요청 (PATCH /catch/booth-masters/{id})
@freezed
class UpdateBoothMasterRequest with _$UpdateBoothMasterRequest {
  const factory UpdateBoothMasterRequest({required String name}) =
      _UpdateBoothMasterRequest;

  factory UpdateBoothMasterRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBoothMasterRequestFromJson(json);
}
