// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentMute _$CommentMuteFromJson(Map<String, dynamic> json) => CommentMute(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentId: json['postCommentId'] as String,
      postId: json['postId'] as String,
      postCommentCreatorUid: json['postCommentCreatorUid'] as String,
      postCommentDocRef: json['postCommentDocRef'],
    );

Map<String, dynamic> _$CommentMuteToJson(CommentMute instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentCreatorUid': instance.postCommentCreatorUid,
      'postCommentDocRef': instance.postCommentDocRef,
      'postId': instance.postId,
      'postCommentId': instance.postCommentId,
    };
