// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeReply _$LikeReplyFromJson(Map<String, dynamic> json) => LikeReply(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      replyId: json['replyId'] as String,
    );

Map<String, dynamic> _$LikeReplyToJson(LikeReply instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'replyId': instance.replyId,
    };
