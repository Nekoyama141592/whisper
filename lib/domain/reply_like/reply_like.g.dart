// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyLike _$ReplyLikeFromJson(Map<String, dynamic> json) => ReplyLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyCreatorUid: json['postCommentReplyCreatorUid'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$ReplyLikeToJson(ReplyLike instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyCreatorUid': instance.postCommentReplyCreatorUid,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
