// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement_impression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OfficialAdvertisementImpression _$$_OfficialAdvertisementImpressionFromJson(
        Map<String, dynamic> json) =>
    _$_OfficialAdvertisementImpression(
      createdAt: json['createdAt'],
      isDarkTheme: json['isDarkTheme'] as bool,
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$_OfficialAdvertisementImpressionToJson(
        _$_OfficialAdvertisementImpression instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'isDarkTheme': instance.isDarkTheme,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'uid': instance.uid,
    };
