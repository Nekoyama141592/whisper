// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CommentMute _$$_CommentMuteFromJson(Map<String, dynamic> json) =>
    _$_CommentMute(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentCreatorUid: json['postCommentCreatorUid'] as String,
      postCommentDocRef: json['postCommentDocRef'],
      postId: json['postId'] as String,
      postCommentId: json['postCommentId'] as String,
    );

Map<String, dynamic> _$$_CommentMuteToJson(_$_CommentMute instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentCreatorUid': instance.postCommentCreatorUid,
      'postCommentDocRef': instance.postCommentDocRef,
      'postId': instance.postId,
      'postCommentId': instance.postCommentId,
    };
