// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LikeComment _$$_LikeCommentFromJson(Map<String, dynamic> json) =>
    _$_LikeComment(
      activeUid: json['activeUid'] as String,
      postCommentId: json['postCommentId'] as String,
      createdAt: json['createdAt'],
      tokenId: json['tokenId'] as String,
      tokenType: json['tokenType'] as String,
      postCommentDocRef: json['postCommentDocRef'],
    );

Map<String, dynamic> _$$_LikeCommentToJson(_$_LikeComment instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'postCommentId': instance.postCommentId,
      'createdAt': instance.createdAt,
      'tokenId': instance.tokenId,
      'tokenType': instance.tokenType,
      'postCommentDocRef': instance.postCommentDocRef,
    };
