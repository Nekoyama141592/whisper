// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikePost _$LikePostFromJson(Map<String, dynamic> json) => LikePost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
    );

Map<String, dynamic> _$LikePostToJson(LikePost instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
    };
