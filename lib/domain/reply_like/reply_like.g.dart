// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReplyLike _$$_ReplyLikeFromJson(Map<String, dynamic> json) => _$_ReplyLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyCreatorUid: json['postCommentReplyCreatorUid'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$$_ReplyLikeToJson(_$_ReplyLike instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyCreatorUid': instance.postCommentReplyCreatorUid,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
