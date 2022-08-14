// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BookmarkPost _$$_BookmarkPostFromJson(Map<String, dynamic> json) =>
    _$_BookmarkPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      passiveUid: json['passiveUid'] as String,
      postId: json['postId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      bookmarkPostCategoryId: json['bookmarkPostCategoryId'] as String,
    );

Map<String, dynamic> _$$_BookmarkPostToJson(_$_BookmarkPost instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'passiveUid': instance.passiveUid,
      'postId': instance.postId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'bookmarkPostCategoryId': instance.bookmarkPostCategoryId,
    };
