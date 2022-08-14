// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserMeta _$$_UserMetaFromJson(Map<String, dynamic> json) => _$_UserMeta(
      createdAt: json['createdAt'],
      email: json['email'] as String,
      gender: json['gender'] as String,
      ipv6: json['ipv6'] as String,
      totalAsset: json['totalAsset'] as num,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
    );

Map<String, dynamic> _$$_UserMetaToJson(_$_UserMeta instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'email': instance.email,
      'gender': instance.gender,
      'ipv6': instance.ipv6,
      'totalAsset': instance.totalAsset,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
    };
