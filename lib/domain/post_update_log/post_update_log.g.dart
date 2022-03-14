// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_update_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostUpdateLog _$PostUpdateLogFromJson(Map<String, dynamic> json) =>
    PostUpdateLog(
      commentsState: json['commentsState'] as String,
      country: json['country'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      hashTags:
          (json['hashTags'] as List<dynamic>).map((e) => e as String).toList(),
      imageURLs:
          (json['imageURLs'] as List<dynamic>).map((e) => e as String).toList(),
      isPinned: json['isPinned'] as bool,
      language: json['language'] as String,
      links: (json['links'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      postState: json['postState'] as String,
      postId: json['postId'] as String,
      tagAccountNames: (json['tagAccountNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      searchToken: json['searchToken'] as Map<String, dynamic>,
      title: json['title'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$PostUpdateLogToJson(PostUpdateLog instance) =>
    <String, dynamic>{
      'commentsState': instance.commentsState,
      'country': instance.country,
      'description': instance.description,
      'genre': instance.genre,
      'hashTags': instance.hashTags,
      'imageURLs': instance.imageURLs,
      'isPinned': instance.isPinned,
      'language': instance.language,
      'links': instance.links,
      'postState': instance.postState,
      'postId': instance.postId,
      'tagAccountNames': instance.tagAccountNames,
      'searchToken': instance.searchToken,
      'title': instance.title,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
