// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OfficialAdvertisement _$$_OfficialAdvertisementFromJson(
        Map<String, dynamic> json) =>
    _$_OfficialAdvertisement(
      createdAt: json['createdAt'],
      intervalSeconds: json['intervalSeconds'] as int,
      timeInSecForIosWeb: json['timeInSecForIosWeb'] as int,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$$_OfficialAdvertisementToJson(
        _$_OfficialAdvertisement instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'intervalSeconds': instance.intervalSeconds,
      'timeInSecForIosWeb': instance.timeInSecForIosWeb,
      'updatedAt': instance.updatedAt,
    };
