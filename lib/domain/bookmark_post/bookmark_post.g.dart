// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkPost _$BookmarkPostFromJson(Map<String, dynamic> json) => BookmarkPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
      bookmarkLabelId: json['bookmarkLabelId'] as String,
    );

Map<String, dynamic> _$BookmarkPostToJson(BookmarkPost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
      'bookmarkLabelId': instance.bookmarkLabelId,
    };
