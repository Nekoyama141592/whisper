// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) => UserMeta(
      authNotifications: json['authNotifications'] as List<dynamic>,
      birthDay: json['birthDay'],
      createdAt: json['createdAt'],
      followingUids: json['followingUids'] as List<dynamic>,
      gender: json['gender'] as String,
      isAdmin: json['isAdmin'] as bool,
      isDelete: json['isDelete'] as bool,
      likeComments: json['likeComments'] as List<dynamic>,
      likeReplys: json['likeReplys'] as List<dynamic>,
      likes: json['likes'] as List<dynamic>,
      language: json['language'] as String,
      readPosts: json['readPosts'] as List<dynamic>,
      searchHistory: json['searchHistory'] as List<dynamic>,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$UserMetaToJson(UserMeta instance) => <String, dynamic>{
      'authNotifications': instance.authNotifications,
      'birthDay': instance.birthDay,
      'createdAt': instance.createdAt,
      'followingUids': instance.followingUids,
      'gender': instance.gender,
      'isAdmin': instance.isAdmin,
      'isDelete': instance.isDelete,
      'likeComments': instance.likeComments,
      'likeReplys': instance.likeReplys,
      'likes': instance.likes,
      'language': instance.language,
      'readPosts': instance.readPosts,
      'searchHistory': instance.searchHistory,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
