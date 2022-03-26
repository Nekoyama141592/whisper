// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
      createdAt: json['createdAt'],
      isRead: json['isRead'] as bool,
      isDelete: json['isDelete'] as bool,
      postCreatorUid: json['postCreatorUid'] as String,
      postId: json['postId'] as String,
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'isRead': instance.isRead,
      'isDelete': instance.isDelete,
      'postCreatorUid': instance.postCreatorUid,
      'postId': instance.postId,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
