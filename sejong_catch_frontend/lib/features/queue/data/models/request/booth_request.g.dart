// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateBoothRequestImpl _$$CreateBoothRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBoothRequestImpl(
  masterId: json['masterId'] as String,
  title: json['title'] as String,
  seatCount: (json['seatCount'] as num?)?.toInt(),
  avgWaitMinutes: (json['avgWaitMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CreateBoothRequestImplToJson(
  _$CreateBoothRequestImpl instance,
) => <String, dynamic>{
  'masterId': instance.masterId,
  'title': instance.title,
  'seatCount': instance.seatCount,
  'avgWaitMinutes': instance.avgWaitMinutes,
};

_$UpdateBoothRequestImpl _$$UpdateBoothRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateBoothRequestImpl(
  title: json['title'] as String?,
  seatCount: (json['seatCount'] as num?)?.toInt(),
  avgWaitMinutes: (json['avgWaitMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$$UpdateBoothRequestImplToJson(
  _$UpdateBoothRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'seatCount': instance.seatCount,
  'avgWaitMinutes': instance.avgWaitMinutes,
};

_$UpdateBoothStatusRequestImpl _$$UpdateBoothStatusRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateBoothStatusRequestImpl(status: json['status'] as String);

Map<String, dynamic> _$$UpdateBoothStatusRequestImplToJson(
  _$UpdateBoothStatusRequestImpl instance,
) => <String, dynamic>{'status': instance.status};
