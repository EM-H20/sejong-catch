// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueItemImpl _$$QueueItemImplFromJson(Map<String, dynamic> json) =>
    _$QueueItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      waiting: (json['waiting'] as num).toInt(),
      currentNumber: (json['currentNumber'] as num).toInt(),
      avgWaitTime: (json['avgWaitTime'] as num).toInt(),
    );

Map<String, dynamic> _$$QueueItemImplToJson(_$QueueItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
      'waiting': instance.waiting,
      'currentNumber': instance.currentNumber,
      'avgWaitTime': instance.avgWaitTime,
    };
