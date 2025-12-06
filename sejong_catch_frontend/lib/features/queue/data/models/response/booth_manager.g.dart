// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booth_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoothManagerImpl _$$BoothManagerImplFromJson(Map<String, dynamic> json) =>
    _$BoothManagerImpl(
      id: json['id'] as String,
      boothId: json['boothId'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
    );

Map<String, dynamic> _$$BoothManagerImplToJson(_$BoothManagerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boothId': instance.boothId,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userName': instance.userName,
      'userEmail': instance.userEmail,
    };

_$AddBoothManagerRequestImpl _$$AddBoothManagerRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddBoothManagerRequestImpl(userId: json['userId'] as String);

Map<String, dynamic> _$$AddBoothManagerRequestImplToJson(
  _$AddBoothManagerRequestImpl instance,
) => <String, dynamic>{'userId': instance.userId};
