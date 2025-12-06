import 'package:freezed_annotation/freezed_annotation.dart';

part 'booth_master.freezed.dart';
part 'booth_master.g.dart';

/// 🏷️ 부스 타입 (Booth Master) 모델
///
/// 부스의 카테고리/타입을 정의합니다.
/// 예: 게임, 음식, 포토존 등
///
/// **API**: GET/POST /catch/booth-masters
@freezed
class BoothMaster with _$BoothMaster {
  const factory BoothMaster({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BoothMaster;

  factory BoothMaster.fromJson(Map<String, dynamic> json) =>
      _$BoothMasterFromJson(json);
}
