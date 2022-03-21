// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisement _$OfficialAdvertisementFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisement(
      createdAt: json['createdAt'],
      impressionCount: json['impressionCount'] as int,
      impressionCountLimit: json['impressionCountLimit'] as int,
      link: json['link'] as String,
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      subTitle: json['subTitle'] as String,
      tapCount: json['tapCount'] as int,
      tapCountLimit: json['tapCountLimit'] as int,
      title: json['title'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$OfficialAdvertisementToJson(
        OfficialAdvertisement instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'impressionCount': instance.impressionCount,
      'impressionCountLimit': instance.impressionCountLimit,
      'link': instance.link,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'subTitle': instance.subTitle,
      'tapCount': instance.tapCount,
      'tapCountLimit': instance.tapCountLimit,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
    };
