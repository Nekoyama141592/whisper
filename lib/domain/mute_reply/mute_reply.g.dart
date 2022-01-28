// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteReply _$MuteReplyFromJson(Map<String, dynamic> json) => MuteReply(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      replyId: json['replyId'] as String,
    );

Map<String, dynamic> _$MuteReplyToJson(MuteReply instance) => <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'replyId': instance.replyId,
    };
