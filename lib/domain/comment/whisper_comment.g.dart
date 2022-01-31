// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperComment _$WhisperCommentFromJson(Map<String, dynamic> json) =>
    WhisperComment(
      accountName: json['accountName'] as String,
      comment: json['comment'] as String,
      postCommentId: json['postCommentId'] as String,
      createdAt: json['createdAt'],
      followerCount: json['followerCount'] as int,
      ipv6: json['ipv6'] as String,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      likeCount: json['likeCount'] as int,
      negativeScore: json['negativeScore'] as num,
      passiveUid: json['passiveUid'] as String,
      positiveScore: json['positiveScore'] as num,
      postId: json['postId'] as String,
      replyCount: json['replyCount'] as int,
      score: json['score'] as num,
      uid: json['uid'] as String,
      updatedAt: json['updatedAt'],
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$WhisperCommentToJson(WhisperComment instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'comment': instance.comment,
      'postCommentId': instance.postCommentId,
      'createdAt': instance.createdAt,
      'followerCount': instance.followerCount,
      'ipv6': instance.ipv6,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'likeCount': instance.likeCount,
      'negativeScore': instance.negativeScore,
      'passiveUid': instance.passiveUid,
      'positiveScore': instance.positiveScore,
      'postId': instance.postId,
      'replyCount': instance.replyCount,
      'score': instance.score,
      'uid': instance.uid,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
