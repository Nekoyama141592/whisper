// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkPost _$BookmarkPostFromJson(Map<String, dynamic> json) => BookmarkPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      bookmarkLabelId: json['bookmarkLabelId'] as String,
    );

Map<String, dynamic> _$BookmarkPostToJson(BookmarkPost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'bookmarkLabelId': instance.bookmarkLabelId,
    };
