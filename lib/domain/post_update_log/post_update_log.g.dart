// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_update_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostUpdateLog _$PostUpdateLogFromJson(Map<String, dynamic> json) =>
    PostUpdateLog(
      imageURLs:
          (json['imageURLs'] as List<dynamic>).map((e) => e as String).toList(),
      postId: json['postId'] as String,
      title: json['title'] as String,
      searchToken: json['searchToken'] as Map<String, dynamic>,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      updatedAt: json['updatedAt'],
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$PostUpdateLogToJson(PostUpdateLog instance) =>
    <String, dynamic>{
      'imageURLs': instance.imageURLs,
      'postId': instance.postId,
      'title': instance.title,
      'searchToken': instance.searchToken,
      'links': instance.links,
      'updatedAt': instance.updatedAt,
      'uid': instance.uid,
    };
