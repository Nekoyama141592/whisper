// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
      createdAt: json['createdAt'],
      isRead: json['isRead'] as bool,
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
    };
