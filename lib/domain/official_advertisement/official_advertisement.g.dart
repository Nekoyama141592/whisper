// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'official_advertisement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OfficialAdvertisement _$$_OfficialAdvertisementFromJson(
        Map<String, dynamic> json) =>
    _$_OfficialAdvertisement(
      backGroundHex16DarkTheme: json['backGroundHex16DarkTheme'] as String,
      backGroundHex16LightTheme: json['backGroundHex16LightTheme'] as String,
      backGroundOpacity: (json['backGroundOpacity'] as num).toDouble(),
      createdAt: json['createdAt'],
      fontsize: (json['fontsize'] as num).toDouble(),
      impressionCount: json['impressionCount'] as int,
      impressionCountLimit: json['impressionCountLimit'] as int,
      officialAdvertisementId: json['officialAdvertisementId'] as String,
      textHex16DarkTheme: json['textHex16DarkTheme'] as String,
      textHex16LightTheme: json['textHex16LightTheme'] as String,
      textOpacity: (json['textOpacity'] as num).toDouble(),
      title: json['title'] as String,
      updatedAt: json['updatedAt'],
      url: json['url'] as String,
    );

Map<String, dynamic> _$$_OfficialAdvertisementToJson(
        _$_OfficialAdvertisement instance) =>
    <String, dynamic>{
      'backGroundHex16DarkTheme': instance.backGroundHex16DarkTheme,
      'backGroundHex16LightTheme': instance.backGroundHex16LightTheme,
      'backGroundOpacity': instance.backGroundOpacity,
      'createdAt': instance.createdAt,
      'fontsize': instance.fontsize,
      'impressionCount': instance.impressionCount,
      'impressionCountLimit': instance.impressionCountLimit,
      'officialAdvertisementId': instance.officialAdvertisementId,
      'textHex16DarkTheme': instance.textHex16DarkTheme,
      'textHex16LightTheme': instance.textHex16LightTheme,
      'textOpacity': instance.textOpacity,
      'title': instance.title,
      'updatedAt': instance.updatedAt,
      'url': instance.url,
    };
