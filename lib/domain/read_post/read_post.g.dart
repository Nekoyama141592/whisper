// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadPost _$ReadPostFromJson(Map<String, dynamic> json) => ReadPost(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$ReadPostToJson(ReadPost instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postId': instance.postId,
    };
