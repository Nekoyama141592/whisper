// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMute _$UserMuteFromJson(Map<String, dynamic> json) => UserMute(
      createdAt: json['createdAt'],
      muterUid: json['muterUid'] as String,
      mutedUid: json['mutedUid'] as String,
    );

Map<String, dynamic> _$UserMuteToJson(UserMute instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'mutedUid': instance.mutedUid,
      'muterUid': instance.muterUid,
    };
