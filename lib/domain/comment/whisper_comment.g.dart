// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'whisper_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WhisperComment _$WhisperCommentFromJson(Map<String, dynamic> json) =>
    WhisperComment(
      comment: json['comment'] as String,
      commentId: json['commentId'] as String,
      followerCount: json['followerCount'] as int,
      ipv6: json['ipv6'] as String,
      isDelete: json['isDelete'] as bool,
      isNFTicon: json['isNFTicon'] as bool,
      isOfficial: json['isOfficial'] as bool,
      likesUidsCount: json['likesUidsCount'] as int,
      negativeScore: (json['negativeScore'] as num).toDouble(),
      passiveUid: json['passiveUid'] as String,
      positiveScore: (json['positiveScore'] as num).toDouble(),
      postId: json['postId'] as String,
      replysCount: json['replysCount'] as int,
      score: (json['score'] as num).toDouble(),
      subUserName: json['subUserName'] as String,
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      userImageURL: json['userImageURL'] as String,
    );

Map<String, dynamic> _$WhisperCommentToJson(WhisperComment instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'commentId': instance.commentId,
      'followerCount': instance.followerCount,
      'ipv6': instance.ipv6,
      'isDelete': instance.isDelete,
      'isNFTicon': instance.isNFTicon,
      'isOfficial': instance.isOfficial,
      'likesUidsCount': instance.likesUidsCount,
      'negativeScore': instance.negativeScore,
      'passiveUid': instance.passiveUid,
      'positiveScore': instance.positiveScore,
      'postId': instance.postId,
      'replysCount': instance.replysCount,
      'score': instance.score,
      'subUserName': instance.subUserName,
      'uid': instance.uid,
      'userName': instance.userName,
      'userImageURL': instance.userImageURL,
    };
