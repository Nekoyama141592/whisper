// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReplyMute _$$_ReplyMuteFromJson(Map<String, dynamic> json) => _$_ReplyMute(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentReplyCreatorUid: json['postCommentReplyCreatorUid'] as String,
      postCommentReplyId: json['postCommentReplyId'] as String,
      postCommentReplyDocRef: json['postCommentReplyDocRef'],
    );

Map<String, dynamic> _$$_ReplyMuteToJson(_$_ReplyMute instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentReplyCreatorUid': instance.postCommentReplyCreatorUid,
      'postCommentReplyId': instance.postCommentReplyId,
      'postCommentReplyDocRef': instance.postCommentReplyDocRef,
    };
