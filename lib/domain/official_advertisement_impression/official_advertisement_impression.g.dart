// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement_impression.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisementImpression _$OfficialAdvertisementImpressionFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisementImpression(
      createdAt: json['createdAt'],
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$OfficialAdvertisementImpressionToJson(
        OfficialAdvertisementImpression instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'uid': instance.uid,
    };