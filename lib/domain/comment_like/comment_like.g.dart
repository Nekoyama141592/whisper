// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) => CommentLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      postCommentId: json['postCommentId'] as String,
      postId: json['postId'] as String,
      postCommentCreatorUid: json['postCommentCreatorUid'] as String,
      postCommentDocRef: json['postCommentDocRef'],
    );

Map<String, dynamic> _$CommentLikeToJson(CommentLike instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'postCommentCreatorUid': instance.postCommentCreatorUid,
      'postCommentDocRef': instance.postCommentDocRef,
      'postId': instance.postId,
      'postCommentId': instance.postCommentId,
    };
