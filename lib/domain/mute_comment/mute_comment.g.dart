// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteComment _$MuteCommentFromJson(Map<String, dynamic> json) => MuteComment(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      commentId: json['commentId'] as String,
      tokenId: json['tokenId'] as String,
    );

Map<String, dynamic> _$MuteCommentToJson(MuteComment instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'commentId': instance.commentId,
      'tokenId': instance.tokenId,
    };
