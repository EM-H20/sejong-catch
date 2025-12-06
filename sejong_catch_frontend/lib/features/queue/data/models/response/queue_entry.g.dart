// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueueEntryImpl _$$QueueEntryImplFromJson(Map<String, dynamic> json) =>
    _$QueueEntryImpl(
      id: json['id'] as String,
      boothId: json['boothId'] as String,
      visitorId: json['visitorId'] as String?,
      ticketNo: (json['ticketNo'] as num).toInt(),
      state: json['state'] as String? ?? 'WAITING',
      joinedAt: const FlexibleDateTimeConverter().fromJson(json['joinedAt']),
    );

Map<String, dynamic> _$$QueueEntryImplToJson(_$QueueEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boothId': instance.boothId,
      'visitorId': instance.visitorId,
      'ticketNo': instance.ticketNo,
      'state': instance.state,
      'joinedAt': const FlexibleDateTimeConverter().toJson(instance.joinedAt),
    };
