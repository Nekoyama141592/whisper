// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyMute _$ReplyMuteFromJson(Map<String, dynamic> json) => ReplyMute(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyCreatorUid: json['postCommentReplyCreatorUid'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$ReplyMuteToJson(ReplyMute instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyCreatorUid': instance.postCommentReplyCreatorUid,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
