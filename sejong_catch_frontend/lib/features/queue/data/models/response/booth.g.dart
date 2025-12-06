// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoothImpl _$$BoothImplFromJson(Map<String, dynamic> json) => _$BoothImpl(
  id: json['id'] as String,
  masterId: json['masterId'] as String,
  title: json['title'] as String,
  seatCount: (json['seatCount'] as num).toInt(),
  avgWaitMinutes: (json['avgWaitMinutes'] as num).toInt(),
  status: json['status'] as String,
  createdAt: const FlexibleDateTimeConverter().fromJson(json['createdAt']),
  updatedAt: const FlexibleDateTimeConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$BoothImplToJson(_$BoothImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'masterId': instance.masterId,
      'title': instance.title,
      'seatCount': instance.seatCount,
      'avgWaitMinutes': instance.avgWaitMinutes,
      'status': instance.status,
      'createdAt': const FlexibleDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const FlexibleDateTimeConverter().toJson(instance.updatedAt),
    };
