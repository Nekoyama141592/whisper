// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$WhisperUserMetaFromJson(Map<String, dynamic> json) =>
    UserMeta(
      authNotifications: json['authNotifications'] as List<dynamic>,
      bookmarks: json['bookmarks'] as List<dynamic>,
      followingUids: json['followingUids'] as List<dynamic>,
      gender: json['gender'] as String,
      isAdmin: json['isAdmin'] as bool,
      isDelete: json['isDelete'] as bool,
      likeComments: json['likeComments'] as List<dynamic>,
      likeReplys: json['likeReplys'] as List<dynamic>,
      likes: json['likes'] as List<dynamic>,
      language: json['language'] as String,
      readNotifications: json['readNotifications'] as List<dynamic>,
      readPosts: json['readPosts'] as List<dynamic>,
      searchHistory: json['searchHistory'] as List<dynamic>,
    );

Map<String, dynamic> _$WhisperUserMetaToJson(UserMeta instance) =>
    <String, dynamic>{
      'authNotifications': instance.authNotifications,
      'bookmarks': instance.bookmarks,
      'followingUids': instance.followingUids,
      'gender': instance.gender,
      'isAdmin': instance.isAdmin,
      'isDelete': instance.isDelete,
      'likeComments': instance.likeComments,
      'likeReplys': instance.likeReplys,
      'likes': instance.likes,
      'language': instance.language,
      'readNotifications': instance.readNotifications,
      'readPosts': instance.readPosts,
      'searchHistory': instance.searchHistory,
    };
