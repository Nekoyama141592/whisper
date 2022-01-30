// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
      createdAt: json['createdAt'],
      creatorUid: json['creatorUid'] as String,
      isRead: json['isRead'] as bool,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'creatorUid': instance.creatorUid,
      'isRead': instance.isRead,
      'postId': instance.postId,
    };
