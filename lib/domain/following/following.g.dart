// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Following _$FollowingFromJson(Map<String, dynamic> json) => Following(
      myUid: json['myUid'] as String,
      createdAt: json['createdAt'],
      passiveUid: json['passiveUid'] as String,
    );

Map<String, dynamic> _$FollowingToJson(Following instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'myUid': instance.myUid,
      'passiveUid': instance.passiveUid,
    };
