// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timeline _$TimelineFromJson(Map<String, dynamic> json) => Timeline(
      createdAt: json['createdAt'],
      postCreatorUid: json['postCreatorUid'] as String,
      isRead: json['isRead'] as bool,
      isDelete: json['isDelete'] as bool,
      postId: json['postId'] as String,
      userImageURL: json['userImageURL'] as String,
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$TimelineToJson(Timeline instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'postCreatorUid': instance.postCreatorUid,
      'isRead': instance.isRead,
      'isDelete': instance.isDelete,
      'postId': instance.postId,
      'userImageURL': instance.userImageURL,
      'userName': instance.userName,
    };
