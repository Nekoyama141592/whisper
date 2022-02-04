// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteUser _$MuteUserFromJson(Map<String, dynamic> json) => MuteUser(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$MuteUserToJson(MuteUser instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'passiveUid': instance.passiveUid,
    };
