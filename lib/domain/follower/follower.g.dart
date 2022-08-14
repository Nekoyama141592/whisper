// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Follower _$$_FollowerFromJson(Map<String, dynamic> json) => _$_Follower(
      createdAt: json['createdAt'],
      followedUid: json['followedUid'] as String,
      followerUid: json['followerUid'] as String,
    );

Map<String, dynamic> _$$_FollowerToJson(_$_Follower instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'followedUid': instance.followedUid,
      'followerUid': instance.followerUid,
    };
