// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LikeComment _$LikeCommentFromJson(Map<String, dynamic> json) => LikeComment(
      activeUid: json['activeUid'] as String,
      commentId: json['commentId'] as String,
      createdAt: json['createdAt'],
    );

Map<String, dynamic> _$LikeCommentToJson(LikeComment instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'commentId': instance.commentId,
      'createdAt': instance.createdAt,
    };