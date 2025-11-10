// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedItemImpl _$$FeedItemImplFromJson(Map<String, dynamic> json) =>
    _$FeedItemImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      dDay: (json['dDay'] as num).toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      priority: json['priority'] as String? ?? 'low',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      content: json['content'] as String?,
      organizerName: json['organizerName'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      externalUrl: json['externalUrl'] as String?,
      attachmentUrls:
          (json['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FeedItemImplToJson(_$FeedItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'thumbnailUrl': instance.thumbnailUrl,
      'dDay': instance.dDay,
      'viewCount': instance.viewCount,
      'priority': instance.priority,
      'isBookmarked': instance.isBookmarked,
      'content': instance.content,
      'organizerName': instance.organizerName,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'deadline': instance.deadline?.toIso8601String(),
      'externalUrl': instance.externalUrl,
      'attachmentUrls': instance.attachmentUrls,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
