// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyLike _$ReplyLikeFromJson(Map<String, dynamic> json) => ReplyLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyId: json['replyId'] as String,
    );

Map<String, dynamic> _$ReplyLikeToJson(ReplyLike instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'replyId': instance.postCommentReplyId,
    };
