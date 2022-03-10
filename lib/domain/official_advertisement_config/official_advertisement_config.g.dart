// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficialAdvertisementConfig _$OfficialAdvertisementConfigFromJson(
        Map<String, dynamic> json) =>
    OfficialAdvertisementConfig(
      createdAt: json['createdAt'],
      displaySeconds: json['displaySeconds'] as int,
      intervalSeconds: json['intervalSeconds'] as int,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$OfficialAdvertisementConfigToJson(
        OfficialAdvertisementConfig instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'displaySeconds': instance.displaySeconds,
      'intervalSeconds': instance.intervalSeconds,
      'updatedAt': instance.updatedAt,
    };
