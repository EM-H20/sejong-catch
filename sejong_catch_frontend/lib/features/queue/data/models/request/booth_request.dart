import 'package:freezed_annotation/freezed_annotation.dart';

part 'booth_request.freezed.dart';
part 'booth_request.g.dart';

/// 부스 생성 요청 (POST /catch/booths)
@freezed
class CreateBoothRequest with _$CreateBoothRequest {
  const factory CreateBoothRequest({
    required String masterId,
    required String title,
    int? seatCount,
    int? avgWaitMinutes,
  }) = _CreateBoothRequest;

  factory CreateBoothRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBoothRequestFromJson(json);
}

/// 부스 수정 요청 (PATCH /catch/booths/{boothId})
@freezed
class UpdateBoothRequest with _$UpdateBoothRequest {
  const factory UpdateBoothRequest({
    String? title,
    int? seatCount,
    int? avgWaitMinutes,
  }) = _UpdateBoothRequest;

  factory UpdateBoothRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBoothRequestFromJson(json);
}

/// 부스 상태 변경 요청 (PATCH /catch/booths/{boothId}/status)
@freezed
class UpdateBoothStatusRequest with _$UpdateBoothStatusRequest {
  const factory UpdateBoothStatusRequest({
    required String status, // PREPARING | OPERATING | ENDED
  }) = _UpdateBoothStatusRequest;

  factory UpdateBoothStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBoothStatusRequestFromJson(json);
}
