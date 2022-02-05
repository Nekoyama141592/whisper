// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteReply _$MuteReplyFromJson(Map<String, dynamic> json) => MuteReply(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyId: json['postCommentReplyId'] as String,
      tokenType: json['tokenType'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$MuteReplyToJson(MuteReply instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyId': instance.postCommentReplyId,
      'tokenType': instance.tokenType,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
