// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_adsense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdsense _$OfficialAdsenseFromJson(Map<String, dynamic> json) =>
    OfficialAdsense(
      displaySeconds: json['displaySeconds'] as int,
      intervalSeconds: json['intervalSeconds'] as int,
      link: json['link'] as String,
      subTitle: json['subTitle'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$OfficialAdsenseToJson(OfficialAdsense instance) =>
    <String, dynamic>{
      'displaySeconds': instance.displaySeconds,
      'intervalSeconds': instance.intervalSeconds,
      'link': instance.link,
      'subTitle': instance.subTitle,
      'title': instance.title,
    };
