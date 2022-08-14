// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LikePost _$$_LikePostFromJson(Map<String, dynamic> json) => _$_LikePost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
    );

Map<String, dynamic> _$$_LikePostToJson(_$_LikePost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
    };
