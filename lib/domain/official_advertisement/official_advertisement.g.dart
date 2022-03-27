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
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      title: json['title'] as String,
      updatedAt: json['updatedAt'],
      url: json['url'] as String,
    );

Map<String, dynamic> _$OfficialAdvertisementToJson(
        OfficialAdvertisement instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'impressionCount': instance.impressionCount,
      'impressionCountLimit': instance.impressionCountLimit,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
      'url': instance.url,
    };
