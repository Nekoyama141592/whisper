// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) => UserMeta(
      authNotifications: json['authNotifications'] as List<dynamic>,
      birthDay: json['birthDay'],
      createdAt: json['createdAt'],
      gender: json['gender'] as String,
      isAdmin: json['isAdmin'] as bool,
      isDelete: json['isDelete'] as bool,
      language: json['language'] as String,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$UserMetaToJson(UserMeta instance) => <String, dynamic>{
      'authNotifications': instance.authNotifications,
      'birthDay': instance.birthDay,
      'createdAt': instance.createdAt,
      'gender': instance.gender,
      'isAdmin': instance.isAdmin,
      'isDelete': instance.isDelete,
      'language': instance.language,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
