// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) => UserMeta(
      authNotifications: json['authNotifications'] as List<dynamic>,
      birthDay: json['birthDay'],
      bookmarkLabels: json['bookmarkLabels'] as List<dynamic>,
      bookmarks: json['bookmarks'] as List<dynamic>,
      createdAt: json['createdAt'],
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
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      watchlists: json['watchlists'] as List<dynamic>,
    );

Map<String, dynamic> _$UserMetaToJson(UserMeta instance) => <String, dynamic>{
      'authNotifications': instance.authNotifications,
      'birthDay': instance.birthDay,
      'bookmarkLabels': instance.bookmarkLabels,
      'bookmarks': instance.bookmarks,
      'createdAt': instance.createdAt,
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
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'watchlists': instance.watchlists,
    };
