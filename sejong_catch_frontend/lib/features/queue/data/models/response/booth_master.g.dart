// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booth_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoothMasterImpl _$$BoothMasterImplFromJson(Map<String, dynamic> json) =>
    _$BoothMasterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BoothMasterImplToJson(_$BoothMasterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
