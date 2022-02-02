// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MutePost _$MutePostFromJson(Map<String, dynamic> json) => MutePost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$MutePostToJson(MutePost instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'passiveUid': instance.passiveUid,
    };
