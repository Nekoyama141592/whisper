// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteUser _$MuteUserFromJson(Map<String, dynamic> json) => MuteUser(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      ipv6: json['ipv6'] as String,
      tokenId: json['tokenId'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$MuteUserToJson(MuteUser instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'ipv6': instance.ipv6,
      'tokenId': instance.tokenId,
      'passiveUid': instance.passiveUid,
    };
