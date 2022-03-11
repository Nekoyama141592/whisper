// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMeta _$UserMetaFromJson(Map<String, dynamic> json) => UserMeta(
      birthDay: json['birthDay'],
      createdAt: json['createdAt'],
      gender: json['gender'] as String,
      isDelete: json['isDelete'] as bool,
      isSuspended: json['isSuspended'] as bool,
      ipv6: json['ipv6'] as String,
      language: json['language'] as String,
      totalAsset: json['totalAsset'] as num,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$UserMetaToJson(UserMeta instance) => <String, dynamic>{
      'birthDay': instance.birthDay,
      'createdAt': instance.createdAt,
      'gender': instance.gender,
      'isDelete': instance.isDelete,
      'isSuspended': instance.isSuspended,
      'ipv6': instance.ipv6,
      'language': instance.language,
      'totalAsset': instance.totalAsset,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
