// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserMute _$$_UserMuteFromJson(Map<String, dynamic> json) => _$_UserMute(
      createdAt: json['createdAt'],
      mutedUid: json['mutedUid'] as String,
      muterUid: json['muterUid'] as String,
    );

Map<String, dynamic> _$$_UserMuteToJson(_$_UserMute instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'mutedUid': instance.mutedUid,
      'muterUid': instance.muterUid,
    };
