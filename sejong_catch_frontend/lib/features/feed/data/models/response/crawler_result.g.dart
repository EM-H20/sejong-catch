// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crawler_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CrawlerResultsResponseImpl _$$CrawlerResultsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CrawlerResultsResponseImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => CrawlerResult.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CrawlerResultsResponseImplToJson(
  _$CrawlerResultsResponseImpl instance,
) => <String, dynamic>{'data': instance.data};

_$CrawlerResultImpl _$$CrawlerResultImplFromJson(Map<String, dynamic> json) =>
    _$CrawlerResultImpl(
      id: json['id'] as String,
      noticeKey: json['noticeKey'] as String,
      articleNo: json['articleNo'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      category: json['category'] as String,
      views: (json['views'] as num).toInt(),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$CrawlerResultImplToJson(_$CrawlerResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noticeKey': instance.noticeKey,
      'articleNo': instance.articleNo,
      'title': instance.title,
      'url': instance.url,
      'category': instance.category,
      'views': instance.views,
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
