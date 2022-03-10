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
      link: json['link'] as String,
      subTitle: json['subTitle'] as String,
      tapCount: json['tapCount'] as int,
      title: json['title'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$OfficialAdvertisementToJson(
        OfficialAdvertisement instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'impressionCount': instance.impressionCount,
      'link': instance.link,
      'subTitle': instance.subTitle,
      'tapCount': instance.tapCount,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
    };
