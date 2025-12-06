// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_queue_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MyQueueStatusImpl _$$MyQueueStatusImplFromJson(Map<String, dynamic> json) =>
    _$MyQueueStatusImpl(
      boothId: json['boothId'] as String,
      visitorId: json['visitorId'] as String,
      ticketNo: (json['ticketNo'] as num).toInt(),
      state: json['state'] as String,
      teamsAhead: (json['teamsAhead'] as num).toInt(),
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$$MyQueueStatusImplToJson(_$MyQueueStatusImpl instance) =>
    <String, dynamic>{
      'boothId': instance.boothId,
      'visitorId': instance.visitorId,
      'ticketNo': instance.ticketNo,
      'state': instance.state,
      'teamsAhead': instance.teamsAhead,
      'position': instance.position,
    };
