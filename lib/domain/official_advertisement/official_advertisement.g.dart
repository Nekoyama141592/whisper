// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisement _$OfficialAdvertisementFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisement(
      createdAt: json['createdAt'],
      impression: json['impression'] as int,
      displaySeconds: json['displaySeconds'] as int,
      intervalSeconds: json['intervalSeconds'] as int,
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
      'impression': instance.impression,
      'displaySeconds': instance.displaySeconds,
      'intervalSeconds': instance.intervalSeconds,
      'link': instance.link,
      'subTitle': instance.subTitle,
      'tapCount': instance.tapCount,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
    };
