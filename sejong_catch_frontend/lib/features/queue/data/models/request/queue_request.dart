import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_request.freezed.dart';
part 'queue_request.g.dart';

/// 부스 ID 요청 (대기열 API 공통)
///
/// enqueue, cancel, me-status, list, rotate 등에서 사용
@freezed
class BoothIdRequest with _$BoothIdRequest {
  const factory BoothIdRequest({required String boothId}) = _BoothIdRequest;

  factory BoothIdRequest.fromJson(Map<String, dynamic> json) =>
      _$BoothIdRequestFromJson(json);
}
