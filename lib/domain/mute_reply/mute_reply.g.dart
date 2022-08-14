// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MuteReply _$$_MuteReplyFromJson(Map<String, dynamic> json) => _$_MuteReply(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyId: json['postCommentReplyId'] as String,
      tokenType: json['tokenType'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$$_MuteReplyToJson(_$_MuteReply instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyId': instance.postCommentReplyId,
      'tokenType': instance.tokenType,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
