// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MuteComment _$$_MuteCommentFromJson(Map<String, dynamic> json) =>
    _$_MuteComment(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentId: json['postCommentId'] as String,
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      postCommentDocRef: json['postCommentDocRef'],
    );

Map<String, dynamic> _$$_MuteCommentToJson(_$_MuteComment instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentId': instance.postCommentId,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'postCommentDocRef': instance.postCommentDocRef,
    };
