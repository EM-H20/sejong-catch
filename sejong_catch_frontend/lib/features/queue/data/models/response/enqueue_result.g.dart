// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enqueue_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnqueueResultImpl _$$EnqueueResultImplFromJson(Map<String, dynamic> json) =>
    _$EnqueueResultImpl(
      mode: json['mode'] as String,
      remainingSeats: (json['remainingSeats'] as num).toInt(),
      entry: QueueEntry.fromJson(json['entry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EnqueueResultImplToJson(_$EnqueueResultImpl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'remainingSeats': instance.remainingSeats,
      'entry': instance.entry,
    };
