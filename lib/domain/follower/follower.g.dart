// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follower _$FollowerFromJson(Map<String, dynamic> json) => Follower(
      activeUid: json['activeUid'] as String,
      myUid: json['myUid'] as String,
      createdAt: json['createdAt'],
    );

Map<String, dynamic> _$FollowerToJson(Follower instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'myUid': instance.myUid,
    };
