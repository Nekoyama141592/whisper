// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostBookmark _$$_PostBookmarkFromJson(Map<String, dynamic> json) =>
    _$_PostBookmark(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCreatorUid: json['postCreatorUid'] as String,
      postDocRef: json['postDocRef'],
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$$_PostBookmarkToJson(_$_PostBookmark instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCreatorUid': instance.postCreatorUid,
      'postDocRef': instance.postDocRef,
      'postId': instance.postId,
    };
