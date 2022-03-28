// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisement _$OfficialAdvertisementFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisement(
      backgroundBlue: json['backgroundBlue'] as int,
      backgroundGreen: json['backgroundGreen'] as int,
      backgroundOpacity: (json['backgroundOpacity'] as num).toDouble(),
      backgroundRed: json['backgroundRed'] as int,
      createdAt: json['createdAt'],
      impressionCount: json['impressionCount'] as int,
      impressionCountLimit: json['impressionCountLimit'] as int,
      isWhiteText: json['isWhiteText'] as bool,
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      title: json['title'] as String,
      updatedAt: json['updatedAt'],
      url: json['url'] as String,
    );

Map<String, dynamic> _$OfficialAdvertisementToJson(
        OfficialAdvertisement instance) =>
    <String, dynamic>{
      'backgroundBlue': instance.backgroundBlue,
      'backgroundGreen': instance.backgroundGreen,
      'backgroundOpacity': instance.backgroundOpacity,
      'backgroundRed': instance.backgroundRed,
      'createdAt': instance.createdAt,
      'impressionCount': instance.impressionCount,
      'impressionCountLimit': instance.impressionCountLimit,
      'isWhiteText': instance.isWhiteText,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
      'url': instance.url,
    };
