// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement_tap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisementTap _$OfficialAdvertisementTapFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisementTap(
      createdAt: json['createdAt'],
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$OfficialAdvertisementTapToJson(
        OfficialAdvertisementTap instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'uid': instance.uid,
    };
