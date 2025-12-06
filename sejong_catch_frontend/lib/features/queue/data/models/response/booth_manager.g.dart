// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booth_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BoothManagerImpl _$$BoothManagerImplFromJson(Map<String, dynamic> json) =>
    _$BoothManagerImpl(
      id: json['id'] as String,
      boothId: json['boothObjectId'] as String,
      userId: json['userId'] as String,
      createdAt: const FlexibleDateTimeConverter().fromJson(json['createdAt']),
      updatedAt: const NullableFlexibleDateTimeConverter().fromJson(
        json['updatedAt'],
      ),
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
    );

Map<String, dynamic> _$$BoothManagerImplToJson(_$BoothManagerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boothObjectId': instance.boothId,
      'userId': instance.userId,
      'createdAt': const FlexibleDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const NullableFlexibleDateTimeConverter().toJson(
        instance.updatedAt,
      ),
      'userName': instance.userName,
      'userEmail': instance.userEmail,
    };

_$AddBoothManagerRequestImpl _$$AddBoothManagerRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddBoothManagerRequestImpl(userId: json['userId'] as String);

Map<String, dynamic> _$$AddBoothManagerRequestImplToJson(
  _$AddBoothManagerRequestImpl instance,
) => <String, dynamic>{'userId': instance.userId};
