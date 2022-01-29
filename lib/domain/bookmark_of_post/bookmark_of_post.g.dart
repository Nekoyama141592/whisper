// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_of_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkOfPost _$BookmarkOfPostFromJson(Map<String, dynamic> json) =>
    BookmarkOfPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$BookmarkOfPostToJson(BookmarkOfPost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
    };
