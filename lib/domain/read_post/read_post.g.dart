// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReadPost _$$_ReadPostFromJson(Map<String, dynamic> json) => _$_ReadPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$$_ReadPostToJson(_$_ReadPost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'passiveUid': instance.passiveUid,
    };
