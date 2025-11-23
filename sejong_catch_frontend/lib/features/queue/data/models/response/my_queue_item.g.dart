// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MyQueueItemImpl _$$MyQueueItemImplFromJson(Map<String, dynamic> json) =>
    _$MyQueueItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      myNumber: (json['myNumber'] as num).toInt(),
      currentNumber: (json['currentNumber'] as num).toInt(),
      peopleAhead: (json['peopleAhead'] as num).toInt(),
      estimatedWait: (json['estimatedWait'] as num).toInt(),
    );

Map<String, dynamic> _$$MyQueueItemImplToJson(_$MyQueueItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'myNumber': instance.myNumber,
      'currentNumber': instance.currentNumber,
      'peopleAhead': instance.peopleAhead,
      'estimatedWait': instance.estimatedWait,
    };
