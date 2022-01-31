// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) => CommentLike(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      commentId: json['commentId'] as String,
    );

Map<String, dynamic> _$CommentLikeToJson(CommentLike instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'commentId': instance.commentId,
    };
