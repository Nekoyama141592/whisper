// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteUser _$MuteUserFromJson(Map<String, dynamic> json) => MuteUser(
      createdAt: json['createdAt'],
      ipv6: json['ipv6'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$MuteUserToJson(MuteUser instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'ipv6': instance.ipv6,
      'uid': instance.uid,
    };
