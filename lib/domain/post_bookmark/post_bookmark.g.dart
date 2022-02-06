// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBookmark _$PostBookmarkFromJson(Map<String, dynamic> json) => PostBookmark(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$PostBookmarkToJson(PostBookmark instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
    };
