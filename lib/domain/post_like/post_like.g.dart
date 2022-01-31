// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostLike _$PostLikeFromJson(Map<String, dynamic> json) => PostLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$PostLikeToJson(PostLike instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
    };
