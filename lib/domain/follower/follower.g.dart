// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follower _$FollowerFromJson(Map<String, dynamic> json) => Follower(
      followerUid: json['followerUid'] as String,
      followedUid: json['followedUid'] as String,
      createdAt: json['createdAt'],
    );

Map<String, dynamic> _$FollowerToJson(Follower instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'followedUid': instance.followedUid,
      'followerUid': instance.followerUid,
    };
